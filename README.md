# Securing Chroma with TLS-terminated HTTPS Proxy (Envoy)

This is a guide to securing Chroma with TLS-terminated HTTPS Proxy (Envoy).

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)

## Generate Self-Signed Certificates

> Note: The docker compose already contains a container that creates the self-signed certificates. This step is only
> required if you want to generate the certificates manually.

```bash
export CHROMA_DOMAIN=${CHROMA_DOMAIN:-"localhost"}
openssl req -new -newkey rsa:2048 -sha256 -days 365 -nodes -x509 \
  -keyout certs/serverkey.pem \
  -out certs/servercert.pem \
  -subj "/O=Chroma/C=US" \
  -config openssl.cnf
```

## Getting Started

```bash
docker-compose up
```

The above command will generate self-signed cert, configure Envoy proxy and start Chroma server. The Chroma server will
be available at `https://localhost`.


## Testing

This is also available in jupyter notebook format in `verify_connectivity.ipynb`.

```python
from chromadb import Settings
import chromadb
client = chromadb.HttpClient(host='https://localhost:443',ssl=True, settings=Settings(chroma_server_ssl_verify='./certs/servercert.pem'))
print(client.heartbeat())
```