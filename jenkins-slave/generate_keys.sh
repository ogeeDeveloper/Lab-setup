#!/bin/bash

# Generate SSH keys if they don't exist
if [ ! -f /root/.ssh/id_rsa ]; then
  mkdir -p /root/.ssh
  chmod 700 /root/.ssh
  echo "Generating SSH key..."
  ssh-keygen -t rsa -b 4096 -f /root/.ssh/id_rsa -N "" -C "jenkins-agent-key"
  cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
  chmod 600 /root/.ssh/authorized_keys
  echo "SSH key generated and added to authorized_keys."
else
  echo "SSH key already exists."
fi
