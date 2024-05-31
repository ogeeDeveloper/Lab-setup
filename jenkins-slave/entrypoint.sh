#!/bin/bash

# Start SSH service
service ssh start

# Call key generation script
/generate_keys.sh

# Start Jenkins agent
exec /usr/local/bin/jenkins-agent "$@"
