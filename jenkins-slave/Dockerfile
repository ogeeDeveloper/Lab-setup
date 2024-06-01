FROM jenkins/inbound-agent:latest

USER root

# Install necessary packages including OpenSSH server
RUN apt-get update && \
    apt-get install -y openssh-server wget curl

# Configure SSH
RUN mkdir /var/run/sshd && \
    echo 'root:root' | chpasswd && \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Prepare SSH for the Jenkins user
RUN mkdir -p /home/jenkins/.ssh && \
    chown -R jenkins:jenkins /home/jenkins/.ssh && \
    chmod 700 /home/jenkins/.ssh

# Download and extract Java Development Kit
RUN wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz -O /tmp/openjdk.tar.gz && \
    tar -xzf /tmp/openjdk.tar.gz -C /opt && \
    ln -s /opt/jdk-17.0.11 /opt/jdk17 && \
    update-alternatives --install /usr/bin/java java /opt/jdk17/bin/java 1 && \
    update-alternatives --set java /opt/jdk17/bin/java

# Generate SSH keys for secure communication
RUN (rm -f /etc/ssh/ssh_host_rsa_key || true) && \
    ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N '' && \
    (rm -f /root/.ssh/id_rsa || true) && \
    ssh-keygen -t rsa -b 4096 -f /root/.ssh/id_rsa -N '' && \
    cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys && \
    chmod 600 /root/.ssh/authorized_keys

# Install Maven
RUN curl -o /tmp/apache-maven-3.9.7-bin.tar.gz https://downloads.apache.org/maven/maven-3/3.9.7/binaries/apache-maven-3.9.7-bin.tar.gz && \
    tar -xvzf /tmp/apache-maven-3.9.7-bin.tar.gz -C /opt && \
    ln -s /opt/apache-maven-3.9.7 /opt/maven && \
    ln -s /opt/maven/bin/mvn /usr/bin/mvn

# Install Docker inside the container to allow Docker operations from within Jenkins slave
RUN curl -fsSL https://get.docker.com -o get-docker.sh && \
    sh get-docker.sh && \
    usermod -aG docker jenkins

# Update PATH to include Java, Maven, and Docker binaries
ENV PATH=$PATH:/usr/bin:/opt/jdk17/bin:/opt/maven/bin

# Copy custom entrypoint script into the container
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose SSH port
EXPOSE 22

# Set entrypoint to initiate SSH daemon
ENTRYPOINT ["/entrypoint.sh"]
