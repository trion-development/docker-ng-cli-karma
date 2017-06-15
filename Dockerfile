FROM trion/ng-cli:1.1.1

MAINTAINER trion development GmbH "info@trion.de"

USER root

RUN set -xe \
 && (wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -) \
 && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/chrome.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    google-chrome-beta \
    libosmesa6

RUN ln -s /usr/lib/x86_64-linux-gnu/libOSMesa.so.6 /opt/google/chrome-beta/libosmesa.so \
 && sed -i 's,--user-data-dir,--no-sandbox --headless --remote-debugging-port=9222 --user-data-dir,' /opt/google/chrome-beta/google-chrome-beta

USER $USER_ID
