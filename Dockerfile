FROM everflux/ng-cli

USER root

RUN apt-get update \
 && apt-get install -y \
    chromium \
    xvfb \
 && ln -s /usr/bin/xvfb-chromium /usr/bin/chromium-browser

ADD xvfb-chromium /usr/bin/xvfb-chromium

USER $USER_ID
