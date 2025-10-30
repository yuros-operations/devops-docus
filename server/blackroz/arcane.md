```
apk update
```

```
apk upgrade
```

## install docker

```
apk add docker
```

```
rc updtade docker default
```

```
service docker start
```

```
apk add docker-cli-compose

```

```
cd /var/lib
```

```
mv docker docker-old
```

## create docker partition

create docker
```
mkdir /var/lib/docker
```

```
mount /dev/sdb4 /var/lib/docker
```

create fstab
```
echo "UUID=$(blkid -s UUID -o value /dev/sdb4 ) /var/lib/docker ext4 nosuid,noexec,nodev,rw,relatime 0 2 >> /etc/fstab
```

note: edit /etc/fstab

## 

```
cp -fr docker-old/* docker
```

```
cd docker-old
```

```
ls -la
```

```
cd ..
```

```
cd docker
```

```
ls -la
```

note: cek isi direktori docker dan docker-old apakah sudah sama

```
reboot
```

### cek status docker
```
docker info
```

### create compose file

```docker-compose
services:
  arcane:
    image: ghcr.io/ofkm/arcane:latest
    container_name: arcane
    ports:
      - '3552:3552'
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - arcane-data:/app/data
      - /host/path/to/projects:/app/data/projects
    environment:
      - APP_URL=http://localhost:3552
      - PUID=1000
      - PGID=1000
      - ENCRYPTION_KEY=xxxxxxxxxxxxxxxxxxxxxx
      - JWT_SECRET=xxxxxxxxxxxxxxxxxxxxxxxxxx
    restart: unless-stopped
volumes:
  arcane-data:
```

### genereate secrests 

##### encryption keys
```
openssl rand -base64 32
```

##### jwt keys
```
openssl rand -base64 32
```
