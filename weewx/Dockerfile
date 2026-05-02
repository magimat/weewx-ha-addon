FROM homeassistant/armv7-base-debian:bookworm

COPY rootfs /

RUN chmod a+x /etc/cont-init.d/weewx-init.sh

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
            && \
    rm -rf /var/lib/{apt,dpkg,cache,log} && \
    rm -rf /usr/share/doc && \
    rm -rf /usr/share/man && \
    rm -rf /usr/share/locale/[a-d]* && \
    rm -rf /usr/share/locale/[f-z]* && \
    rm -rf /usr/share/locale/e[a-m]* && \
    rm -rf /usr/share/locale/e[o-z]* 

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


