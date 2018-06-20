FROM cevich/venv_centos:latest
MAINTAINER cevich@redhat.com
ENV container="docker" \
    img_name="spc_centos" \
    xtrareq="/root/spc_extra_reqs.txt"
ADD ["/${img_name}.dockerfile", "/${img_name}.packages", "/spc_extra_reqs.txt", "/root/"]
ADD ["install.sh", "/root/bin/"]
RUN /root/bin/install.sh
