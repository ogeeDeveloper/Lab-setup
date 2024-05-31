FROM jenkins/inbound-agent:latest

USER root

# Install OpenSSH server, Java 11, and Maven
RUN apt-get update && \
    apt-get install -y openssh-server wget curl && \
    mkdir /var/run/sshd && \
    echo 'root:root' | chpasswd && \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    mkdir -p /home/jenkins/.ssh && \
    chown -R jenkins:jenkins /home/jenkins/.ssh && \
    chmod 700 /home/jenkins/.ssh && \
    wget https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz -O /tmp/openjdk.tar.gz && \
    tar -xzf /tmp/openjdk.tar.gz -C /opt && \
    ln -s /opt/jdk-11 /opt/jdk11 && \
    update-alternatives --install /usr/bin/java java /opt/jdk11/bin/java 1 && \
    update-alternatives --set java /opt/jdk11/bin/java && \
    (rm -f /etc/ssh/ssh_host_rsa_key || true) && \
    ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N '' && \
    (rm -f /root/.ssh/id_rsa || true) && \
    ssh-keygen -t rsa -b 4096 -f /root/.ssh/id_rsa -N '' && \
    cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys && \
    chmod 600 /root/.ssh/authorized_keys && \
    curl -o /tmp/apache-maven-3.9.7-bin.tar.gz https://downloads.apache.org/maven/maven-3/3.9.7/binaries/apache-maven-3.9.7-bin.tar.gz && \
    tar -xvzf /tmp/apache-maven-3.9.7-bin.tar.gz -C /opt && \
    ln -s /opt/apache-maven-3.9.7 /opt/maven && \
    ln -s /opt/maven/bin/mvn /usr/bin/mvn

# Update PATH
ENV PATH=$PATH:/usr/bin

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22
ENTRYPOINT ["/entrypoint.sh"]
