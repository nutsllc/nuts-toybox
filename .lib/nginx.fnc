#!/bin/sh

nginx_version=1.11
app_version=${nginx_version}

containers=(
    ${fqdn}-${application}
)
images=(
    nutsllc/toybox-nginx:${nginx_version}
)
declare -A components=(
    ["${project_name}_${containers[0]}_1"]="nginx"
)
declare -A component_version=(
    ['nginx']="${nginx_version}"
)

uid=""
gid=""

function __init() {

    mkdir -p ${app_path}/bin
    mkdir -p ${app_path}/data/nginx/docroot
    mkdir -p ${app_path}/data/nginx/conf

    uid=$(cat /etc/passwd | grep ^$(whoami) | cut -d : -f3)
    gid=$(cat /etc/group | grep ^$(whoami) | cut -d: -f3)
    
    cat <<-EOF > ${compose_file}
${containers[0]}:
    image: ${images[0]}
    volumes:
        - "/etc/localtime:/etc/localtime:ro"
        - "${app_path}/data/nginx/docroot:/usr/share/nginx/html"
        - "${app_path}/data/nginx/conf:/etc/nginx"
    environment:
        - VIRTUAL_HOST=${fqdn}
        - TOYBOX_UID=${uid}
        - TOYBOX_GID=${gid}
    ports:
        - "80"
EOF
}
