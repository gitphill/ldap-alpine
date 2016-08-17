certs_dir := $(CURDIR)/certs

build:
	docker build -t pgarrett/ldap .

clean:
	rm -rf ${certs_dir}; docker-compose kill; docker-compose rm -f; true

run: build clean
	docker-compose up -d

up: build clean
	docker-compose up

help:
	@echo "Usage: make build|clean|run|up"
