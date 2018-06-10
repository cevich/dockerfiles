FROM centos:latest
MAINTAINER cevich@redhat.com
ENV container="docker" \
    img_name="test_rhsm"
ADD ["/${img_name}.dockerfile", "/${img_name}.packages", "/root/"]
ADD ["install.sh", "/root/bin/"]
RUN /root/bin/install.sh
