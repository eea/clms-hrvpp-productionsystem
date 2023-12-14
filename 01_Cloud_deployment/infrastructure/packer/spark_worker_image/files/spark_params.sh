#!/bin/bash
set -e

LOGFILE='/var/log/spark_params.log'

# PARAMS

SPARK_CONFIG='/etc/spark/worker.sh'
IP=$(ip a s eth0 | grep 'inet ' | awk '{ print $2}' | cut -d'/' -f1)
MEMORY=$(echo $(( $(free -b | head -2 | tail -1 | awk '{ print $2 }') * 90 / 100)))
CORES=$(echo $(( $(cat /proc/cpuinfo  | grep processor | wc -l)* 90 / 100 )))
HOSTNAME=""

while test -z $HOSTNAME; do
  HOSTNAME=$(cat /var/lib/cloud/instance/user-data.txt | grep fqdn | cut -d ':' -f2 | sed 's/^\s\+//g')
  sleep 1
done

# Report

echo "$(date) | Found fqdn: ${HOSTNAME}" >> $LOGFILE
echo "$(date) | Found ip: ${IP}" >> $LOGFILE
echo "$(date) | Found memory: ${MEMORY}" >> $LOGFILE
echo "$(date) | Found cores: ${CORES}" >> $LOGFILE

# If it is a TS worker, wait for the disk to show up first.
if $( echo "${HOSTNAME}" | grep -q 'ts-worker' ); then
  DISK_TRIES=0
  DISK_TRIES_MAX=10
  while [ $DISK_TRIES -le $DISK_TRIES_MAX ]; do
    if $( grep '/mnt/tmp_b' /etc/fstab -q ); then
      echo "$(date) | Found entry for /mnt/tmp_b, continuing" >> $LOGFILE
      DISK_TRIES=$(( $DISK_TRIES_MAX + 1))
    else
      echo "$(date) | Did not find an entry for /mnt/tmp_b, waiting" >> $LOGFILE
      DISK_TRIES=$(( $DISK_TRIES + 1))
      sleep 60
    fi
  done
fi

# Replace

sed -i "s/=CHANGEME_IP/=${IP}/g" "${SPARK_CONFIG}"
sed -i "s/=CHANGEME_DNS/=${HOSTNAME}/g" "${SPARK_CONFIG}"
sed -i "s/=CHANGEME_MEM/=${MEMORY}b/g" "${SPARK_CONFIG}"
sed -i "s/=CHANGEME_COR/=${CORES}/g" "${SPARK_CONFIG}"

# Certificate

LETSENCRYPT_CONFIG=$(find /etc/letsencrypt -type f -name 'regr.json')
LETSENCRYPT_URL=$(cat "${LETSENCRYPT_CONFIG}" | python3.6 -mjson.tool | grep uri | cut -d'"' -f4)
LETSENCRYPT_MAX_TRIES=100

TRIES=0
while [ $TRIES -le $LETSENCRYPT_MAX_TRIES ]; do
  TRIES=$(( $TRIES + 1))
  curl -s -o /tmp/tries "${LETSENCRYPT_URL}" && LETSENCRYPT_EXIT=$? || LETSENCRYPT_EXIT=$?
  if [ $LETSENCRYPT_EXIT -eq 0 ]; then
    TRIES=$(( $LETSENCRYPT_MAX_TRIES + 1 ))
  else
    echo "$(date) | Curl to ${LETSENCRYPT_URL} failed '${TRIES}' times." >> $LOGFILE
    sleep 1
  fi
done

SPARK_STORE_CONFIG='/etc/spark/spark-defaults.conf'
if ! test -f /etc/letsencrypt/live/${HOSTNAME}/privkey.pem; then
  echo "$(date) | Requesting new certificate" >> $LOGFILE
  certbot --text --agree-tos --non-interactive certonly --rsa-key-size 4096 -a standalone --cert-name "${HOSTNAME}" -d "${HOSTNAME}"
  CERTBOT_EXIT=$?
