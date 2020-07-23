#!/bin/bash

CONFIG=/var/www/html/config/config.php
MAIN_DOMAIN=$(echo $NEXTCLOUD_TRUSTED_DOMAINS | cut -d' ' -f1)
OVERWRITEPROTOCOL_EXISTS=$(cat $CONFIG | grep 'overwriteprotocol')
IMAP_AUTH_EXISTS=$(cat $CONFIG | grep 'OC_User_IMAP')

/usr/local/bin/php /var/www/html/occ db:add-missing-indices --no-interaction
/usr/local/bin/php /var/www/html/occ db:add-missing-columns --no-interaction
/usr/local/bin/php /var/www/html/occ db:convert-filecache-bigint --no-interaction

if [ -z "${OVERWRITEPROTOCOL_EXISTS}" ]
then
  sed -i "32i\  'overwriteprotocol' => 'https'," $CONFIG
fi

if [ -z "${IMAP_AUTH_EXISTS}" ] && [ -n "${IMAP_AUTH_DOMAIN}" ] && [ -n "${IMAP_AUTH_SERVER}" ]
then
  sed -i "32i\  array ( 0 => array ( 'class' => 'OC_User_IMAP', 'arguments' => array ( 0 => '${IMAP_AUTH_SERVER}', 1 => 993, 2 => 'ssl', 3 => '${IMAP_AUTH_DOMAIN}', 4 => true, 5 => false, ), ), )," $CONFIG
fi

sed -i "s/http:\/\/localhost/${MAIN_DOMAIN}/" $CONFIG

