FROM nextcloud:20.0.3
RUN set -ex; \
  \
  apt-get update; \
  apt-get install -y --no-install-recommends \
  ffmpeg \
  libmagickcore-6.q16-6-extra \
  procps \
  smbclient \
  supervisor \
  libreoffice \
  nano \
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
  | awk '/=>/ { print $3 }' \
  | sort -u \
  | xargs -r dpkg-query -S \
  | cut -d: -f1 \
  | sort -u \
  | xargs -rt apt-mark manual; \
  \
  apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
  rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/log/supervisord;
RUN mkdir -p /var/run/supervisord;

COPY supervisord.conf /

####### CUSTOM SETUP ##########

COPY setup.sh /

RUN chmod 777 /setup.sh && \
  sed -i "s/max_execution_time = 30/max_execution_time = 300/" /usr/local/etc/php/php.ini-*; 

ENV IMAP_AUTH_DOMAIN="" \
  IMAP_AUTH_SERVER="" \
  IMAP_AUTH_PORT=993 \
  IMAP_AUTH_SSL_MODE=SSL \
  \
  PREVIEW_MAX=99999 \
  PREVIEW_ENABLED="true" \
  OVERWIRTE_PROTOCOL=https 

EXPOSE 80
###############################

ENV NEXTCLOUD_UPDATE=1


CMD ["/usr/bin/supervisord", "-c", "/supervisord.conf"]
