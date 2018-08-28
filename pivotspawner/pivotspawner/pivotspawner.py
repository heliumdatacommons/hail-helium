import jupyterhub
import tornado.escape

from tornado import gen
from tornado.httpclient import AsyncHTTPClient

from traitlets import default, Unicode

from jupyterhub.spawner import Spawner


host = '34.207.192.169'
port = 9191

body = {
  "id": "hail",
  "containers": [
    {
      "id": "spark-master",
      "type": "service",
      "image": "dchampion24/hail",
      "resources": {
        "cpus": 2,
        "mem": 2048
      },
      "network_mode": "container",
      "ports": [
        {"container_port": 8080},
        {"container_port": 7077},
        {"container_port": 8888}
      ]
    },
    {
      "id": "spark-worker",
      "type": "service",
      "image": "heliumdatacommons/spark-worker:hail",
      "instances": 1,
      "resources": {
        "cpus": 2,
        "mem": 2048
      },
      "network_mode": "container",
      "args": [
        "@spark-master:7077"
      ],
      "env": {
        "PYSPARK_PYTHON": "/usr/bin/python"
      }
    }
  ]
}


class PivotSpawner(Spawner):

    master_image = Unicode('dchampion24/hail', config=True)

    # fix default port to 8888, used in the container
    @default('port')
    def _port_default(self):
        return 8888

    # default to listening on all-interfaces in the container
    @default('ip')
    def _ip_default(self):
        return '0.0.0.0'

    def __init__(self, *args, **kwargs):
      super(PivotSpawner, self).__init__(*args, **kwargs)
      self.__cli = AsyncHTTPClient()
      self.__app_id = body['id']

    async def get_appliance(self, name):
      r = await self.__cli.fetch('http://%s:%d/appliance/%s'%(host, port, name), method='GET')
      return tornado.escape.json_decode(r.body)

    async def submit_appliance(self, app):
      app['id'] = self.user_options.get('name', 'hail')
      try:
        await self.__cli.fetch('http://%s:%d/appliance'%(host, port), method='POST',
                                 body=tornado.escape.json_encode(app))
      except:
        pass

    async def delete_appliance(self, name):
      try:
        await self.__cli.fetch('http://%s:%d/appliance/%s'%(host, port, name), method='DELETE')
      except:
        pass

    def get_app_status(self, app):
      return [c['state'] for c in app['containers'] if c['id'] == 'spark_master'][0]

    def get_app_endpoint(self, app):
      e = [c for c in app['containers'] if c['id'] == 'spark_master'][0]['endpoints'][-1]
      return e['host'], e['host_port']

    async def start(self):
      if (await self.poll()) is None:
        body['spark-master']['image'] = self.master_image
        body['spark-master']['env'] = dict(self.get_env())
        body['spark-master']['args'] = list(self.get_args())
        await self.submit_appliance(body)
      while True:
        app = await self.get_appliance(body['id'])
        if self.get_app_status(app) == 'running':
          return self.get_app_endpoint(app)
        gen.sleep(1)

    async def stop(self, now=False):
      if self.__app_id:
        await self.delete_appliance(self.__app_id)

    async def poll(self):
      try:
        app = await self.get_appliance(self.__app_id)
        return None if self.get_app_status(app) == 'running' else 1
      except: # Http 404
        return 0
