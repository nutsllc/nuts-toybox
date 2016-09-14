#!/bin/sh

db_name=${application}
db_user=${application}
db_user_pass=${application}

apache2_version="2.4.10 (Debian)"
php_version="7.0.7"
lychee_version="3.1.2"
mariadb_version="10.1.14"
app_version=${lychee_version}

containers=( 
    ${fqdn}-${application} 
    ${fqdn}-${application}-db
)
images=(
   nutsllc/toybox-lychee:${lychee_version}
   nutsllc/toybox-mariadb:${mariadb_version}
)
#declare -A components=(
#    ["${project_name}_${containers[0]}_1"]="apache2 php lychee"
#    ["${project_name}_${containers[1]}_1"]="mariadb"
#)
#declare -A component_version=(
#    ['apache2']="${apache2_version}"
#    ['php']="${php_version}"
#    ['lychee']="${lychee_version}"
#    ['mariadb']="${mariadb_version}"
#)

uid=""
gid=""

function __init() {
    
    mkdir -p ${app_path}/bin
    mkdir -p ${app_path}/data/lychee/data
    mkdir -p ${app_path}/data/lychee/uploads
    
    if [ "$(uname)" == 'Darwin' ]; then 
        uid=${USER}
        gid=${GROUPS}
    elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
        uid=$(cat /etc/passwd | grep ^$(whoami) | cut -d : -f3)
        gid=$(cat /etc/group | grep ^$(whoami) | cut -d: -f3)
    fi
    
    cat <<-EOF > ${compose_file}
${containers[0]}:
    image: ${images[0]}
    environment:
        - VIRTUAL_HOST=${fqdn}
        - PROXY_CACHE=true
        - TOYBOX_UID=${uid}
        - TOYBOX_GID=${gid}
    links:
        - ${containers[1]}:mariadb
    volumes:
        - "${app_path}/data/lychee/data:/data"
        - "${app_path}/data/lychee/uploads/big:/uploads/big"
        - "${app_path}/data/lychee/uploads/medium:/uploads/medium"
        - "${app_path}/data/lychee/uploads/thumb:/uploads/thumb"
        - "${app_path}/data/lychee/uploads/import:/uploads/import"
    ports:
        - "80"
${containers[1]}:
    image: ${images[1]}
    volumes:
        - "${app_path}/data/mysql:/var/lib/mysql"
    environment:
        MYSQL_ROOT_PASSWORD: root
        MYSQL_DATABASE: ${db_name}
        MYSQL_USER: ${db_user}
        MYSQL_PASSWORD: ${db_user_pass}
        TOYBOX_UID: ${uid}
        TOYBOX_GID: ${gid}
        TERM: xterm
    ports:
        - "3306"
EOF
}
