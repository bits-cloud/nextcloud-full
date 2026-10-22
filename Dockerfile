FROM nextcloud:32.0.15
RUN set -ex; \
  \
  apt-get update; \
  apt-get install -y --no-install-recommends \
  ffmpeg \
  ghostscript \
  procps \
  smbclient \
  supervisor \
  libreoffice \
  nano \
  postgresql-client \
  mariadb-client \
  ; \
  rm -rf /var/lib/apt/lists/*

ADD --checksum=sha256:9c26dd516b8147235c4e924c52e2f076fb2b3f278f5457e88918518ebfee9e01 --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/download/2.12.3/install-php-extensions /usr/local/bin/install-php-extensions

RUN install-php-extensions bz2 imap smbclient-1.1.2 \
  && rm /usr/local/bin/install-php-extensions

RUN mkdir -p \
  /var/log/supervisord \
  /var/run/supervisord \
  ;

COPY supervisord.conf /etc

####### CUSTOM SETUP ##########

COPY setup.sh /
COPY startup.sh /

RUN chmod 777 /setup.sh; \
  chmod 777 /startup.sh; \
  sed -i "s/max_execution_time = .*/max_execution_time = 300/" /usr/local/etc/php/php.ini-*; 

ENV IMAP_AUTH_DOMAIN="" \
  IMAP_AUTH_SERVER="" \
  IMAP_AUTH_PORT=993 \
  IMAP_AUTH_SSL_MODE=SSL \
  \
  PREVIEW_MAX=99999 \
  PREVIEW_ENABLED="true" \
  OVERWIRTE_PROTOCOL=https \
  TRASHBIN_RETENTION="auto, 30" \
  VERSIONS_RETENTION="auto, 90" \
  UPGRADE_ALL_APPS="true" \
  INSTALL_APPS="" \
  \
  DATA_DIRECTORY="/var/www/html/data"

EXPOSE 80
###############################

ENV NEXTCLOUD_UPDATE=1


CMD ["/startup.sh"]
