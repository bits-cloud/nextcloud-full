# Evokom nextcloud-full

This is an Image that modifies the default **[nextcloud](https://hub.docker.com/_/nextcloud/)** image, so all options from this image are valid

customizations:

- runs as root
- has php-smb + -imap modules installed
- php:
  - max_execution_time = 300
  - pm.max_children = 50
  - pm.max_requests = 500

### CUSTOM ENV-VARS:

#### IMAP_AUTH: if specified, will setup automatic imap auth in config.php

- IMAP_AUTH_DOMAIN: The Domain that is used to authenticate the users - e.g. gmail.com
- IMAP_AUTH_SERVER: The Server Address for the Mail-Server - e.g. mail.gmail.com
