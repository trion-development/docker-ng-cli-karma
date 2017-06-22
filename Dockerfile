FROM trion/ng-cli:1.1.3

MAINTAINER trion development GmbH "info@trion.de"

USER root

RUN apt-get update \
 && apt-get install -y \
    chromium \
    xvfb \
    libosmesa6 \
 && ln -s /usr/bin/xvfb-chromium /usr/bin/google-chrome \
 && ln -s /usr/bin/xvfb-chromium /usr/bin/chromium-browser \
 && mkdir /usr/lib/chromium-browser/ \
 && ln -s /usr/lib/x86_64-linux-gnu/libOSMesa.so.6 /usr/lib/chromium-browser/libosmesa.so

ADD xvfb-chromium /usr/bin/xvfb-chromium
ADD xvfb-chromium-webgl /usr/bin/xvfb-chromium-webgl


USER $USER_ID
