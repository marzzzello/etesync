# ETESync Docker-Compose

Docker-Compose config for [ETESync](https://www.etesync.com/) based on the [docker-etesync](https://github.com/victor-rds/docker-etesync) repository.

## Usage

```docker-compose up -d --build```

You can then login under under `http://yourhostname/admin` and add users.

## Environment Variables

- **SERVER**: Defines how the container will serve the application, the options are:
  - `standalone` uses start using `./manage runserver`,
  - `uwsgi` start using uWSGI,
  - `uwsgi-http` same as the last but uses HTTP for web servers without wsgi protocol support.
- **DJANGO_HOSTS**:  the ALLOWED_HOSTS settings, must be valid domains separated by `,`. default: `*` (not recommended for production);
- **DJANGO_SECRET**: Defines the `SECRET_KEY`used by django, default: generate a new key every time the container starts.
- **DJANGO_PORT**: the server port defaults to the exposed 8000;
- **DJANGO_LC**: Django language code, default: `en-us`;
- **TZ**: time zone, default `UTC`;
- **SUPER_USER** and **SUPER_PASS**: Username and password of the django superuser (only used if no database is found, must be used together);
- **SUPER_EMAIL**: Email of the django superuser (optional, only used if no database is found);
- **DEBUG**: enable django debug, not recommended for production defaults to False;
- **PUID** and **PGID**: set user and group when running using uwsgi, default: `1000`;

## Volumes

- `/data`: database file location;
- `/var/www/static`: Static files for httpd servers;

## Advanced Customization

Further customization is possible by mounting your own settings file at `/etesync/etesync_server/settings.py`, the defult can be found here: [settings.py](https://github.com/marzzzello/etesync/blob/master/src/settings.py)

