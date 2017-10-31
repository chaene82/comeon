# -*- coding: utf-8 -*-
"""
Created on Tue Oct 31 14:05:03 2017

@author: haenec
"""

from setuptools import setup

setup(name='comeone',
      version='0.0.1',
      description='Come On Tennis Betting Project',
      url='https://gitlab.com/christophH/comeon',
      author='Christoph Haene',
      author_email='christoph.haene@gmail.com',
      license='',
      packages=['comeon_common', 'comeon_etl','comeon_surebot'],
      include_package_data=True,
      test_suite='nose.collector',
      tests_require=['nose'],
      install_requires=[])