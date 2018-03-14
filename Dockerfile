FROM alpine

ENV ORGANISATION_NAME "Example Ltd"
ENV SUFFIX "dc=example,dc=com"
ENV ROOT_USER "admin"
ENV ROOT_PW "password"
ENV USER_UID "pgarrett"
ENV USER_GIVEN_NAME "Phill"
ENV USER_SURNAME "Garrett"
ENV USER_EMAIL "pgarrett@example.com"
ENV ACCESS_CONTROL "access to * by * read"
ENV LOG_LEVEL "stats"

RUN apk add --update openldap openldap-back-mdb && \
    mkdir -p /run/openldap /var/lib/openldap/openldap-data && \
    rm -rf /var/cache/apk/*

COPY scripts/* /etc/openldap/
COPY docker-entrypoint.sh /

EXPOSE 389
EXPOSE 636

VOLUME ["/ldif", "/var/lib/openldap/openldap-data"]

ENTRYPOINT ["/docker-entrypoint.sh"]
