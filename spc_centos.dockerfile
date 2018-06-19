FROM cevich/venv_centos:latest
MAINTAINER cevich@redhat.com
ENV container="docker" \
    img_name="spc_centos"
ADD ["/${img_name}.dockerfile", "/${img_name}.packages", "/root/"]
ADD ["install.sh", "/root/bin/"]
RUN /root/bin/install.sh
