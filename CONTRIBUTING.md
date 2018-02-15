# Contributing Guidelines

## Getting started

Install [Git](https://git-scm.com) and clone the repository:

```
git clone git@github.com:gitphill/ldap-alpine.git
```

## Virtual development environment

Vagrant allows you to easily create a virtual machine in Oracle Virtualbox to
develop and test your changes.

Install the following:

* [VirtualBox](https://www.virtualbox.org)
* [Vagrant](https://www.vagrantup.com)

Vagrant will create a virtual machine based on CentOS 7. It then uses puppet
to install and configure Docker and OpenSSL for the `vagrant`user.

To start the virtual machine and login:

```
vagrant up && vagrant ssh
```

## Docker

Docker images and containers can be built and run using the [Makefile](Makefile).

To build a local image based on the [Dockerfile](Dockerfile):

```
make build
```

To perform a build then run a container:

```
make run
```

## Compose

To run LDAP using TLS you can run the `docker-compose.yml` which starts a
temporary container to generate SSL certificates for the LDAP container.
It then mounts those certificates into the container and configures the container with
environment variables to indicate the location of the certificate files.

```
docker-compose up -d
```

## LDAP

To search ldaps:

```
cp .ldaprc ~
ldapsearch
```

Note: copying .ldaprc to the users home directory configures the ldap client
with appropriate settings for TLS connection to LDAP.

## Make

For convenience the commands above have been put into a [Makefile](Makefile).

To compose docker containers copy .ldaprc file and search ldap:

```
make test
```
