#!/usr/bin/env python3

from setuptools import setup

# read the contents of your README file
from os import path
this_directory = path.abspath(path.dirname(__file__))
with open(path.join(this_directory, 'README.md'), encoding='utf-8') as f:
    long_description = f.read()

setup(
    name='beancount_allocate',
    version='0.1.4',
    description='Plugin for Beancount to collaborate within one ledger.',

    long_description=long_description,
    long_description_content_type='text/markdown',

    author='Akuukis',
    author_email='akuukis@kalvis.lv',
    download_url='https://pypi.python.org/pypi/beancount_allocate',
    license='GNU AGPLv3',
    package_data={'beancount_allocate': ['../README.md']},
    package_dir={'beancount_allocate': 'beancount_allocate'},
    packages=['beancount_allocate'],
    install_requires=['beancount >= 2.0', 'beancount_plugin_utils >= 0.0.4'],
    url='https://github.com/Akuukis/beancount_allocate',
)
