FROM cevich/venv_centos:latest
MAINTAINER cevich@redhat.com
ENV container="docker" \
    img_name="travis_centos"
ADD ["/${img_name}.dockerfile", "/${img_name}.packages", "install.sh", "/root/"]
RUN /root/install.sh
