FROM trion/ng-cli:1.1.3

MAINTAINER trion development GmbH "info@trion.de"

USER root

RUN apt-get update \
    && apt-get install -y \
      xvfb \
      libosmesa6 \
      libgconf-2-4 \
 && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
 && (dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install) \
 && mv /usr/bin/google-chrome /usr/bin/google-chrome.real  \
 && ln -s /usr/bin/xvfb-chromium /usr/bin/google-chrome \
 && ln -s /usr/bin/xvfb-chromium /usr/bin/chromium-browser \
 && mkdir /usr/lib/google-chrome/ \
 && ln -s /usr/lib/x86_64-linux-gnu/libOSMesa.so.6 /usr/lib/google-chrome/libosmesa.so

ADD xvfb-chromium /usr/bin/xvfb-chromium
ADD xvfb-chromium-webgl /usr/bin/xvfb-chromium-webgl

USER $USER_ID
