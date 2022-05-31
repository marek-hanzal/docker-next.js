FROM alpine:3.16

RUN \
    apk add --no-cache \
        bash npm supervisor
RUN \
    apk add --no-cache --virtual build-essentials \
        bash npm supervisor build-base gcc

RUN wget https://www.imagemagick.org/download/ImageMagick.tar.gz
RUN tar xf ImageMagick.tar.gz
RUN \
  cd ImageMagick* && \
  ./configure --with-heic=yes && \
  make && \
  make install && \
  ldconfig

RUN \
   apk del build-essentials

RUN npm install pm2 -g

ADD rootfs/runtime /

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]

WORKDIR /opt/app

RUN addgroup app
RUN adduser --disabled-password --system --shell /bin/false --no-create-home --gecos "" --home /opt/app --ingroup app app
