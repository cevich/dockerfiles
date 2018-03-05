# Docker images of various type and purpose

## Ansible Venv Images
Images contain the minimum required packages for setting up a python-virtual environment
capable of building/installing Ansible under either python2 or 3 pip.

* [docker.io/cevich/venv_ubuntu:latest](https://hub.docker.com/r/cevich/venv_ubuntu/)
* [docker.io/cevch/venv_fedora:latest](https://hub.docker.com/r/cevich/venv_fedora/)
* [docker.io/cevich/venv_centos:latest](https://hub.docker.com/r/cevich/venv_centos/)

## Travis SPC Images
Built upon the above, with additional packages needed for performing common build/test
tasks.  Intended to be used as SPCs under Travis CI.  For example, see [the .travis.yml](https://github.com/cevich/dockerfiles/blob/master/.travis.yml)
and [the travis.sh](https://github.com/cevich/dockerfiles/blob/master/travis.sh) files in this repo.

* [docker.io/cevich/travis_ubuntu:latest](https://hub.docker.com/r/cevich/travis_ubuntu/)
* [docker.io/cevich/travis_fedora:latest](https://hub.docker.com/r/cevich/travis_fedora/)
* [docker.io/cevich/travis_centos:latest](https://hub.docker.com/r/cevich/travis_centos/)

[![Build Status](https://travis-ci.org/cevich/dockerfiles.svg?branch=master)](https://travis-ci.org/cevich/dockerfiles)
