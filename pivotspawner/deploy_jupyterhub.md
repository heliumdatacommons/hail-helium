Deploy JupyterHub on Ubuntu
============================

#### 1. Installation 
1. Install dependencies
   ```bash 
   sudo apt-get update 
   sudo apt-get install -y python3 python3-pip npm nodejs-legacy 
   ```
   
2. Install JupyterHub using `pip`

   ```bash
   sudo python3 -m pip install jupyterhub
   sudo npm install -g configurable-http-proxy
   sudo python3 -m pip install notebook  # needed if running the notebook servers locally
   ```
   
3. Generate configuration file
   ```bash 
   sudo mkdir /etc/jupyterhub
   sudo jupyterhub --generate-config -f /etc/jupyterhub/config.py 
   ```

4. Start JupyterHub
   ```
   sudo jupyterhub --ip=0.0.0.0 -f /etc/jupyterhub/config.py 
   ```

#### 2. Use DockerSpawner

1. Install Docker spawner
   ```bash
   sudo pip3 install dockerspawner 
   ```
   
2. Modify the configuration to use DockerSpawner
   ```bash 
   echo "c.JupyterHub.spawner_class = dockerspawner.DockerSpawner" | sudo tee -a /etc/jupyterhub/config.py 
   ```
   
3. Set the container image. Note that the image must be pulled in advance
   ```bash 
   echo "c.DockerSpawner.container_image = 'me/my-image:tag'" | sudo tee -a /etc/jupyterhub/config.py 
   ```
   
4. Set empty command
   ```bash 
   echo "c.DockerSpawner.cmd = ''" | sudo tee -a /etc/jupyterhub/config.py 
   ```
5. Set `c.JupyterHub.hub_ip`
   ```bash 
   echo "c.JupyterHub.hub_ip = '0.0.0.0'" | sudo tee -a /etc/jupyterhub/config.py 
   ```
6. Set `#c.DockerSpawner.hub_ip_connect`
   ```bash 
   echo "c.DockerSpawner.hub_ip_connect = '10.52.100.5'" | sudo tee -a /etc/jupyterhub/config.py 
   ```

#### 3. Use temporary authenticator
1. Install the temporary authenticator
   ```bash
   sudo pip3 install jupyterhub-tmpauthenticator
   ```
   
2. Modify the configuration to use the temporary authenticator
   ```bash
   echo "c.JupyterHub.authenticator_class = tmpauthenticator.TmpAuthenticator" | sudo tee -a /etc/jupyterhub/config.py 
   ```