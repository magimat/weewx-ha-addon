ARG BUILD_FROM=hassioaddons/debian-base:3.2.3
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Copy root filesystem
COPY rootfs /

# Setup base
RUN sed -i '/Release/d' /etc/apt/sources.list && \
    sed -i '/buster-updates/d' /etc/apt/sources.list && \
    sed -i 's/debian buster/debian sid/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends tzdata vim-tiny lsb-base curl build-essential libpcap0.8-dev python3-dev python3-configobj python3-pil python3-serial python3-usb python3-pip python3-cheetah python3-ephem rtl-sdr rtl-433 mariadb-client python3-mysqldb && \
    pip3 install paho-mqtt && \
    curl -L -O "http://www.weewx.com/downloads/released_versions/python3-weewx_4.1.1-1_all.deb" && \
    dpkg -i "python3-weewx_4.1.1-1_all.deb" && \
    rm "python3-weewx_4.1.1-1_all.deb" && \
    curl -L -o weewx-sdr.zip https://github.com/mitchins/weewx-sdr/archive/master.zip && \
    wee_extension --install weewx-sdr.zip && \
    rm weewx-sdr.zip && \
    wee_config --reconfigure --driver=user.sdr --no-prompt && \
    curl -L -o weewx-influx.zip https://github.com/matthewwall/weewx-influx/archive/master.zip && \
    wee_extension --install weewx-influx.zip && \
    rm weewx-influx.zip && \
    curl -L -o weewx-mqtt.zip https://github.com/matthewwall/weewx-mqtt/archive/master.zip && \
    wee_extension --install weewx-mqtt.zip && \
    curl -L -o /usr/share/weewx/user/wxMesh.py https://raw.githubusercontent.com/bonjour81/station_meteo/master/weewx/driver/wxMesh.py && \
    curl -L -o /usr/share/weewx/user/twi.py https://raw.githubusercontent.com/matthewwall/weewx-twi/master/bin/user/twi.py && \
    curl -L -o /usr/share/weewx/user/owm.py https://github.com/matthewwall/weewx-owm/blob/master/bin/user/owm.py && \
    curl -L -o /usr/share/weewx/user/owfs.py https://raw.githubusercontent.com/matthewwall/weewx-owfs/master/bin/user/owfs.py && \
    curl -L -o /usr/share/weewx/user/interceptor.py https://raw.githubusercontent.com/matthewwall/weewx-interceptor/master/bin/user/interceptor.py && \
    curl -L -o /usr/share/weewx/user/deconz.py https://raw.githubusercontent.com/mitchins/weewx-deconz/master/bin/user/deconz.py && \
    rm -rf /var/lib/apt/lists/*

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

#Labels
LABEL \
    io.hass.name="weewx" \
    io.hass.description="Example add-on by Home Assistant Community Add-ons" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Mitchell Currie <mitch@mitchellcurrie.com>"docker \
    org.opencontainers.image.title="Weewx" \
    org.opencontainers.image.description="Weewx Hassio addon" \
    org.opencontainers.image.vendor="Mitchell Currie" \
    org.opencontainers.image.authors="Mitchell Currie <mitch@mitchellcurrie.com>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://gitlab.com/mitchins/hassio-weewx" \
    org.opencontainers.image.documentation="https://gitlab.com/mitchins/hassio-weewx/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
