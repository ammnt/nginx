# NGINX with HTTP/3 and QUIC support

The Docker image is ready to use:<br>
<code>docker pull ghcr.io/ammnt/nginx:http3</code><br>
or<br>
<code>docker pull ammnt/nginx:http3</code>

# Description:

- Based on latest version of Alpine Linux - low size (~7 MB);
- NGINX QUIC branch:<br>
https://hg.nginx.org/nginx-quic
- QuicTLS with kTLS module:<br>
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
- Added OCI labels and annotations;
- Prioritize ChaCha cipher patch and anonymous signature - removed "Server" header ("banner"):<br>
https://github.com/ammnt/nginx/blob/http3/Dockerfile

# Note:

Feel free to <a href="https://github.com/ammnt/nginx/issues/new">contact me</a> with more security improvements🙋
