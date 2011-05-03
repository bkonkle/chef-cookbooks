#!/usr/bin/env python
from setuptools import setup, find_packages

setup(name='example_project',
      version='0.1',
      packages=find_packages(),
      package_data={'myapp': ['bin/*.*', 'static/*.*', 'templates/*.*']},
      exclude_package_data={'myapp': ['bin/*.pyc']},
      scripts=['myapp/bin/manage.py'])
