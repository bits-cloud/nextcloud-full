# Evokom nextcloud-full

This is an Image that modifies the default **[nextcloud](https://hub.docker.com/_/nextcloud/)** image, so all options from this image are valid

## CURRENT NEXTCLOUD BUG:

[bug with redis and redis no password](https://github.com/nextcloud/docker/issues/1179)
you can prevent this error if you start your redis server with
`redis-server --requirepass yourpassword`
and add the environment variable
`REDIS_HOST_PASSWORD: yourpassword`
to your nextcloud image

customizations:

- has php-smb + -imap modules installed
- php:
  - max_execution_time = 300

### CUSTOM ENV-VARS:

#### IMAP_AUTH: if specified, will setup automatic imap auth in config.php

- IMAP_AUTH_DOMAIN: The Domain that is used to authenticate the users - e.g. gmail.com
- IMAP_AUTH_SERVER: The Server Address for the Mail-Server - e.g. mail.gmail.com
- IMAP_AUTH_PORT: The Port for the IMAP_AUTH_SERVER
- IMAP_AUTH_SSL_MODE: the SSL-Mode for the IMAP_AUTH_SERVER. possible values are ssl, tls or null (insecure connection)

  for more information visit https://github.com/nextcloud/user_external#readme
