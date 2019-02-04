### Ubuntu

```
sudo -s
apt-get update && apt-get -y install curl docker-compose git && (curl -sSL https://get.docker.com | sh)
mkdir /etc/devprom && cd /etc/devprom && git clone https://github.com/devprom-dev/docker.git ./
docker-compose -f ./compose.yaml up -d

docker run -d --name alm --restart unless-stopped -p 80:80 -p 3306:3306 --cap-add=SYS_ADMIN --cap-add=NET_ADMIN --net=host -v /var/www/devprom:/var/www/devprom -v /home/devprom/docker/php/devprom.ini:/etc/php/7.0/apache2/conf.d/devprom.ini -v /home/devprom/docker/mysql/devprom.cnf:/etc/mysql/conf.d/devprom.cnf -v /home/devprom/docker/apache2/devprom.conf:/etc/apache2/sites-available/000-default.conf -v /etc/localtime:/etc/localtime:ro devprom/alm:latest
```

### CentOS/RedHat

```
yum -y install curl docker-compose git && (curl -sSL https://get.docker.com | sh)
mkdir /etc/devprom && cd /etc/devprom && git clone https://github.com/devprom-dev/docker.git ./
docker-compose -f ./compose.yaml up -d
```

### Debian

```
apt-get update && apt-get -y install curl git 
curl -L https://github.com/docker/compose/releases/download/1.19.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
curl -sSL https://get.docker.com | sh
mkdir /etc/devprom && cd /etc/devprom && git clone https://github.com/devprom-dev/docker.git ./
docker-compose -f ./compose.yaml up -d
```
