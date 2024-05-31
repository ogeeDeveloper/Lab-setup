FROM jenkins/inbound-agent:latest

USER root

# Install OpenSSH server and Java 11
RUN apt-get update && \
    apt-get install -y openssh-server wget && \
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
    chmod 600 /root/.ssh/authorized_keys

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22
ENTRYPOINT ["/entrypoint.sh"]





# FROM jenkins/inbound-agent:latest
# USER root

# # Install SSH server and configure
# RUN apt-get update && \
#     apt-get install -y openssh-server && \
#     mkdir /var/run/sshd && \
#     echo 'root:root' | chpasswd && \
#     sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
#     sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
#     mkdir -p /home/jenkins/.ssh && \
#     chown -R jenkins:jenkins /home/jenkins/.ssh && \
#     chmod 700 /home/jenkins/.ssh

# COPY entrypoint.sh /entrypoint.sh
# RUN chmod +x /entrypoint.sh

# EXPOSE 22
# ENTRYPOINT ["/entrypoint.sh"]

