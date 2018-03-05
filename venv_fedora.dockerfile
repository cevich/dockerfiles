FROM docker.io/fedora:latest
MAINTAINER cevich@redhat.com
ENV container="docker" \
    img_name="venv_fedora"
ADD ["/${img_name}.dockerfile", "/${img_name}.packages", "install.sh", "/root/"]
RUN /root/install.sh
