FROM tjinjin/centos7
MAINTAINER krossblack

# package
RUN yum update -y && \
    yum install -y bzip logrotate make net-tools nfs-utils openssh openssh-clients openssh-server \
    openssl passwd rsync rsyslog sudo tar wget && \
    yum clean all

## Create user
RUN useradd docker && \
    passwd -f -u docker && \

## Set up SSH
    mkdir -p /home/docker/.ssh && chown docker /home/docker/.ssh && chmod 700 /home/docker/.ssh && \
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDD9xrvnB5hR3eecNNAmWSmCAKz3ltUHHvw7yoaJFDMX3Bvq2o97XaUF9GlO188lBO0oPDm7w3R7UnmWFij7v0dPOkzDbH2HEUGR4KiG5AFYpv5zfXbtQ9C586M6raI6hrcjJbg4+sVHiZYEZEJ8zWYoNVI1g/v13UlHCbXHPM9VvZnR1MKoIKE63eNqH7OY1YOg5fg5tgaxU3RQsBn7oXxrZcy4QSOHEBH4LP/Vb9B69OKVJetSpJEg1Ul2DhueJKcXROqGtGeB36zBn6cATKRGs02Pvw2bU7fImmZ0/lQZpJoN9NSN5Kw+SY1el/WVC3GXWR5Q8mFqn4FjI9fmyo3 docker"
    chown docker /home/docker/.ssh/authorized_keys && \
    chmod 600 /home/docker/.ssh/authorized_keys > /home/docker/.ssh/authorized_keys && \
## setup sudoers
    echo "docker ALL=(ALL) ALL" >> /etc/sudoers.d/docker && \

## Set up SSHD config
    sed -ri 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config && \
    sed -ri 's/^UsePAM yes/#UsePAM no/g' /etc/ssh/sshd_config && \

## Pam認証が有効でもログインするための設定
    sed -i -e 's/^\(session.*pam_loginuid.so\)/#\1/g' /etc/pam.d/sshd && \

    service sshd start

    cd /tmp && \
    curl -L https://www.chef.io/chef/install.sh | bash
