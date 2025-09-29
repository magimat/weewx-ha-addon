ARG BUILD_FROM=hassioaddons/debian-base:3.2.3
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Copy root filesystem
COPY rootfs /

RUN TIMEZONE="America/New_York" \
    && rm /etc/timezone \
    && rm /etc/localtime \
    && echo $TIMEZONE > /etc/timezone \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    \
    && apt-get update \
    && apt-get install -y \
            python3-configobj \
            python3-cheetah \
            python3-pil \
            python3-serial \
            python3-usb \
            python3-ephem \
            sqlite3 unzip python3-distutils wget rsync ssh git \
            python3-paho-mqtt \
    \
    && rm -rf /var/lib/{apt,dpkg,cache,log} \
    && rm -rf /usr/share/doc \
    && rm -rf /usr/share/man \
    && rm -rf /usr/share/locale/[a-d]* \
    && rm -rf /usr/share/locale/[f-z]* \
    && rm -rf /usr/share/locale/e[a-m]* \
    && rm -rf /usr/share/locale/e[o-z]* 


RUN wget http://www.weewx.com/downloads/released_versions/weewx-4.10.2.tar.gz -O /tmp/weewx.tgz \
    && cd /tmp && tar zxvf /tmp/weewx*.tgz \
    && cd weewx-* && python3 ./setup.py build && python3 ./setup.py install --no-prompt \
    \
    && mkdir -p /home/weewx/archive /home/weewx/public_html \
    \
    && git clone https://github.com/matthewwall/weewx-interceptor.git \
    #fix bug interceptor (https://github.com/matthewwall/weewx-interceptor/pull/64)
    && sed -i -e s:data\ =\ str\(self.rfile.read\(length\)\):data\ =\ self.rfile.read\(length\).decode\(\'utf\-8\'\): ./weewx-interceptor/bin/user/interceptor.py \
    && /home/weewx/bin/wee_extension --install weewx-interceptor \
    && /home/weewx/bin/wee_config --reconfigure --driver=user.interceptor --no-prompt

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

#Labels
LABEL \
    io.hass.name="weewx" \
    io.hass.description="HA Addon to run weewx" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Mathieu Girard <mat.girarde@gmail.com>" \
    org.opencontainers.image.title="Weewx" \
    org.opencontainers.image.description="HA Addon to run weewx" \
    org.opencontainers.image.vendor="Mathieu Girard" \
    org.opencontainers.image.authors="Mathieu Girard <mat.girarde@gmail.com>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/magimat/ha-addons/tree/main/weewx" \
    org.opencontainers.image.documentation="https://github.com/magimat/ha-addons/tree/main/weewx/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
