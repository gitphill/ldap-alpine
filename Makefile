certs_dir := $(CURDIR)/certs

build:
	docker build -t pgarrett/ldap-alpine .

push:
	docker push pgarrett/ldap-alpine .

clean:
	docker rm -f ldap; true

run: build clean
	docker run -d --name ldap -p 389:389 pgarrett/ldap-alpine

help:
	@echo "Usage: make build|push|clean|run"
