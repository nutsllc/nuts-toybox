#!/bin/sh

. ${TOYBOX_HOME}/.lib/php5.fnc

php_version="7.0.8"
mariadb_version="10.1.14"
app_version=${php_version}

images=(
    nutsllc/toybox-php:${php_version}
    nutsllc/toybox-mariadb:${mariadb_version}
)
