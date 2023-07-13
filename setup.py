# -*- coding: utf-8 -*-

from setuptools import setup, find_packages


with open('README.md') as f:
  readme = f.read()

with open('LICENSE') as f:
  license = f.read()

setup(
    name='eta-py',
    version='0.1.0',
    description='Python implementation of Eta dialogue manager',
    long_description=readme,
    author='Benjamin Kane',
    author_email='bkane2@ur.rochester.edu',
    url='TBC',
    license=license,
    packages=find_packages(exclude=('_keys', 'tests', 'docs'))
)
