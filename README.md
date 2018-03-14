### Ubuntu

```
apt-get update && apt-get -y install curl docker-compose git && (curl -sSL https://get.docker.com | sh)
mkdir /etc/devprom && cd /etc/devprom && git clone https://github.com/devprom-dev/docker.git ./
docker-compose -f ./compose.yaml up -d
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
