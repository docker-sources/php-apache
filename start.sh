#!/bin/bash

# A verificação interfa a qual cada arquivo é submetida
# tem como objetivo impedir que, ao montar volumes compartilhados
# seu arquivo pessoal de definição seja acidentalmente substituido

TIPO_AMBIENTE=${TIPO_AMBIENTE:-"prod"}

if [ -d /usr/src/fabiojanio ]; then

	# Diretório de origem
	PHP=/usr/src/fabiojanio/php
	APACHE=/usr/src/fabiojanio/apache

	# Arquivos de destino
	PHP_INI=/usr/local/etc/php/php.ini
	VIRTUALHOST=/etc/apache2/sites-enabled/000-default.conf

	if [ $TIPO_AMBIENTE = 'prod' -o $TIPO_AMBIENTE = 'PROD' ]; then

		if [ ! -f "$PHP_INI" ]; then
			cp $PHP/php.ini-production $PHP_INI
		fi

		if [ ! -f "$VIRTUALHOST" ]; then
			cp -f $APACHE/000-default.conf-production $VIRTUALHOST
		fi

	fi

	if [ $TIPO_AMBIENTE = 'dev' -o $TIPO_AMBIENTE = 'DEV' ]; then

		if [ ! -f "$PHP_INI" ]; then
			cp $PHP/php.ini-development $PHP_INI
		fi

		if [ ! -f "$VIRTUALHOST" ]; then
			cp -f $APACHE/000-default.conf-development $VIRTUALHOST
		fi

	fi

	rm -rf /usr/src/fabiojanio

	if [ -d "/var/www/html" -a ! "$(ls -A /var/www/html)" ]; then
		rm -rf /var/www/html
	fi

fi

exec apache2-foreground