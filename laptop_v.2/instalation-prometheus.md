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

```
sudo systemctl enable prometheus-node-exporter.service
```

```
sudo systemctl start prometheus-node-exporter.service
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
         labels:
           app: "promotheus"
   - job_name: 'node'
     static_configs:
       - targets: ['localhost:9100']
         labels:
           app: "exporter"
```

```
sudo systemctl restart prometheus.service
```
