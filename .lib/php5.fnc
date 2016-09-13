#!/bin/sh

apache2_version="2.4.10 (Debian)"
php_version="5.6.23"
mariadb_version="10.1.14"
app_version="${php_version}"

db_root_password="root"
mariadb_alias="mariadb"

containers=(
    ${fqdn}-${application}
    ${fqdn}-${application}-db
)
images=(
    nutsllc/toybox-php:${php_version}
    nutsllc/toybox-mariadb:${mariadb_version}
)
declare -A components=(
    ["${project_name}_${containers[0]}_1"]="apache2 php"
    ["${project_name}_${containers[1]}_1"]="mariadb"
)
declare -A component_version=(
    ['apache2']="${apache2_version}"
    ['php']="${php_version}"
    ['mariadb']="${mariadb_version}"
)
declare -A params=(
    ['mariadb_mysql_root_password']=${db_root_password}
    ['mariadb_mariadb_alias']=${mariadb_alias}
    ['mariadb_term']="xterm"
)

uid=""
gid=""

function __init() {

    mkdir -p ${app_path}/bin
    mkdir -p ${app_path}/data/apache2/docroot
    mkdir -p ${app_path}/data/apache2/conf
    mkdir -p ${app_path}/data/php

    uid=$(cat /etc/passwd | grep ^$(whoami) | cut -d : -f3)
    gid=$(cat /etc/group | grep ^$(whoami) | cut -d: -f3)
    
    cat <<-EOF > ${compose_file}
${containers[0]}:
    image: ${images[0]}
    volumes:
        - "${app_path}/data/apache2/docroot:/usr/local/apache2/htdoc"
        - "${app_path}/data/apache2/conf:/etc/apache2"
        - "${app_path}/data/php:/usr/local/etc/php"
    links:
        - ${containers[1]}:${mariadb_alias}
    environment:
        - VIRTUAL_HOST=${fqdn}
        - TOYBOX_UID=${uid}
        - TOYBOX_GID=${gid}
    ports:
        - "80"

${containers[1]}:
    image: ${images[1]}
    volumes:
        - ${app_path}/data/mysql:/var/lib/mysql
    environment:
        MYSQL_ROOT_PASSWORD: ${db_root_password}
        TOYBOX_UID: ${uid}
        TOYBOX_GID: ${gid}
        TERM: xterm
EOF
}
