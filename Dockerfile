FROM nextcloud:30.0.2
RUN set -ex; \
  \
  apt-get update; \
  apt-get install -y --no-install-recommends \
  ffmpeg \
  ghostscript \
  libmagickcore-6.q16-6-extra \
  procps \
  smbclient \
  supervisor \
  libreoffice \
  nano \
  postgresql-client \
  mariadb-client \
  ; \
  rm -rf /var/lib/apt/lists/*

RUN set -ex; \
  \
  savedAptMark="$(apt-mark showmanual)"; \
  \
  apt-get update; \
  apt-get install -y --no-install-recommends \
  libbz2-dev \
  libc-client-dev \
  libkrb5-dev \
  libsmbclient-dev \
  ; \
  \
  docker-php-ext-configure imap --with-kerberos --with-imap-ssl; \
  docker-php-ext-install \
  bz2 \
  imap \
  ; \
  pecl install smbclient; \
  docker-php-ext-enable smbclient; \
  \
  # reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
  apt-mark auto '.*' > /dev/null; \
  apt-mark manual $savedAptMark; \
  ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
  | awk '/=>/ { so = $(NF-1); if (index(so, "/usr/local/") == 1) { next }; gsub("^/(usr/)?", "", so); print so }' \    
  | sort -u \
  | xargs -r dpkg-query --search \
  | cut -d: -f1 \
  | sort -u \
  | xargs -rt apt-mark manual; \
  \
  apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
  rm -rf /var/lib/apt/lists/*

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
