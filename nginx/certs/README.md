This directory should contain the SSL certificate and key for local development, and they should be named "localhost+2.pem" and "localhost+2-key.pem".

An easy way to generate the SSL certificate and key is with [mkcert](https://github.com/FiloSottile/mkcert):

```bash
mkcert -install
mkcert localhost 0.0.0.0 127.0.0.1
```
