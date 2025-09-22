# 🚀 Distroless NGINX: Hardened & Optimized image

[![Build and Push](https://github.com/ammnt/nginx/actions/workflows/build.yml/badge.svg)](https://github.com/ammnt/nginx/actions/workflows/build.yml)
![Version](https://img.shields.io/github/v/release/ammnt/nginx)
![Security](https://img.shields.io/badge/security-hardened-brightgreen)
![Size](https://img.shields.io/badge/size-ultra--lightweight-blue)
[![GitHub issues open](https://img.shields.io/github/issues/ammnt/nginx.svg)](https://github.com/ammnt/nginx/issues)
![GitHub Maintained](https://img.shields.io/badge/open%20source-yes-orange)
![GitHub Maintained](https://img.shields.io/badge/maintained-yes-yellow)

> **Production-ready, security-focused NGINX container with HTTP/3, QUIC and PQC support.**

> [!IMPORTANT]
> QuicTLS is now deprecated. I use OpenSSL, since this library natively supports OCSP, PQC and QUIC⚠️

> [!TIP]
> You can find an example configuration file in the repository for successfully configuring HTTP3 and PQC💡

## 🎯 Why Choose This Image?

### **Architecture Advantages**
- **Distroless base** - Built from `scratch` with zero bloat
- **Static compilation** - Fully static binary with 30+ GCC hardening flags
- **Minimal attack surface** - No shell, no package manager
- **Native HTTP/3 support** - OpenSSL 3.x with QUIC without patches or experimental implementations
- **Supply chain security** - Cosign signatures + SLSA attestation
- **Comprehensive scanning** - 7+ security tools (Docker Scout, Trivy, Snyk, Grype, Dockle, Syft, Dive)

## 🌐 Image Variants

Docker Hub:<br>
> **ammnt/nginx:latest**

GitHub Container Registry:<br>
> **ghcr.io/ammnt/nginx:latest**

All images are **signed with Cosign** and include **provenance attestation**.

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
      - "/etc/timezone:/etc/timezone:ro"
      - "/etc/localtime:/etc/localtime:ro"
```

## 🔥 Unique Security Features

### **Compilation Hardening**
- **30+ GCC security flags** including:
  - `-D_FORTIFY_SOURCE=3`, `-fhardened`, `-fstack-protector-strong`
  - `-fstack-clash-protection`, `-fPIE`, `-pie`
  - `-ftrivial-auto-var-init=zero` (prevents data leaks)
  - `-fcf-protection=full` (Control-Flow Integrity)
- **Read-Only Relocations** (`-Wl,-z,relro,-z,now`)
- **Stack execution protection** and **buffer overflow guards**

### **Runtime Security**
- **Rootless by design** (`USER nginx`)
- **Distroless base** - no shell, no package manager, zero bloat
- **Minimal module surface** - 15+ unnecessary modules removed
- **Server header removal** - security through obscurity
- **TLS 1.3 with 0-RTT** and **post-quantum hybrid key exchange**

### **Supply Chain Integrity**
- **Cosign-signed images** with key rotation support
- **SLSA provenance attestation**
- **Multi-scanner validation** (Docker Scout, Trivy, Snyk, Grype)
- **SBOM generation** with Syft

## 🚀 Ultimate Optimization

### **Size Optimization**
- **Multi-stage build** with Alpine builder + scratch final image
- **Static compilation** - zero runtime dependencies
- **Docker Slim integration** - automatic dead code elimination
- **Binary stripping** and **LTO optimization**

### **Performance Features**
- **zlib-ng** with modern compression algorithms
- **PCRE2 with JIT** compilation for regex performance
- **Thread pool support** for async I/O operations
- **TCP Fast Open** and **SSL session resumption**

## 🤝 Contributing & Support

Found an issue or have an improvement?
- [Open an Issue](https://github.com/ammnt/nginx/issues/new?template=bug_report.md)
- [Feature Request](https://github.com/ammnt/nginx/issues/new?template=feature_request.md)

> **Note:** This image is designed for security-conscious production environments. For development purposes, consider using the official NGINX image with full debugging capabilities.

## 📄 License

This project is open source and maintained with ❤️ by [ammnt](https://github.com/ammnt).
