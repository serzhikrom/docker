#!/bin/bash
cat << _EOF_ > Dockerfile
FROM alpine:latest
MAINTAINER Evgeny Savitsky <evgeny.savitsky@devprom.ru>

RUN apk update && apk add curl

RUN echo '* * * * * root curl -L -m 1800 -k "http://127.0.0.1/tasks/command.php?class=runjobs"' >>  /etc/crontab

CMD ["cron", "-f"]
_EOF_

docker pull alpine:latest
docker build -t devprom/alm-cron:latest .
docker push devprom/alm-cron:latest
