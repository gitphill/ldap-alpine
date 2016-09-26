# LDAP Alpine

The Lightweight Directory Access Protocol (LDAP) is an open, vendor-neutral, industry standard application protocol for accessing and maintaining distributed directory information services over an Internet Protocol (IP) network.

This image is based on Alpine Linux and OpenLDAP.

## Vagrant

Requires [VirtualBox](https://www.virtualbox.org) and [Vagrant](https://www.vagrantup.com) to be installed. The development environment is based on Ubuntu Trusty and installs docker.

To start a development machine and login:

```
vagrant up && vagrant ssh
```

## Docker

Docker images and containers can be built and run using the Makefiles.

### Build image

To build a local image based on the Dockerfile:

```
make build
```

### Run container

To perform a build then run a container:

```
make run
```

### Tail container

To perform a build, run a container then tail the logs from the container:

```
make up
```

## LDAP

To search ldap:

```
make run
cp .ldaprc ~
ldapsearch -x -D "cn=admin,dc=example,dc=com" -w password -b "dc=example,dc=com"
```

Note: copying .ldaprc to the users home directory configures the ldap client with appropriate settings for TLS connection to LDAP.

## Customisation

Override the following environment variables when running the docker container to customise LDAP:

| VARIABLE | DESCRIPTION | DEFAULT |
| :------- | :---------- | :------ |
| ORGANISATION_NAME | Organisation name | Example Ltd |
| SUFFIX | Organisation distinguished name | dc=example,dc=com |
| ROOT_USER | Root username | admin |
| ROOT_PW | Root password | password |
| USER_UID | Initial user's uid | pgarrett |
| USER_GIVEN_NAME | Initial user's given name | Phill |
| USER_SURNAME | Initial user's surname | Garrett |
| USER_EMAIL | Initial user's email | pgarrett@example.com |
| USER_PW | Initial user's password | password |

For example:

```
docker run -v /certs:/etc/ssl/certs \
  pgarrett/openssl-alpine

docker run -v /certs:/etc/ssl/certs \
  -p 636:636 \
  -e ORGANISATION_NAME="Beispiel gmbh" \
  -e SUFFIX="dc=beispiel,dc=de" \
  -e ROOT_PW="geheimnis" \
  pgarrett/ldap-alpine
```

## Add ldif files

Copy ldif scripts to /ldif and the container will execute them. This can be done either by extending this Dockerfile with your own:

```
FROM pgarrett/ldap-alpine
COPY my-users.ldif /ldif/
```

Or by mounting your scripts directory into the container:

```
docker run -v /certs:/etc/ssl/certs \
  pgarrett/openssl-alpine

docker run -v /certs:/etc/ssl/certs \
  -p 636:636 \
  -v /my-ldif:/ldif \
  pgarrett/ldap-alpine
```
