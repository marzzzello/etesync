# ETESync Docker Images

Docker image for [ETESync](https://www.etesync.com/) based on the [server-skeleton](https://github.com/etesync/server-skeleton) repository.

## Tags

This build follows some tags of the official Python 3 hub:

- Debian:
  - [`latest` (debian/latest/Dockerfile)](https://github.com/victor-rds/docker-etesync/blob/master/debian/latest/Dockerfile)
  - [`slim` (debian/slim/Dockerfile)](https://github.com/victor-rds/docker-etesync/blob/master/debian/slim/Dockerfile)
  - [`stretch` (debian/stretch/Dockerfile)](https://github.com/victor-rds/docker-etesync/blob/master/debian/slim-stretch/Dockerfile)
  - [`slim-stretch` (debian/slim-stretch/Dockerfile)](https://github.com/victor-rds/docker-etesync/blob/master/debian/slim-stretch/Dockerfile)
- Alpine:
  - [`alpine3.6` (alpine/alpine3.6/Dockerfile)](https://github.com/victor-rds/docker-etesync/blob/master/alpine/alpine3.6/Dockerfile)
  - [`alpine3.7` (alpine/alpine3.7/Dockerfile)](https://github.com/victor-rds/docker-etesync/blob/master/alpine/alpine3.6/Dockerfile)

## Usage

```docker run  -d -e SUPER_USER=admin -e SUPER_PASS=changeme -p 80:8000 -v /path/on/host:/data victorrds/etesync```

Create a container running standalone django server (not recommended for production).

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

Further customization is possible by mounting your own settings file at `/etesync/etesync_server/settings.py`, the defult can be found here: [settings.py](https://github.com/victor-rds/docker-etesync/blob/master/confs/settings.py)

## Compose example using nginx image

Here is a example of a `docker-compose.yml` file using uwsgi to serve the application and nginx as reverse-proxy and serving static files

```yml

version: '2.3'

volumes:
  etestatic:

services:
  etesync:
    container_name: etesync
    hostname: etesync
    image:victorrds/etesync:latest
    expose:
      - 8000
    volumes:
      - etestatic:/var/www/static:rw
    environment:
      - SERVER=uwsgi
      - SUPER_USER=admin
      - SUPER_PASS=admin
    network_mode: "bridge"
  nginx:
    container_name: nginx
    image: nginx:latest
    ports:
      - 443:443
      - 80:80
    volumes:
      - etestatic:/var/www/static:ro
      - ./nginx-example.conf:/etc/nginx/conf.d/default.conf:ro
    links:
      - etesync
    network_mode: "bridge"

```

The file [nginx-example.conf](https://github.com/victor-rds/docker-etesync/blob/master/examples/nginx-example.conf) can be found at the source repository.
