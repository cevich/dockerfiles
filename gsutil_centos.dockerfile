FROM cevich/gcloud_centos:latest
MAINTAINER cevich@redhat.com
ENV container="docker" \
    img_name="gsutil_centos"
ADD ["/${img_name}.dockerfile", "/root/"]
RUN sed -r -i -e 's_/usr/bin/gcloud_/usr/bin/gsutil_' /root/bin/as_dollar_user.sh
