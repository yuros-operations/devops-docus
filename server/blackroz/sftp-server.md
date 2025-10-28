### add group

```
addgroup [group name]
```

### create config 

```
nvim /etc/ssh/sshd_config.d/20-sftp.conf
```

```
Subsystem sftp internal-sftp

Match Group [nama group]
  ChrootDirectory /home/%u
  ForceCommand internal-sftp
  AllowTcpForwarding no
  X11Forwarding no
  PermitTunnel no
```

### restart service

```
rc-service sshd restart
```

### add user 

```
adduser -G [nama group] [nama user]
```

```
chown root:root /home/[nama user]
```

### create file sharing sftp

```
mkdir /home/[nama user]/[nama direktori sharing]
```

```
chmod 755 /home/[nama user/[nama direktori sharing]
```

```
chown -R [nama user]:[nama sftp group] /home/[nama user]/[nama direktori sharing]
```

### partition data

sdb1 = public
sdb2 = kor.bio
sdb3 = intern
sdb4 = jinsei
sdb5 = beetol
sdb6 = yuros

