FROM centos:7
WORKDIR /var/tmp
ENTRYPOINT ["/sbin/init"]
RUN yum install -y yum-utils createrepo rpm-build rpmdevtools rsync sudo
RUN yum install -y make gcc gcc-c++ git \
    mariadb-devel sqlite-devel libpcap-devel
RUN mkdir /var/tmp/openvnet
RUN yum install -y centos-release-scl