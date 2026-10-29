FROM trion/ng-cli:22.2.5

ARG CHROME_VERSION=<unset> USER_ID=1000

LABEL chrome=$CHROME_VERSION ng-cli='22.2.5'

USER root

COPY xvfb-chromium /usr/bin/xvfb-chromium
COPY xvfb-chromium-webgl /usr/bin/xvfb-chromium-webgl
COPY display-chromium /usr/bin/display-chromium

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      xvfb \
      libxss1 \
      libosmesa6 \
      wget \
      apt-transport-https \
 && MACH=$(uname -m) \
 && [ $MACH = "x86_64" ] && ( \
   wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
   && (dpkg -i google-chrome-stable_current_amd64.deb; apt --fix-broken install -y --no-install-recommends; apt-get -fy install --no-install-recommends; rm google-chrome-stable_current_amd64.deb; apt-get clean; rm -rf /var/lib/apt/lists/* ) \
   && mv /usr/bin/google-chrome-stable /usr/bin/google-chrome.real \
   && mv /opt/google/chrome/chrome /opt/google/chrome/google-chrome.real  \
   && ln -s /usr/lib/x86_64-linux-gnu/libOSMesa.so.6 /opt/google/chrome/libosmesa.so \
   && ln -s /opt/google/chrome/google-chrome.real /opt/google/chrome/chrome \
   && ln -s /opt/google/chrome/google-chrome.real /usr/bin/chrome \
   && rm -rf /opt/google/chrome/WidevineCdm \
   && find /opt/google/chrome/locales -type f ! -name 'en-US.pak' -delete \
   ) || true  \
 && [ $MACH != "x86_64" ] && ( \
   echo "deb http://deb.debian.org/debian bookworm main" >> /etc/apt/sources.list.d/debian.list \
   && echo "deb http://deb.debian.org/debian bookworm-updates main" >> /etc/apt/sources.list.d/debian.list \
   && echo 'Package: chromium*' >> /etc/apt/preferences.d/chromium.pref \
   && echo 'Pin: origin "ftp.debian.org"' >> /etc/apt/preferences.d/chromium.pref \
   && echo 'Pin-Priority: 700' >> /etc/apt/preferences.d/chromium.pref \
   && apt-get update; apt-get -fy install chromium; apt-get clean; rm -rf /var/lib/apt/lists/* \
   && mv /usr/bin/chromium /usr/bin/google-chrome.real \
 ) || true \
 && rm -f /etc/alternatives/google-chrome \
 && rm -f /usr/bin/google-chrome \
 && ln -s /usr/bin/xvfb-chromium /usr/bin/google-chrome \
 && ln -s /usr/bin/xvfb-chromium /etc/alternatives/google-chrome \
 && ln -s /usr/bin/xvfb-chromium /usr/bin/chromium-browser 

# fail the build if the || true fallbacks above hid a missing xvfb or chrome
RUN command -v Xvfb && test -x /usr/bin/google-chrome.real


# This may be desired, but breaks past behaviour
# https://github.com/trion-development/docker-ng-cli-karma/issues/23
# USER $USER_ID
