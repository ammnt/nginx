# Distroless NGINX with HTTP/3 and QUIC support🚀

[![Build and push image📦](https://github.com/ammnt/nginx/actions/workflows/build.yml/badge.svg)](https://github.com/ammnt/nginx/actions/workflows/build.yml)
![version](https://img.shields.io/badge/version-1.27.2-blue)
[![GitHub issues open](https://img.shields.io/github/issues/ammnt/nginx.svg)](https://github.com/ammnt/nginx/issues)

The Docker image is ready to use:<br>
<code>docker run -d --rm -p 127.0.0.1:8080:8080/tcp ghcr.io/ammnt/nginx:latest</code><br>
or<br>
<code>docker run -d --rm -p 127.0.0.1:8080:8080/tcp ammnt/nginx:latest</code>

# Description:

- Based on latest version of Alpine Linux - low size (~5 MB);
- OpenSSL with HTTP/3 and QUIC support:<br>
https://github.com/openssl/openssl
- HTTP/2 with ALPN support;
- TLS 1.3 and 0-RTT support;
- TLS 1.2 and TCP Fast Open (TFO) support;
- Built using hardening GCC flags;
- NJS and Brotli support;
- PCRE with JIT compilation;
- zlib-ng library latest version;
- Rootless master process - unprivileged container;
- Async I/O threads module;
- "Distroless" image - shell removed from the image;
- Removed unnecessary modules;
- Added OCI labels and annotations;
- No excess ENTRYPOINT in the image;
- Slimmed version by Docker Slim tool;
- Scanned efficiency result with Dive tool;
- Scanned by vulnerability scanners: GitHub, Docker Scout, Snyk, Grype, Clair and Syft;
- Prioritize ChaCha cipher patch and anonymous signature - removed "Server" header ("banner"):<br>
https://github.com/ammnt/nginx/blob/main/Dockerfile

# Note:

Feel free to <a href="https://github.com/ammnt/nginx/issues/new">contact me</a> with more security improvements🙋
