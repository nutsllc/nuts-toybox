#!/bin/sh

apache2_version=2.4.23
app_version=${apache2_version}

containers=(
    ${fqdn}-${application}
)
images=(
    nutsllc/toybox-apache2:${apache2_version}
)
declare -A components=(
    ["${project_name}_${containers[0]}_1"]="apache2"
)
declare -A component_version=(
    ['apache2']=${apache2_version}
)

uid=""
gid=""

#function __build() {
#    docker build -t ${containers[0]}:${apache2_version} $TOYBOX_HOME/src/${application}/${apache2_version}
#}

function __init() {

    #__build || {
    #    echo "build error(${application})"
    #    exit 1
    #}

    mkdir -p ${app_path}/bin
    mkdir -p ${app_path}/data/apache2/docroot
    mkdir -p ${app_path}/data/apache2/conf

    uid=$(cat /etc/passwd | grep ^$(whoami) | cut -d : -f3)
    gid=$(cat /etc/group | grep ^$(whoami) | cut -d: -f3)
    
    cat <<-EOF > ${compose_file}
${containers[0]}:
    image: ${images[0]}
    volumes:
        - "/etc/localtime:/etc/localtime:ro"
        - "${app_path}/data/apache2/docroot:/usr/local/apache2/htdocs"
        - "${app_path}/data/apache2/conf:/etc/apache2"
    environment:
        - VIRTUAL_HOST=${fqdn}
        - TOYBOX_UID=${uid}
        - TOYBOX_GID=${gid}
    ports:
        - "80"
EOF
}
