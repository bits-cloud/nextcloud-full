#!/bin/bash

echo "run setup" 

function executeOCC()
{
  runuser --user www-data -- /usr/local/bin/php /var/www/html/occ db:add-missing-indices --no-interaction
  runuser --user www-data -- /usr/local/bin/php /var/www/html/occ db:add-missing-columns --no-interaction
  runuser --user www-data -- /usr/local/bin/php /var/www/html/occ db:convert-filecache-bigint --no-interaction

  echo "occ commands executed"
}

function setupConfig()
{
  # IMAP_AUTH_PORT is an INTEGER
  typeset -i IMAP_AUTH_PORT

  CONFIG=/var/www/html/config/config.php
  echo "CONFIG $CONFIG"

  MAIN_DOMAIN=$(echo $NEXTCLOUD_TRUSTED_DOMAINS | cut -d' ' -f1) 
  echo "MAIN_DOMAIN $MAIN_DOMAIN"

  OVERWRITEPROTOCOL_EXISTS=$(cat $CONFIG | grep 'overwriteprotocol')
  echo "OVERWRITEPROTOCOL_EXISTS $OVERWRITEPROTOCOL_EXISTS"

  IMAP_AUTH_EXISTS=$(cat $CONFIG | grep 'OC_User_IMAP') 
  echo "IMAP_AUTH_EXISTS $IMAP_AUTH_EXISTS"


  if [ -z "${OVERWRITEPROTOCOL_EXISTS}" ]
  then
    # insert after line CONFIG = ...
    sed -i "/'overwrite.cli.url'.*/a \  'overwriteprotocol' => 'https'," $CONFIG
  fi

  if [ -z "${IMAP_AUTH_EXISTS}" ] && [ -n "${IMAP_AUTH_DOMAIN}" ] && [ -n "${IMAP_AUTH_SERVER}" ] && [ -n "${IMAP_AUTH_PORT}" ] && [ -n "${IMAP_AUTH_SSL_MODE}" ]
  then
    # insert after line CONFIG = ...
    sed -i "/'overwriteprotocol'.*/a \  array ( 0 => array ( 'class' => 'OC_User_IMAP', 'arguments' => array ( 0 => '${IMAP_AUTH_SERVER}', 1 => ${IMAP_AUTH_PORT}, 2 => '${IMAP_AUTH_SSL_MODE}', 3 => '${IMAP_AUTH_DOMAIN}', 4 => true, 5 => false, ), ), )," $CONFIG
  fi

  # always replace overwrite.cli.url with the main-domain
  sed -i "s/'overwrite.cli.url'.*/'overwrite.cli.url' => '${MAIN_DOMAIN}',/" $CONFIG

  # fix ownership
  chown www-data:root $CONFIG
  echo "config commands executed"
}

executeOCC
setupConfig