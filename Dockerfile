FROM alpine

# install openldap
RUN apk add --update openldap && \
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

# transport layer security configuration
ENV CA_FILE "/etc/ssl/certs/ca.pem"
ENV CERT_KEY "/etc/ssl/certs/public.key"
ENV CERT_FILE "/etc/ssl/certs/public.crt"

# copy scripts and configuration
COPY scripts/* /etc/openldap/

EXPOSE 636

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

VOLUME ["/ldif"]
