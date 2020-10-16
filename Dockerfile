# noVNC + TurboVNC + VirtualGL
# http://novnc.com
# https://turbovnc.org
# https://virtualgl.org

FROM nvidia/cudagl:11.0-runtime-ubuntu20.04

ARG TURBOVNC_VERSION=2.2.5
ARG VIRTUALGL_VERSION=2.6.4
ARG LIBJPEG_VERSION=1.5.2
ARG WEBSOCKIFY_VERSION=0.9.0
ARG NOVNC_VERSION=1.2.0

ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES},display

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gcc \
        libc6-dev \
        libglu1 \
        libglu1:i386 \
        libsm6 \
        libxv1 \
        libxv1:i386 \
        libxtst6:amd64 \
        libxtst6:i386 \
        libxi6 \
        libxrender1 \
        libxft2 \
        make \
        python \
        python-numpy \
        x11-xkb-utils \
        xauth \
        xfonts-base \
        xkb-data \
        mate-desktop-environment \
        ubuntu-mate-themes && \
    rm -rf /var/lib/apt/lists/*

RUN cd /tmp && \
    curl -fsSL -O https://svwh.dl.sourceforge.net/project/turbovnc/${TURBOVNC_VERSION}/turbovnc_${TURBOVNC_VERSION}_amd64.deb \
        -O https://svwh.dl.sourceforge.net/project/libjpeg-turbo/${LIBJPEG_VERSION}/libjpeg-turbo-official_${LIBJPEG_VERSION}_amd64.deb \
        -O https://svwh.dl.sourceforge.net/project/virtualgl/${VIRTUALGL_VERSION}/virtualgl_${VIRTUALGL_VERSION}_amd64.deb \
        -O https://svwh.dl.sourceforge.net/project/virtualgl/${VIRTUALGL_VERSION}/virtualgl32_${VIRTUALGL_VERSION}_amd64.deb && \
    dpkg -i *.deb && \
    rm -f /tmp/*.deb && \
    sed -i 's/$host:/unix:/g' /opt/TurboVNC/bin/vncserver

ENV PATH ${PATH}:/opt/VirtualGL/bin:/opt/TurboVNC/bin:/opt/websockify

RUN curl -fsSL https://github.com/novnc/noVNC/archive/v${NOVNC_VERSION}.tar.gz | tar -xzf - -C /opt && \
    curl -fsSL https://github.com/novnc/websockify/archive/v${WEBSOCKIFY_VERSION}.tar.gz | tar -xzf - -C /opt && \
    mv /opt/noVNC-${NOVNC_VERSION} /opt/noVNC && \
    mv /opt/websockify-${WEBSOCKIFY_VERSION} /opt/websockify && \
    ln -s /opt/noVNC/vnc.html /opt/noVNC/index.html && \
    cd /opt/websockify && make && mv /opt/websockify/rebind.so /opt/websockify/websockify/

COPY self.pem /

COPY xstartup.sh /

RUN echo 'no-remote-connections\n\
no-httpd\n\
no-x11-tcp-connections\n\
no-pam-sessions\n\
permitted-security-types = otp\
' > /etc/turbovncserver-security.conf

EXPOSE 5902
ENV DISPLAY :2

ENV SHELL /bin/bash

ENTRYPOINT ["/opt/websockify/run", "5902", "--cert=/self.pem", "--ssl-only", "--web=/opt/noVNC", "--wrap-mode=ignore", "--", "vncserver", ":2", "-securitytypes", "otp", "-otp", "-xstartup", "/xstartup.sh"]
