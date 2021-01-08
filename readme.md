# Evokom nextcloud-full

This is an Image that modifies the default **[nextcloud](https://hub.docker.com/_/nextcloud/)** image, so all options from this image are valid

#### CURRENT NEXTCLOUD BUG:

[bug with redis and redis no password](https://github.com/nextcloud/docker/issues/1179) can be avoided with:

1. redis-server:
   `redis-server --requirepass <YOUR_PASSWORD>`
2. nextcloud environment variable:
   `REDIS_HOST_PASSWORD: <YOUR_PASSWORD>`

---

customizations:

- has php-smb + -imap modules installed
- php:
  - max_execution_time = 300
- if NEXTCLOUD_TRUSTED_DOMAINS is set, the first domain will be used for the overwrite.cli.url and the trusted domains will be updated with this domain

---

### CUSTOM ENV-VARS:

- **PREVIEW_MAX**: Limits the size of generated files _[optional, default = 99999]_
- **PREVIEW_ENABLED**: Enabled or disables the preview generation can be _true_ or _false_ _[optional, default = true]_

---

- **OVERWIRTE_PROTOCOL**: defines the protocol for the server, http or https _[optional, default = https]_

---

- **IMAP_AUTH_DOMAIN**: The Domain that is used to authenticate the users - e.g. gmail.com
- **IMAP_AUTH_SERVER**: The Server Address for the Mail-Server - e.g. mail.gmail.com
- **IMAP_AUTH_PORT**: The Port for the IMAP-AUTH-SERVER _[optional, default = 993]_
- **IMAP_AUTH_SSL_MODE**: the SSL-Mode for the IMAP-AUTH-SERVER. possible values are ssl, tls or null (insecure connection) _[optional, default = SSL]_

  for more information visit https://github.com/nextcloud/user_external#readme
