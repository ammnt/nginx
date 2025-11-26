# 🚀 Distroless NGINX: Hardened & Optimized image

[![CI/CD](https://github.com/ammnt/nginx/actions/workflows/build.yml/badge.svg)](https://github.com/ammnt/nginx/actions/workflows/build.yml)
![Version](https://img.shields.io/github/v/release/ammnt/nginx)
[![GitHub stars](https://img.shields.io/github/stars/ammnt/nginx.svg)](https://github.com/ammnt/nginx/stargazers)
![Feature](https://img.shields.io/badge/feature-distroless-blue)
[![GitHub issues open](https://img.shields.io/github/issues/ammnt/nginx.svg)](https://github.com/ammnt/nginx/issues)
![GitHub Maintained](https://img.shields.io/badge/open%20source-yes-orange)
![GitHub Maintained](https://img.shields.io/badge/maintained-yes-yellow)

> **Production-ready, security-focused NGINX image with HTTP/3, QUIC and PQC support.**

> [!IMPORTANT]
> QuicTLS is now deprecated. I use OpenSSL, since this library natively supports OCSP, PQC and QUIC⚠️

> [!IMPORTANT]
> NJS module has been removed due to security vulnerabilities in libxml2/libxslt dependencies⚠️

> [!TIP]
> You can find an example configuration file in the repository for successfully configuring HTTP/3 and PQC💡

## 🌐 Image Variants

Docker Hub:<br>
> **ammnt/nginx:latest**

GitHub Container Registry:<br>
> **ghcr.io/ammnt/nginx:latest**

## 📦 Quick Start

### Docker Run
```bash
docker run -d \
  --name nginx \
  -p 80:8080 \
  -p 443:8443 \
  ammnt/nginx:latest
```

## 🔧 Advanced Configuration

## 🎯 Recommended to use in Rootless mode:<br>
https://docs.docker.com/engine/security/rootless/

### Docker Compose (Recommended)
```yaml
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
      - no-new-privileges=true
      - apparmor=docker-nginx
      - seccomp=./nginx-seccomp.json
    volumes:
      - "./conf:/etc/nginx:ro"
...
```
## 🔥 Why Choose This Image?

### **Compilation Hardening**
- **GCC security flags** including:
  - `-D_FORTIFY_SOURCE=3`, `-fhardened`, `-fstack-protector-strong`
  - `-fstack-clash-protection`, `-ftrivial-auto-var-init=zero` (prevents data leaks)
  - `-fcf-protection=full` (Control-Flow Integrity)
- **Read-Only Relocations** (`-Wl,-z,relro,-z,now`)
- **Stack execution protection** and **buffer overflow guards**

### **Runtime Security**
- **Rootless by design** (`USER nginx`)
- **Distroless base** - built from `scratch` with zero bloat
- **Minimal attack surface** - no shell, no package manager and no unnecessary modules
- **Server header removal** - anonymous signature ("security through obscurity")
- **Best practices compliance** - follows Docker security standards
- **Native HTTP/3 support** - OpenSSL and QUIC without patches or experimental implementations
- **Native PQC support** - hybrid post-quantum key exchange algorithms in elliptic curves
- **Native TLS 1.3 with 0-RTT**

### **Supply Chain Integrity**
- **Signed images** - signatures and SLSA **provenance attestation**.
- **Comprehensive scanning** - by security tools (Docker Scout, Trivy, Snyk, Grype, Dockle, Hadolint)
- **SBOM generation** with Syft

## 🚀 Ultimate Optimization

### **Size Optimization**
- **Multi-stage build** with Alpine builder + scratch final image
- **Static compilation** - static binary with minimal dependencies
- **Mint tool integration** - slimmed version of the image
- **UPX runtime efficiency** - minimal memory overhead with fast decompression
- **Binary stripping** and **LTO optimization**

### **Performance Features**
- **zlib-ng** with modern compression algorithms
- **PCRE2 with JIT** compilation for regex performance
- **Thread pool support** for async I/O operations
- **TCP Fast Open** and **SSL session resumption**
- **Graceful shutdown** - SIGQUIT handling for proper connection draining
- **Brotli compression** support

### **Quality Metrics**
- **ChaCha20 prioritization** - custom patch for modern cipher preference
- **Image efficiency** - perfect score in Dive analysis (100%)
- **Comprehensive OCI labels** - standardized metadata and annotations
- **No excess ENTRYPOINT** - no unnecessary wrapper scripts or bloat
- **HEALTHCHECK** - added in the Dockerfile

## 🤝 Contributing & Support

Found an issue or have an improvement?
- [Open an Issue](https://github.com/ammnt/nginx/issues/new?template=bug_report.md)
- [Feature Request](https://github.com/ammnt/nginx/issues/new?template=feature_request.md)

> **Note:** This image is designed for security-conscious production environments. For development purposes, consider using the official NGINX image with full debugging capabilities.

## 📄 License

This project is open source and maintained with ❤️ by [ammnt](https://msftcnsi.com).
