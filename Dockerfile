FROM tjinjin/centos7
MAINTAINER krossblack

# package
RUN yum install -y bzip logrotate make net-tools nfs-utils openssh openssh-clients openssh-server \
    openssl passwd rsync rsyslog sudo tar wget && \
    yum update -y && \
    yum clean all

## Create user
RUN useradd docker && \
    passwd -f -u docker && \

## Set up SSH
    mkdir -p /home/docker/.ssh && chown docker /home/docker/.ssh && chmod 700 /home/docker/.ssh && \
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDQe+FW4YorDLia4g0SymlWt4ULvrbJa78sP/E65aDHD0wToaFgoi1a2Y5qzC8LmEearZYG02J8MOVDb5of3Va8Wo8TAPIftTOEMoP1l9Il5hku+qqLEsTzYZtBPB7B85sJ7l10giLZDUBryzJv98H7QjJ3nLq8/Yi6u3CZQeVtwniRBDFWCAuFY1O7oPHeVKM3Oi/I7nOCBzqP6PVY+QoAhlw0wF/fxyeGWHIeWVq7KNgwMdXwXCjHhZpjL8zNBfFRrH1QxZx8EHz+aZnlgR6GvKNobOBItc6gpDnV+st7xhADLD0v5Q9F+eMAAMbDMrfzi2uOcNQV4ujK8lOhaEAl docker" \
> /home/docker/.ssh/authorized_keys  && \
    chown docker /home/docker/.ssh/authorized_keys && \
    chmod 600 /home/docker/.ssh/authorized_keys && \
## setup sudoers
    echo "docker ALL=(ALL) ALL" >> /etc/sudoers.d/docker && \

## Set up SSHD config
    sed -ri 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config && \
    sed -ri 's/^UsePAM yes/#UsePAM no/g' /etc/ssh/sshd_config && \

## Pam認証が有効でもログインするための設定
    sed -i -e 's/^\(session.*pam_loginuid.so\)/#\1/g' /etc/pam.d/sshd && \

    curl -L https://www.chef.io/chef/install.sh | bash
