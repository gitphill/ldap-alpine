certs_dir := $(CURDIR)/certs

build:
	docker build -t pgarrett/ldap-alpine .

push:
	docker push pgarrett/ldap-alpine .

clean:
	rm -rf ${certs_dir}; docker-compose kill; docker-compose rm -f; true

run: build clean
	docker-compose up -d

up: build clean
	docker-compose up

help:
	@echo "Usage: make build|push|clean|run|up"
