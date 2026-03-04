#!/bin/bash

# Salt Docker Setup Script
# This script sets up Salt master and minion using Docker containers

echo "Building Salt Docker images..."

# Build master image
docker build -t salt-master-image -f - . <<EOF
FROM ubuntu:24.04
RUN apt-get update && apt-get install -y curl gnupg
RUN mkdir -m 755 -p /etc/apt/keyrings
RUN curl -fsSL https://packages.broadcom.com/artifactory/api/security/keypair/SaltProjectKey/public | gpg --dearmor | tee /etc/apt/keyrings/salt-archive-keyring.pgp > /dev/null
RUN curl -fsSL https://github.com/saltstack/salt-install-guide/releases/latest/download/salt.sources | tee /etc/apt/sources.list.d/salt.sources
RUN apt-get update && apt-get install -y salt-master salt-minion openssh-server nodejs
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
EXPOSE 22 4505 4506
CMD ["/usr/sbin/sshd", "-D"]
EOF

# Build minion image  
docker build -t salt-minion-image -f - . <<EOF
FROM ubuntu:24.04
RUN apt-get update && apt-get install -y curl gnupg
RUN mkdir -m 755 -p /etc/apt/keyrings
RUN curl -fsSL https://packages.broadcom.com/artifactory/api/security/keypair/SaltProjectKey/public | gpg --dearmor | tee /etc/apt/keyrings/salt-archive-keyring.pgp > /dev/null
RUN curl -fsSL https://github.com/saltstack/salt-install-guide/releases/latest/download/salt.sources | tee /etc/apt/sources.list.d/salt.sources
RUN apt-get update && apt-get install -y salt-minion openssh-server nodejs
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
EOF

echo "Starting Salt containers..."

# Remove existing containers
docker rm -f salt-master salt-minion-bots 2>/dev/null

# Start master container
docker run -d --name salt-master \
    -p 4505:4505 \
    -p 4506:4506 \
    -p 2200:22 \
    -v .:/srv/salt \
    -v ../dedfour_salt_pillar:/srv/pillar \
    salt-master-image /bin/bash -c "mkdir -p /run/sshd && /usr/sbin/sshd -D"

# Start minion container
docker run -d --name salt-minion-bots \
    -p 2201:22 \
    -v .:/srv/salt \
    -v ../dedfour_salt_pillar:/srv/pillar \
    salt-minion-image /bin/bash -c "mkdir -p /run/sshd && /usr/sbin/sshd -D"

echo "Waiting for containers to start..."
sleep 5

# Configure Salt master
docker exec salt-master bash -c "mkdir -p /etc/salt/pki/master /etc/salt/pki/minion /etc/salt/master.d /etc/salt/minion.d"
docker exec salt-master cp /srv/salt/keys/master_minion.pem /etc/salt/pki/master/minion.pem
docker exec salt-master cp /srv/salt/keys/master_minion.pub /etc/salt/pki/master/minion.pub

# Set master minion ID
docker exec salt-master bash -c "echo 'salt-master' > /etc/salt/minion_id"

# Create master configuration
docker exec salt-master bash -c "cat > /etc/salt/master.d/master.conf <<EOF
auto_accept: True
interface: 0.0.0.0
publish_port: 4505
ret_port: 4506
user: root
file_root: /srv/salt
pillar_root: /srv/pillar
log_level: debug
log_file: /var/log/salt/master
key_logfile: /var/log/salt/key

### Grains configuration puts it here.
include:
  - /etc/salt/grains
EOF"

# Create master grains
docker exec salt-master bash -c "cat > /etc/salt/grains <<EOF
roles:
  - master
  - docker
EOF"

# Configure Salt minion
docker exec salt-minion-bots bash -c "mkdir -p /etc/salt/pki/minion /etc/salt/minion.d"
docker exec salt-minion-bots cp /srv/salt/keys/bots.pem /etc/salt/pki/minion/minion.pem
docker exec salt-minion-bots cp /srv/salt/keys/bots.pub /etc/salt/pki/minion/minion.pub

# Set bots minion ID
docker exec salt-minion-bots bash -c "echo 'bots' > /etc/salt/minion_id"

# Create minion grains
docker exec salt-minion-bots bash -c "cat > /etc/salt/grains <<EOF
roles:
  - bots
  - docker
EOF"

# Get master IP
MASTER_IP=$(docker inspect salt-master --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}')

# Configure minion to connect to master
docker exec salt-minion-bots bash -c "echo 'master: $MASTER_IP' > /etc/salt/minion"

# Configure master minion to connect to itself
docker exec salt-master bash -c "echo 'master: 127.0.0.1' > /etc/salt/minion"

# Start Salt services
docker exec salt-master salt-master -d
docker exec salt-master salt-minion -d
docker exec salt-minion-bots salt-minion -d

echo "Waiting for Salt services to start..."
sleep 10

# Accept minion key
docker exec salt-master salt-key -y -a $(docker exec salt-minion-bots cat /etc/salt/minion_id)

echo "Testing Salt setup..."
docker exec salt-master salt '*' test.ping

echo ""
echo "✅ Salt setup complete!"
echo "Master container: salt-master (ports: 4505, 4506, 2200)"
echo "Minion container: salt-minion-bots (port: 2201)"
echo ""
echo "To test manually:"
echo "  docker exec salt-master salt '*' test.ping"
echo "  docker exec salt-minion-bots salt-call test.ping"
