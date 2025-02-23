# Distroless NGINX with HTTP/3 and QUIC support🚀

[![Build and push image📦](https://github.com/ammnt/nginx/actions/workflows/build.yml/badge.svg)](https://github.com/ammnt/nginx/actions/workflows/build.yml)
![version](https://img.shields.io/badge/version-1.27.4-blue)
[![GitHub issues open](https://img.shields.io/github/issues/ammnt/nginx.svg)](https://github.com/ammnt/nginx/issues)
![GitHub Maintained](https://img.shields.io/badge/open%20source-yes-orange)
![GitHub Maintained](https://img.shields.io/badge/maintained-yes-yellow)
[![Visitors](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fammnt%2Fnginx&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=visitors&edge_flat=false)](https://hits.seeyoufarm.com)

The Docker image is ready to use:<br>
<code>docker run -d --name nginx -p 80:8080/tcp -p 443:8443/tcp -p 443:8443/udp ghcr.io/ammnt/nginx:latest</code><br>
or<br>
<code>docker run -d --name nginx -p 80:8080/tcp -p 443:8443/tcp -p 443:8443/udp ammnt/nginx:latest</code><br>
or with Docker Compose deployment:
```
services:
  nginx:
    image: ammnt/nginx:latest
    user: "101:101"
    read_only: true
    privileged: false
    tmpfs:
     - /tmp:mode=1700,size=1G,noexec,nosuid,nodev,uid=101,gid=101
    cap_drop:
     - all
    container_name: nginx
    security_opt:
      - no-new-privileges:true
      - apparmor:docker-nginx
    volumes:
      - "./conf:/etc/nginx:ro"
      - "/etc/timezone:/etc/timezone:ro"
      - "/etc/localtime:/etc/localtime:ro"
...
```

# Description:

- Based on latest version of Alpine Linux - low size (~5 MB);
- Multi-stage building with statically linked binary;
- OpenSSL with HTTP/3 and QUIC support:<br>
https://github.com/openssl/openssl
- HTTP/2 with ALPN support;
- TLS 1.3 and 0-RTT support;
- TLS 1.2 and TCP Fast Open (TFO) support;
- Built using hardening GCC flags;
- NJS and Brotli support;
- PCRE with JIT compilation;
- zlib library latest version;
- Rootless master process - unprivileged container;
- Async I/O threads module;
- "Distroless" image - shell removed from the image;
- Removed unnecessary modules;
- Added OCI labels and annotations;
- No excess ENTRYPOINT in the image;
- Slimmed version by Docker Slim tool;
- Image efficiency score 100% according to Dive utility;
- Scanned by vulnerability scanners: GitHub, Docker Scout, Snyk, Grype, Dockle and Syft;
- Prioritize ChaCha cipher patch and anonymous signature - removed "Server" header ("banner"):<br>
https://github.com/ammnt/nginx/blob/main/Dockerfile

# Note:

Feel free to <a href="https://github.com/ammnt/nginx/issues/new">contact me</a> with more improvements🙋
