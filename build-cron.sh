FROM alpine:latest

RUN apt-get update && apt-get -y install cron curl

RUN echo '* * * * * root curl -L -m 1800 -k "http://127.0.0.1/tasks/command.php?class=runjobs"' >>  /etc/crontab

CMD ["cron", "-f"]
