# Dockerfile
FROM centos:centos7

MAINTAINER test

RUN yum update -y

# install package
RUN yum -y install vim git install passwd openssh openssh-server openssh-clients sudo && \

# Create user
    useradd docker && \
    passwd -f -u docker && \

# Set up SSH
    mkdir -p /home/docker/.ssh; chown docker /home/docker/.ssh; chmod 700 /home/docker/.ssh && \
    echo  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDQe+FW4YorDLia4g0SymlWt4ULvrbJa78sP/E65aDHD0wToaFgoi1a2Y5qzC8LmEearZYG02J8MOVDb5of3Va8Wo8TAPIftTOEMoP1l9Il5hku+qqLEsTzYZtBPB7B85sJ7l10giLZDUBryzJv98H7QjJ3nLq8/Yi6u3CZQeVtwniRBDFWCAuFY1O7oPHeVKM3Oi/I7nOCBzqP6PVY+QoAhlw0wF/fxyeGWHIeWVq7KNgwMdXwXCjHhZpjL8zNBfFRrH1QxZx8EHz+aZnlgR6GvKNobOBItc6gpDnV+st7xhADLD0v5Q9F+eMAAMbDMrfzi2uOcNQV4ujK8lOhaEAl docker" > /home/docker/.ssh/authorized_keys && \

    chown docker /home/docker/.ssh/authorized_keys && \
    chmod 600 /home/docker/.ssh/authorized_keys && \

# setup sudoers
    echo "docker ALL=(ALL) ALL" >> /etc/sudoers.d/docker && \

# Set up SSHD config
    sed -ri 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
    sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config && \

# pam認証が有効でもログインできるように
    sed -i -e 's/^\(session.*pam_loginuid.so\)/#\1/g' /etc/pam.d/sshd && \

# 再起動
    /etc/init.d/sshd start
    /etc/init.d/sshd stop

CMD ["/usr/sbin/sshd","-D"]
