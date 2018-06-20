# Docker images of various type and purpose

## Ansible Venv Images
Images contain the minimum required packages for setting up a python-virtual environment
capable of building/installing Ansible under either python2 or 3 pip.

* [docker.io/cevich/venv_ubuntu:latest](https://hub.docker.com/r/cevich/venv_ubuntu/)
* [docker.io/cevch/venv_fedora:latest](https://hub.docker.com/r/cevich/venv_fedora/)
* [docker.io/cevich/venv_centos:latest](https://hub.docker.com/r/cevich/venv_centos/)

## Travis SPC Images
Images designed to be executed as SPCs for performing common build/test
tasks, typically under Travis CI.  For example, see
[the .travis.yml](https://github.com/cevich/dockerfiles/blob/master/.travis.yml)
and [the travis.sh](https://github.com/cevich/dockerfiles/blob/master/test.sh) files in this repo.

* [docker.io/cevich/travis_ubuntu:latest](https://hub.docker.com/r/cevich/travis_ubuntu/)
* [docker.io/cevich/travis_fedora:latest](https://hub.docker.com/r/cevich/travis_fedora/)
* [docker.io/cevich/travis_centos:latest](https://hub.docker.com/r/cevich/travis_centos/)

## RHSM Test Image
This is an supporting image for testing the Red Hat Subscription Manager, within a container.
It uses a CentOS base image, since the RHEL base images are designed to utilize the
host's subscription.  Specificly it's used by the CI for my
[cevich.subscribed](https://galaxy.ansible.com/cevich/subscribed/) Ansible Galaxy role.

## CentOS SPC Image
Extends the Ansible Venv CentOS Image such that it may utilize docker or podman
on the host system, from within Ansible playbooks in the container.

[![Build Status](https://travis-ci.org/cevich/dockerfiles.svg?branch=master)](https://travis-ci.org/cevich/dockerfiles)
