#!/bin/sh
set -e

if [ -z "$PUID" ]; then
  export PUID=1000
fi

if [ -z "$PGID" ]; then
  export PGID=1000
fi

if [ ! -z "$@" ]; then
  exec "$@"
fi

if [ ! -f "/data/db.sqlite3" ]; then
  #First run

  $ETESYNC_PATH/manage.py migrate
  chown -R $PUID:$PGID $DATA_PATH

  if [ "$SUPER_USER" -a "$SUPER_PASS" ]; then
    echo "from django.contrib.auth.models import User; User.objects.create_superuser('$SUPER_USER' , '$SUPER_EMAIL', '$SUPER_PASS')" | python manage.py shell
  fi
fi

echo "3: FIRST_RUN  $FIRST_RUN"

if [ $SERVER = 'uwsgi' ]; then
  /usr/local/bin/uwsgi --ini etesync.ini
elif [ $SERVER = 'uwsgi-http' ]; then
  /usr/local/bin/uwsgi --ini etesync.ini:http
else
  $ETESYNC_PATH/manage.py runserver 0.0.0.0:$DJANGO_PORT
fi
