### Ubuntu/Debian

```
sudo -s
apt-get update && apt-get -y install docker.io
docker run -d --name alm --restart unless-stopped -p 80:80 -p 3306:3306 --env MYSQL_ROOT_PASSWORD=devprom_pass --cap-add=SYS_ADMIN --cap-add=NET_ADMIN -v $(pwd)/backup:/var/www/devprom/backup -v /etc/localtime:/etc/localtime:ro devprom/alm:latest
chown -R www-data:www-data ./
```

### CentOS/RedHat

```
yum -y install curl docker-compose git && (curl -sSL https://get.docker.com | sh)
docker run -d --name alm --restart unless-stopped -p 80:80 -p 3306:3306 --env MYSQL_ROOT_PASSWORD=devprom_pass --cap-add=SYS_ADMIN --cap-add=NET_ADMIN -v $(pwd)/backup:/var/www/devprom/backup -v /etc/localtime:/etc/localtime:ro devprom/alm:latest
```
