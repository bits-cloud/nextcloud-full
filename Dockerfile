FROM nextcloud:19.0.1-fpm

RUN set -ex; \
  \
  apt-get update; \
  apt-get install -y --no-install-recommends \
  ffmpeg \
  libmagickcore-6.q16-6-extra \
  procps \
  smbclient \
  supervisor \
  #       libreoffice \
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

COPY supervisord.conf /

####### CUSTOM SETUP ##########

RUN apt-get update && \
  apt-get install -y nginx && \
  apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false;

COPY nginx.conf /etc/nginx/nginx.conf
COPY setup-config.sh /

RUN chmod 777 /setup-config.sh && \
  sed -i "s/max_execution_time = 30/max_execution_time = 300/" /usr/local/etc/php/php.ini-*; \
  sed -i "s/www-data/root/g" /usr/local/etc/php-fpm.d/www.conf; \
  sed -i "s/pm.max_children = 5/pm.max_children = 50/g" /usr/local/etc/php-fpm.d/www.conf; \
  sed -i "s/;pm.max_requests = 500/pm.max_requests = 500/g" /usr/local/etc/php-fpm.d/www.conf; \
  sed -i "s/= 0/= 9999/g" /entrypoint.sh; \
  mv /var/spool/cron/crontabs/www-data /var/spool/cron/crontabs/root

ENV IMAP_AUTH_DOMAIN=
ENV IMAP_AUTH_SERVER=

EXPOSE 80
###############################

ENV NEXTCLOUD_UPDATE=1

CMD ["/usr/bin/supervisord", "-c", "/supervisord.conf"]
