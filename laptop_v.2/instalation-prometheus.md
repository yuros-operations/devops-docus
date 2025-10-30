## package

```
pacman -S prometheus prometheus-node-exporter
```

```
sudo systemctl enable prometheus.service
```

```
sudo systemctl start prometheus.service
```

### configuration

```
nsudo nvim /etc/prometheus/prometheus.yaml
```

```
scrape_configs:
   - job_name: 'prometheus'
     static_configs:
       - targets: ['localhost:9090']
   - job_name: 'node'
     static_configs:
       - targets: ['localhost:9100']
```

```
sudo systemctl restart prometheus.service
```
