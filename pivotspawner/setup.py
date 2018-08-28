#!/usr/bin/env python
from __future__ import print_function

import os
import sys

v = sys.version_info
if v[:2] < (3, 3):
    error = "ERROR: JupyterHub requires Python version 3.3 or above."
    print(error, file=sys.stderr)
    sys.exit(1)


if os.name in ('nt', 'dos'):
    error = "ERROR: Windows is not supported"
    print(error, file=sys.stderr)

# At least we're on the python version we need, move on.

from distutils.core import setup

pjoin = os.path.join
here = os.path.abspath(os.path.dirname(__file__))

# Get the current package version.
version_ns = {}
with open(pjoin(here, 'pivotspawner', '_version.py')) as f:
    exec(f.read(), {}, version_ns)


setup_args = dict(
    name='pivotspawner',
    packages=['pivotspawner'],
    version=version_ns['__version__'],
    description="""PIVOT spawner for JupyterHub""",
    long_description="Spawn single-user servers with PIVOT.",
    author="Fan Jiang",
    author_email="dcvan@renci.org",
    url="https://github.com/heliumdatacommons/pivotspawner",
    platforms="Linux, Mac OS X",
)

if 'bdist_wheel' in sys.argv:
    import setuptools

# setuptools requirements
if 'setuptools' in sys.modules:
    setup_args['install_requires'] = install_requires = []
    with open('requirements.txt') as f:
        for line in f.readlines():
            req = line.strip()
            if not req or req.startswith(('-e', '#')):
                continue
            install_requires.append(req)


def main():
  setup(**setup_args)

if __name__ == '__main__':
    main()