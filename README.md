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

```python
import base64
from chromadb import Settings, HttpClient

def test_client():
    # basic auth - base64 encoded username:password
    credentials = base64.b64encode(b'testuser:testpassword').decode('utf-8')
    client = HttpClient(host='localhost', port=8443, ssl=True,headers={'Authorization': f'Basic {credentials}'})
    client._session.verify = False #this is a workaround as Chroma client does not yet support self-signed certificates
    print(client.heartbeat())
    
if __name__ == '__main__':
    test_client()
```