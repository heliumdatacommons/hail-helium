#! /usr/bin/env python
import json

env_to_set = {
  'PYTHONHASHSEED': '0',
  'PYTHONPATH': os.environ.get('PYTHONPATH'),
  'SPARK_HOME': '/usr/lib/spark/',
  'PYSPARK_PYTHON': '/usr/bin/python3',
  'PYSPARK_DRIVER_PYTHON': '/usr/bin/python3'
}

kernel = {
  'argv': [
    '/usr/bin/python3',
    '-m',
    'ipykernel',
    '-f',
    '{connection_file}'
  ],
  'display_name': 'Hail',
  'language': 'python',
  'env': env_to_set
}

with open('/usr/local/share/jupyter/kernels/hail/kernel.json', 'w') as f:
  json.dump(kernel, f)
