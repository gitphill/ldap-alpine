FROM alpine

# install openldap
RUN apk add --update openldap openldap-back-mdb && \
    mkdir -p /etc/openldap && \
    mkdir -p /run/openldap && \
    rm -rf /var/cache/apk/*

# organisation config
ENV ORGANISATION_NAME "Example Ltd"
ENV SUFFIX "dc=example,dc=com"

# root config
ENV ROOT_USER "admin"

# initial user config
ENV USER_UID "pgarrett"
ENV USER_GIVEN_NAME "Phill"
ENV USER_SURNAME "Garrett"
ENV USER_EMAIL "pgarrett@example.com"

ENV LOG_LEVEL "stats"

# copy scripts and configuration
COPY scripts/* /etc/openldap/

EXPOSE 636
EXPOSE 389

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

VOLUME ["/ldif"]
