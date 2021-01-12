# evokom/nextcloud-full

the [nextcloud-full](https://github.com/evokom/nextcloud-full) repository

This is an Image that modifies the default **[nextcloud](https://hub.docker.com/_/nextcloud/)** image, so all options from this image are valid

### CUSTOMIZATIONS:

- will wait until the database accepts connections until it starts nextcloud
- has php-smb + -imap modules installed
- php:
  - max_execution_time = 300
- if [NEXTCLOUD_TRUSTED_DOMAINS](https://hub.docker.com/_/nextcloud/) is set, the first domain will be used for the overwrite.cli.url and the trusted domains will be updated with this domain

---

### CUSTOM ENV-VARS:

- **PREVIEW_MAX**: Limits the size of generated files  
  _[optional, default = 99999](https://docs.nextcloud.com/server/19/admin_manual/configuration_server/config_sample_php_parameters.html?highlight=preview%20max#previews)_
- **PREVIEW_ENABLED**: Enabled or disables the preview generation can be _true_ or _false_  
  _[optional, default = true](https://docs.nextcloud.com/server/19/admin_manual/configuration_server/config_sample_php_parameters.html?highlight=preview%20max#previews)_
- **OVERWIRTE_PROTOCOL**: defines the protocol for the server, http or https  
  _[optional, default = https](https://docs.nextcloud.com/server/19/admin_manual/configuration_server/reverse_proxy_configuration.html?highlight=overwrite%20protocol)_
- **TRASHBIN_RETENTION**: If the trash bin app is enabled (default), this setting defines the policy for when files and folders in the trash bin will be permanently deleted.  
  _[optional, default = "auto, 30"](https://docs.nextcloud.com/server/19/admin_manual/configuration_server/config_sample_php_parameters.html?#deleted-items-trash-bin)_
- **VERSIONS_RETENTION**: If the versions app is enabled (default), this setting defines the policy for when versions will be permanently deleted.  
  _[optional, default = "auto, 90"](https://docs.nextcloud.com/server/19/admin_manual/configuration_server/config_sample_php_parameters.html?#file-versions)_

---

- **UPGRADE_ALL_APPS**: if this is "true" or "yes", when the container is started, all applications will be upgraded to the latest version _[optional, default = "true"](#)_
- **INSTALL_APPS**: This Variable accept a space sperated list of apps to install. The Appname can be found in the [Nextcloud Appstore](https://apps.nextcloud.com/).  
  When clicking on an App, in the URL for the App "Breeze Dark" will be ".../apps/breezedark", where breezedark is the name of the app  
  Example: _INSTALL_APPS_="[breezedark](https://apps.nextcloud.com/apps/breezedark) [richdocuments](https://apps.nextcloud.com/apps/richdocuments) [files_ebookreader](https://apps.nextcloud.com/apps/files_ebookreader)" _All apps are linked to the appstore, to give you full examples, about the appname_

---

- **IMAP_AUTH_DOMAIN**: The Domain that is used to authenticate the users - e.g. gmail.com  
  _[optional](#)_
- **IMAP_AUTH_SERVER**: The Server Address for the Mail-Server - e.g. mail.gmail.com  
  _[optional](#)_
- **IMAP_AUTH_PORT**: The Port for the IMAP-AUTH-SERVER  
  _[optional, default = 993](#)_
- **IMAP_AUTH_SSL_MODE**: the SSL-Mode for the IMAP-AUTH-SERVER. possible values are ssl, tls or null (insecure connection)  
  _[optional, default = SSL](#)_

  [more information](https://github.com/nextcloud/user_external#readme)
