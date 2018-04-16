FROM centos:latest
MAINTAINER cevich@redhat.com
ENV container="docker" \
    img_name="venv_centos"
ADD ["/${img_name}.dockerfile", "/${img_name}.packages", "install.sh", "/root/"]
RUN /root/install.sh
