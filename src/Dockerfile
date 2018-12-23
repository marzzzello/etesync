FROM python:alpine

EXPOSE 8000

ENV DATA_PATH=/data \
	ETESYNC_PATH=/etesync

ENV DJANGO_DB_PATH=$DATA_PATH/db.sqlite3 \
	DJANGO_STATICS=/var/www/static \
	DJANGO_PORT=8000 \
	SERVER="standalone"
	
WORKDIR $ETESYNC_PATH

RUN set -e \
	&& adduser -h $ETESYNC_PATH -s /bin/sh -D -H -u 1000 etesync \
	&& apk add --no-cache --virtual .build-deps coreutils gcc make linux-headers libc-dev git \
	&& git clone https://github.com/etesync/server-skeleton.git $ETESYNC_PATH \
	&& rm -rf $ETESYNC_PATH/.git \
	&& pip install -r $ETESYNC_PATH/requirements.txt uwsgi \
	&& apk del .build-deps

COPY settings.py $ETESYNC_PATH/etesync_server/settings.py

RUN set -e \
	&& mkdir -p $DATA_PATH \ 
	&& chown etesync:etesync $DATA_PATH \
	&& mkdir -p $DJANGO_STATICS \
	&& $ETESYNC_PATH/manage.py collectstatic --no-input \
	&& chown -R 33:33 $DJANGO_STATICS
	
VOLUME /data
VOLUME /var/www/static
	
COPY uwsgi.ini etesync.ini
COPY entrypoint.sh /

RUN set -e && chmod 755 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
