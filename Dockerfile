FROM alpine:3.23.3

# System settings.
ENV APP_INSTALL_PATH=/opt/dockovpn
ENV APP_PERSIST_DIR=/opt/dockovpn_data

# Configuration settings with default values
ENV NET_ADAPTER=eth0
ENV HOST_ADDR=""
ENV HOST_TUN_PORT=1194
ENV HOST_TUN_PROTOCOL=udp
ENV CRL_DAYS=3650

WORKDIR ${APP_INSTALL_PATH}

COPY scripts .
COPY config ./config

RUN apk add --no-cache openvpn easy-rsa bash netcat-openbsd zip curl dumb-init iptables && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/bin/easyrsa && \
    mkdir -p ${APP_PERSIST_DIR} && \
    cd ${APP_PERSIST_DIR} && \
    easyrsa init-pki && \
    easyrsa gen-dh && \
    # DH parameters of size 2048 created at /usr/share/easy-rsa/pki/dh.pem
    # Copy DH file
    cp pki/dh.pem /etc/openvpn && \
    # Copy FROM ./scripts/server/conf TO /etc/openvpn/server.conf in DockerFile
    cd ${APP_INSTALL_PATH} && \
    cp config/server.conf /etc/openvpn/server.conf


EXPOSE 1194/${HOST_TUN_PROTOCOL}

VOLUME [ "/opt/dockovpn_data" ]

ENTRYPOINT [ "dumb-init", "./start.sh" ]
CMD [ "" ]
