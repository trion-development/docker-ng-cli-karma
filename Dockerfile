FROM trion/ng-cli:1.2.0-beta.0

MAINTAINER trion development GmbH "info@trion.de"

USER root

RUN apt-get update \
 && apt-get install -y \
    chromium \
    xvfb \
 && ln -s /usr/bin/xvfb-chromium /usr/bin/google-chrome \
 && ln -s /usr/bin/xvfb-chromium /usr/bin/chromium-browser

ADD xvfb-chromium /usr/bin/xvfb-chromium

USER $USER_ID
