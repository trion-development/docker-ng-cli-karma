FROM trion/ng-cli:alpine

MAINTAINER trion development GmbH "info@trion.de"

USER root

ADD xvfb-chromium /usr/bin/xvfb-chromium
ADD xvfb-chromium-webgl /usr/bin/xvfb-chromium-webgl
ADD display-chromium /usr/bin/display-chromium

# TODD: add https://pkgs.alpinelinux.org/package/edge/community/x86_64/chromium

RUN apk add -U --no-cache \
      xvfb \
      mesa-dev \
      gconf \
      chromium \
 && rm /usr/bin/chromium-browser  \
 && mv /usr/lib/chromium/chromium-launcher.sh /usr/lib/chromium/chromium-launcher.sh.real  \
 && ln -s /usr/lib/chromium/chromium-launcher.sh.real /usr/bin/chromium-browser.real \
 && ln -s /usr/lib/chromium/chromium-launcher.sh.real /usr/bin/google-chrome.real \
 && ln -s /usr/bin/xvfb-chromium /usr/bin/google-chrome \
 && ln -s /usr/bin/xvfb-chromium /usr/bin/chromium-browser \
 && ln -s /usr/lib/libOSMesa.so /usr/lib/chromium/libosmesa.so

USER $USER_ID
