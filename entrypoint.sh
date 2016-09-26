#!/bin/sh
# docker entrypoint script
# configures and starts LDAP

# ensure certificates exist
RETRY=0
MAX_RETRIES=3
until [ -f "$CERT_KEY" ] && [ -f "$CERT_FILE" ] && [ -f "$CA_FILE" ] || [ "$RETRY" -eq "$MAX_RETRIES" ]; do
  RETRY=$((RETRY+1))
  echo "Cannot find certificates. Retry ($RETRY/$MAX_RETRIES) ..."
  sleep 1
done

# exit if no certificates were found after maximum retries
if [ "$RETRY" -eq "$MAX_RETRIES" ]; then
  echo "Cannot start ldap, the following certificates do not exist"
  echo " CA_FILE:   $CA_FILE"
  echo " CERT_KEY:  $CERT_KEY"
  echo " CERT_FILE: $CERT_FILE"
  exit 1
fi

# replace variables in slapd.conf
SLAPD_CONF="/etc/openldap/slapd.conf"

sed -i "s~%CA_FILE%~$CA_FILE~g" "$SLAPD_CONF"
sed -i "s~%CERT_KEY%~$CERT_KEY~g" "$SLAPD_CONF"
sed -i "s~%CERT_FILE%~$CERT_FILE~g" "$SLAPD_CONF"
sed -i "s~%ROOT_USER%~$ROOT_USER~g" "$SLAPD_CONF"
sed -i "s~%SUFFIX%~$SUFFIX~g" "$SLAPD_CONF"

# encrypt root password before replacing
if [ -z "$ROOT_PW" ]; then ROOT_PW="password"; fi
ROOT_PW=$(slappasswd -s "$ROOT_PW")
sed -i "s~%ROOT_PW%~$ROOT_PW~g" "$SLAPD_CONF"

# replace variables in organisation configuration
ORG_CONF="/etc/openldap/organisation.ldif"
sed -i "s~%SUFFIX%~$SUFFIX~g" "$ORG_CONF"
sed -i "s~%ORGANISATION_NAME%~$ORGANISATION_NAME~g" "$ORG_CONF"

# replace variables in user configuration
USER_CONF="/etc/openldap/users.ldif"
sed -i "s~%SUFFIX%~$SUFFIX~g" "$USER_CONF"
sed -i "s~%USER_UID%~$USER_UID~g" "$USER_CONF"
sed -i "s~%USER_GIVEN_NAME%~$USER_GIVEN_NAME~g" "$USER_CONF"
sed -i "s~%USER_SURNAME%~$USER_SURNAME~g" "$USER_CONF"
if [ -z "$USER_PW" ]; then USER_PW="password"; fi
sed -i "s~%USER_PW%~$USER_PW~g" "$USER_CONF"
sed -i "s~%USER_EMAIL%~$USER_EMAIL~g" "$USER_CONF"

# add organisation and users to ldap (order is important)
slapadd -l "$ORG_CONF"
slapadd -l "$USER_CONF"

# add any scripts in ldif
for l in /ldif/*; do
  case "$l" in
    *.ldif)  echo "ENTRYPOINT: adding $l";
            slapadd -l $l
            ;;
    *)      echo "ENTRYPOINT: ignoring $l" ;;
  esac
done

# start ldap
slapd -d stats -h 'ldaps:///'

# run command passed to docker run
exec "$@"
