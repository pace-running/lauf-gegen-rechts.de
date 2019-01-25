#!/bin/bash
sudo apt update
sudo apt -y install docker-compose python-pip nfs-common

mkdir /efs

cat <<EOF >/tmp/docker-compose.yml
${docker-compose}
EOF


mkdir /config
cat <<EOF > /config/local.json
${pace-config}
EOF

docker-compose -p pace -f /tmp/docker-compose.yml up
