### Debian/Ubuntu

```
apt-get -y install docker-compose git && (curl -sSL https://get.docker.com | sh)
mkdir /etc/devprom && cd /etc/devprom && git clone https://github.com/devprom-dev/docker.git ./
docker-compose -f ./compose.yaml up -d
```

### CentOS/RedHat

```
yum -y install docker-compose git && (curl -sSL https://get.docker.com | sh)
mkdir /etc/devprom && cd /etc/devprom && git clone https://github.com/devprom-dev/docker.git ./
docker-compose -f ./compose.yaml up -d
```
