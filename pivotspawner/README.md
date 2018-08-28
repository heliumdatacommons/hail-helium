PIVOT JupyterHub Spawner
========================
#### Installation

#### JupyterHub Configurations
```python 
c.JupyterHub.spawner_class = PivotSpawner
c.JupyterHub.hub_ip = '0.0.0.0'
c.JupyterHub.hub_connect_ip = '<jupyter-hub-ip>'

c.PivotSpawner.pivot_host = '34.207.192.169'
c.PivotSpawner.pivot_port = 9191
c.PivotSpawner.master_image = 'heliumdatacommons/spark-master:hail'
```

#### Status
- [ ] PIVOT spawner
    - [x] Experimental
    - [ ] Production
- [ ] Packaging
- [ ] OAuth integration
