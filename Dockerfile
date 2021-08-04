FROM debian:bullseye

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    duply \
    haveged \
    ncftp \
    pwgen \
    rsync \
    openssh-client \
    python3-b2sdk \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

ENV HOME /root

ENV KEY_TYPE      RSA
ENV KEY_LENGTH    2048
ENV SUBKEY_TYPE   RSA
ENV SUBKEY_LENGTH 2048
ENV NAME_REAL     Duply Backup
ENV NAME_EMAIL    duply@localhost
ENV PASS_FILE     invalid

VOLUME ["/root"]

COPY run.sh /run.sh

ENTRYPOINT ["/run.sh"]

CMD ["bash"]