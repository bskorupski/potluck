#!/bin/sh

# shellcheck disable=SC1091
if [ -e /root/.env.cook ]; then
    . /root/.env.cook
fi

set -e
# shellcheck disable=SC3040
set -o pipefail

export PATH=/usr/local/bin:$PATH

# If we do not find a Nextcloud installation, we install it. If we do find something though,
# we do not install/overwrite anything as we assume that updates/modifications are happening
# from within the Nextcloud installation.
# removed: nextcloud-twofactor_totp-php81 (included in nextcloud for v 25.0.1 on)
if [ ! -e /usr/local/www/nextcloud/status.php ]; then
	pkg update -qf
	pkg install -y nextcloud-php81 \
	  nextcloud-deck-php81 \
	  nextcloud-mail-php81 \
	  nextcloud-contacts-php81 \
	  nextcloud-calendar-php81 \
	  nextcloud-end_to_end_encryption-php81
	if [ -f /usr/local/www/nextcloud/config/config.php ]; then
		mv /usr/local/www/nextcloud/config/config.php /usr/local/www/nextcloud/config/config.php.potbak
		touch /usr/local/www/nextcloud/config/config.php
		chown www:www /usr/local/www/nextcloud/config/config.php
		chmod 660 /usr/local/www/nextcloud/config/config.php
	fi
fi
