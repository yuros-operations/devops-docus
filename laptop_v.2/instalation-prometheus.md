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
```
sudo systemctl stop firewalld
```

### configuration
```
cd /etc/prometheus
```

```
sudo cp prometheus.yml prometheus.yml.bck
```

```
sudo nvim /etc/prometheus/prometheus.yml
```

tambahkan ke paling bawah
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
