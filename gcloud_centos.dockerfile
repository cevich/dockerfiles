FROM centos:latest
MAINTAINER cevich@redhat.com
ENV container="docker" \
    img_name="gcloud_centos"
ADD ["/${img_name}.dockerfile", "/${img_name}.packages", "/root/"]
ADD ["/install.sh", "/as_dollar_user.sh", "/root/bin/"]
ENTRYPOINT [ "/root/bin/as_dollar_user.sh" ]
RUN /root/bin/install.sh