fi

if ! test -d /etc/security/spark; then
  mkdir /etc/security/spark
fi

# truststore
TRUSTSTORE=$( grep 'trustStore=' /etc/spark/spark-defaults.conf | cut -d= -f2 )
TRUSTSTOREPASS=$( grep 'trustStorePassword=' /etc/spark/spark-defaults.conf | cut -d= -f2)
TRUST_CURRENT_FINGERPRINT=$( echo $TRUSTSTOREPASS | keytool -list -keystore $TRUSTSTORE | grep 'Certificate fingerprint' | awk -F' ' '{ print $NF}' )
TRUST_CERT_FINGERPRINT=$( openssl x509 -noout -in /etc/letsencrypt/live/${HOSTNAME}/chain.pem -fingerprint -sha256 | cut -d= -f2 )
if [[ "$TRUST_CURRENT_FINGERPRINT" != "$TRUST_CERT_FINGERPRINT" ]]; then
  echo "$(date) | Updating the truststore" >> $LOGFILE
  if ! test -z $TRUST_CURRENT_FINGERPRINT; then
    keytool -delete -keystore $TRUSTSTORE -storepass $TRUSTSTOREPASS -alias truststore
    echo "$(date) | Deleted old certificate in the truststore" >> $LOGFILE
  fi
  keytool -importcert -trustcacerts -noprompt -keystore $TRUSTSTORE -storepass $TRUSTSTOREPASS -file "/etc/letsencrypt/live/${HOSTNAME}/chain.pem" -alias truststore
  echo "$(date) | Imported new certificate into the truststore" >> $LOGFILE
fi

# keystore
KEYSTORE=$( grep 'keyStore=' /etc/spark/spark-defaults.conf | cut -d= -f2 )
KEYSTOREPASS=$( grep 'keyStorePassword=' /etc/spark/spark-defaults.conf | cut -d= -f2)
KEY_CURRENT_FINGERPRINT=$( echo $KEYSTOREPASS | keytool -list -keystore $KEYSTORE | grep 'Certificate fingerprint' | awk -F' ' '{ print $NF}' )
KEY_CERT_FINGERPRINT=$( openssl x509 -noout -in /etc/letsencrypt/live/${HOSTNAME}/fullchain.pem -fingerprint -sha256 | cut -d= -f2 )

if [[ "$KEY_CURRENT_FINGERPRINT" != "$KEY_CERT_FINGERPRINT" ]]; then
  echo "$(date) | Updating the keystore" >> $LOGFILE
  if ! test -z $KEY_CURRENT_FINGERPRINT; then
    keytool -delete -keystore $KEYSTORE -storepass $KEYSTOREPASS -alias keystore
    echo "$(date) | Deleted old certificate in the keystore" >> $LOGFILE
  fi
  openssl pkcs12 -export -in "/etc/letsencrypt/live/${HOSTNAME}/fullchain.pem" -inkey "/etc/letsencrypt/live/${HOSTNAME}/privkey.pem" -name keystore -out /tmp/server.p12 -password "pass:$KEYSTOREPASS"
  keytool -importkeystore -srckeystore /tmp/server.p12 -srcstorepass $KEYSTOREPASS -destkeystore $KEYSTORE -deststorepass $KEYSTOREPASS -srcstoretype pkcs12 -alias keystore
  echo "$(date) | Imported new certificate into the keystore" >> $LOGFILE
  rm -f /tmp/server.p12
fi

# crontab
if ! $(crontab -l | grep 'certbot renew' -q); then
  crontab -l > /tmp/crontab
  echo '30 3 1-31/7 * * certbot renew -q' >> /tmp/crontab
  crontab /tmp/crontab
  rm -f /tmp/crontab
  echo "$(date) | Updated crontab" >> $LOGFILE
fi
