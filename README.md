# NGINX with HTTP/3 and QUIC support

The Docker image is ready to use:
<code>docker pull ghcr.io/ammnt/nginx:http3</code>

# Features

- Based on latest version of Alpine Linux - low size (~7 MB);
- NGINX QUIC branch:
https://hg.nginx.org/nginx-quic
- QuicTLS with kTLS module:
https://github.com/quictls/openssl
- HTTP/3 + QUIC native support from NGINX;
- HTTP/2 with ALPN support;
- TLS 1.3 and 0-RTT support;
- TLS 1.2 and TCP Fast Open (TFO) support;
- Built using hardening GCC flags;
- NJS support;
- PCRE with JIT compilation;
- zlib library latest version;
- Rootless master process - unprivileged container;
- Async I/O threads module;
- Healthcheck added;
- Removed unnecessary modules;
- Prioritize ChaCha cipher patch and anonymous signature - removed "Server" header ("banner").
