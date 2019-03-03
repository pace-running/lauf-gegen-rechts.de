#!/bin/bash
sudo apt update
sudo apt -y install docker-compose python-pip nfs-common

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCp3klY63p1eyoQ9g3jGsMMPj+x3vujv/2/zE/wbv3vuObH7wUtEUuryjU3h2/Kq2ET5rowdO7GHPh0Cclr7niuSoUv3JzOt8Lh1aOCGiDFMKAyer+SjvDNzRLuq+ra7uu32dA6sBKRhIfpjwm2Le5qidwS7za7/TIU0je4vfPDbMlwmoYX1QakPKDiBKo9+wZ1ZnTdQQCT1mgd9/Pq2sPhnpXdOiNHaigvovl+RWtyBuc9nBoYrnP/amnlTCfy4CEZ9kwP7eJvIp2LwyIHaIu07sDExrFm0KGhlVwsNna2ZDIat1neY+CE5/bcveK8w6pfd9HlNNZ49cwRq/f1empDMz0ogkAaX9EU9nkX2R2zIJWuhc993aOpurrqUBk4G4emVESQ6MBrJTkZAF5RAmzKjjRKzgK4zgJ1y8qck9MaTuwUT+LP3GvcWpVrs3Tz5lHHtHmtXrr4NR81OOXNzbZ/OKerOCFlKxYRUO6i4TlAg0yPQRzunpT/1S3VFNKgAgW4KQxNo4meJC7kCaNOMAgzhm9jfDoKHOUWasnnHq/qKA3evywMZJeO//IDMOOzrdFhzapaSw4hsPogqSrbU3+nNtudsCERBuW55LbXHgPB3EcBd6ykjtXdaEm9qgmDdSY8pNmBZEauKqO1r72NEuaEHQMaD5NCyu1hEXgJ0uqm0Q== cardno:000607125943" >> /home/ubuntu/.ssh/authorized_keys
chown ubuntu: /home/ubuntu/.ssh/authorized_keys
chmod 0600 /home/ubuntu/.ssh/authorized_keys

mkdir /efs

# mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 fs-fs-37159d6e.efs.${region}.amazonaws.com:/ /efs

cat <<EOF >/tmp/docker-compose.yml
${docker-compose}
EOF


mkdir /config
cat <<EOF > /config/local.json
${pace-config}
EOF

docker-compose -p pace -f /tmp/docker-compose.yml up
