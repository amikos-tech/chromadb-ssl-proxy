#!/bin/sh
# wait-for-certs.sh

# Loop until the certificate files exist
while [ ! -f /etc/envoy/certs/servercert.pem ] || [ ! -f /etc/envoy/certs/serverkey.pem ]; do
  echo "Waiting for certificates..."
  sleep 1
done

echo "Certificates are ready."