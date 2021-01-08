#!/bin/bash

echo "set protocol to http or https"
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set overwriteprotocol --value=${OVERWIRTE_PROTOCOL} --no-interaction

echo "set overwrite.cli.url and trusted_domains"
MAIN_DOMAIN=$(echo $NEXTCLOUD_TRUSTED_DOMAINS | cut -d' ' -f1) 
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set overwrite.cli.url --value=${MAIN_DOMAIN:='localhost'} --no-interaction
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set trusted_domains 1 --value=${MAIN_DOMAIN:='localhost'} --no-interaction
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set trusted_domains 2 --value=www.${MAIN_DOMAIN:='localhost'} --no-interaction

echo "set preview size"
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set preview_max_x --value=${PREVIEW_MAX} --type=integer --no-interaction
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set preview_max_y --value=${PREVIEW_MAX} --type=integer --no-interaction

echo "set preview generation"
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set enable_previews --value=${PREVIEW_ENABLED} --type=boolean --no-interaction

echo "set IMAP Auth"
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set user_backends 0 class --value=OC_User_IMAP --no-interaction
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set user_backends 0 arguments 0 --value=${IMAP_AUTH_SERVER} --no-interaction
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set user_backends 0 arguments 1 --value=${IMAP_AUTH_PORT} --type=integer --no-interaction
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set user_backends 0 arguments 2 --value=${IMAP_AUTH_SSL_MODE} --no-interaction
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set user_backends 0 arguments 3 --value=${IMAP_AUTH_DOMAIN} --no-interaction
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set user_backends 0 arguments 4 --value=true --type=boolean --no-interaction
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ config:system:set user_backends 0 arguments 5 --value=false --type=boolean  --no-interaction

echo "fix database"
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ db:add-missing-indices --no-interaction
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ db:add-missing-columns --no-interaction
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ db:add-missing-primary-keys --no-interaction
runuser --user www-data -- /usr/local/bin/php /var/www/html/occ db:convert-filecache-bigint --no-interaction

echo "occ commands executed"
