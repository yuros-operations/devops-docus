```
sudo nvim /etc/ssh/sshd_config.d/sshd.conf
```

uncommanting yang ada di bawah

```
Include /etc/ssh/sshd_config.d/*.conf

MaxAuthTries 2

AuthorizedKeysFile      .ssh/authorized_keys

PasswordAuthentication no
PermitEmptyPasswords no

X11Forwarding no

Subsystem     sftp   /usr/lib/ssh/sftp-server
```

setelah itu 

```
sudo systemctl restart sshd
```
