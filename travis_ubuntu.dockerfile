FROM cevich/travis_ubuntu:latest
MAINTAINER cevich@redhat.com
ENV container="docker" \
    img_name="travis_ubuntu"
ADD ["/${img_name}.dockerfile", "/${img_name}.packages", "install.sh", "/root/"]
RUN /root/install.sh
