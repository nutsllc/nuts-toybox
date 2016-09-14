#!/bin/bash

nginx_version=1.11
app_version=${nginx_version}

containers=(
    ${application}-nginx 
    ${application}-docker-gen
)
images=(
    nutsllc/toybox-nginx:${nginx_version}
    nutsllc/toybox-dynamic-proxy
)
    #jwilder/docker-gen

#declare -A components=(
#    ["${project_name}_${containers[0]}_1"]="nginx"
#    ["${project_name}_${containers[1]}_1"]="docker-gen"
#)
#declare -A component_version=(
#    ['nginx']=${nginx_version}
#    ['docker-gen']="n/a"
#)

function __post_run() {
    echo "complete!"
    echo "--------------------------------------"
    echo "toybox-proxy is ready!"
    echo "--------------------------------------"
}

function __init() {

    mkdir -p ${app_path}/bin
    mkdir -p ${app_path}/data/nginx/conf.d
    mkdir -p ${app_path}/data/nginx/vhost.d
    mkdir -p ${app_path}/data/nginx/docroot
    mkdir -p ${app_path}/data/nginx/certs

    if [ "$(uname)" == 'Darwin' ]; then 
        uid=${USER}
        gid=${GROUPS}
    elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
        uid=$(cat /etc/passwd | grep ^$(whoami) | cut -d : -f3)
        gid=$(cat /etc/group | grep ^$(whoami) | cut -d: -f3)
    fi
    
    cat <<-EOF > ${compose_file}
${containers[0]}:
    #restart: always
    image: ${images[0]}
    volumes:
        - "/etc/localtime:/etc/localtime:ro"
        - "${app_path}/data/nginx/conf.d:/etc/nginx/conf.d"
        - "${app_path}/data/nginx/vhost.d:/etc/nginx/vhost.d"
        - "${app_path}/data/nginx/docroot:/usr/share/nginx/html"
        - "${app_path}/data/nginx/certs:/etc/nginx/certs"
    log_driver: "json-file"
    log_opt:
        max-size: "3m"
        max-file: "7"
    environment:
        - TOYBOX_UID=${uid}
        - TOYBOX_GID=${gid}
    ports:
        - "80:80"
        - "443:443"

${containers[1]}:
    #restart: always
    image: ${images[1]}
    links:
        - ${containers[0]}
    volumes_from:
        - ${containers[0]}
    volumes:
        - "/etc/localtime:/etc/localtime:ro"
        - "/var/run/docker.sock:/tmp/docker.sock:ro"
        #- "${src}/docker-gen/docker-gen.conf:/docker-gen.conf"
        #- "${src}/docker-gen/templates:/etc/docker-gen/templates"
    log_driver: "json-file"
    log_opt:
        max-size: "3m"
        max-file: "7"
    command: -config /docker-gen.conf
EOF
}
