#!/bin/bash

echo "execute upgrade"
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ upgrade --verbose --no-interaction


if [[ -n "${SMTP_HOST}" ]]; then
  echo "enable nextcloud SMTP"

  SMTP_AUTH='false'
  if [[ -n "${SMTP_AUTHTYPE}" ]]; then
    SMTP_AUTH='true'
  fi
 
 
  runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set mail_smtphost --value="${SMTP_HOST}" --no-interaction
  runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set mail_smtpport --value="${SMTP_PORT:=465}" --no-interaction
  runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set mail_smtpmode --value="smtp" --no-interaction
  runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set mail_sendmailmode --value="smtp" --no-interaction
  runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set mail_smtpauth --value="${SMTP_AUTH}" --type=boolean --no-interaction
  runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set mail_smtpname --value="${SMTP_NAME}" --no-interaction
  runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set mail_smtppassword --value="${SMTP_PASSWORD}" --no-interaction
  runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set mail_from_address --value="${MAIL_FROM_ADDRESS}" --no-interaction
  runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set mail_domain --value="${MAIL_DOMAIN}" --no-interaction
  runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set mail_smtpsecure --value="${SMTP_SECURE}" --no-interaction
  runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set mail_smtpauthtype --value="${SMTP_AUTHTYPE:=LOGIN}" --no-interaction

fi


echo "enable redis or APCu as cache"
if [[ -n "${REDIS_HOST}" ]]; then
  runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set redis host --value="${REDIS_HOST}" --no-interaction
  runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set redis port --value="${REDIS_HOST_PORT:=6379}" --type="integer" --no-interaction
  if [[ -n "${REDIS_HOST_PASSWORD}" ]]; then
    runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set redis password --value="${REDIS_HOST_PASSWORD}" --no-interaction
  fi  

  runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set memcache.local --value="\OC\Memcache\APCu" --no-interaction
  runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set memcache.distributed --value="\OC\Memcache\Redis" --no-interaction
  runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set memcache.locking --value="\OC\Memcache\Redis" --no-interaction
  
else
  runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set memcache.local --value="\OC\Memcache\APCu" --no-interaction
  runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set memcache.distributed --value="\OC\Memcache\APCu" --no-interaction
  runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set memcache.locking --value="\OC\Memcache\APCu" --no-interaction
fi
if [[ -n "${DEFAULT_PHONE_REGION}" ]]; then
  echo "set default phone region"
  runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set default_phone_region --value="${DEFAULT_PHONE_REGION}" --no-interaction
fi

echo "set protocol to http or https"
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set overwriteprotocol --value="${OVERWIRTE_PROTOCOL}" --no-interaction

echo "set overwrite.cli.url and trusted_domains"
MAIN_DOMAIN=$(echo $NEXTCLOUD_TRUSTED_DOMAINS | cut -d' ' -f1) 
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set overwrite.cli.url --value="${MAIN_DOMAIN:='localhost'}" --no-interaction
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set trusted_domains 1 --value="${MAIN_DOMAIN:='localhost'}" --no-interaction
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set trusted_domains 2 --value="www.${MAIN_DOMAIN:='localhost'}" --no-interaction

echo "set preview size"
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set preview_max_x --value="${PREVIEW_MAX}" --type=integer --no-interaction
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set preview_max_y --value="${PREVIEW_MAX}" --type=integer --no-interaction

echo "set preview generation"
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set enable_previews --value="${PREVIEW_ENABLED}" --type=boolean --no-interaction

echo "set IMAP Auth"
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set user_backends 0 arguments 0 --value="${IMAP_AUTH_SERVER}" --no-interaction
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set user_backends 0 arguments 1 --value="${IMAP_AUTH_PORT}" --type=integer --no-interaction
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set user_backends 0 arguments 2 --value="${IMAP_AUTH_SSL_MODE}" --no-interaction
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set user_backends 0 arguments 3 --value="${IMAP_AUTH_DOMAIN}" --no-interaction
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set user_backends 0 arguments 4 --value=true --type=boolean --no-interaction
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set user_backends 0 arguments 5 --value=false --type=boolean  --no-interaction
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set user_backends 0 class --value=OC_User_IMAP --no-interaction

echo "fix database"
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ db:add-missing-indices --no-interaction
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ db:add-missing-columns --no-interaction
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ db:add-missing-primary-keys --no-interaction
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ db:convert-filecache-bigint --no-interaction

echo "set retention"
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set trashbin_retention_obligation --value="${TRASHBIN_RETENTION}" --no-interaction
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set versions_retention_obligation --value="${VERSIONS_RETENTION}" --no-interaction

echo "installing applications user_external"
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ app:install user_external --no-interaction

if [ "${UPGRADE_ALL_APPS}" = "true" ] || [ "${UPGRADE_ALL_APPS}" = "yes" ]
then
  echo "upgrading applications"
  runuser --user www-data -- /usr/local/bin/php /var/www/html/occ app:update --all --no-interaction
fi

echo "installing applications from INSTALL_APPS variable"
for APP in $INSTALL_APPS; do
  echo "installing application ${APP}"
  runuser --user www-data -- /usr/local/bin/php /var/www/html/occ app:install "${APP}" --no-interaction
done

echo "occ commands executed"
