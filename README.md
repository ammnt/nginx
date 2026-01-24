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
> You can find an example [configuration file](example.conf) in the repository for successfully configuring HTTP/3 and PQC💡

> [!IMPORTANT]
> UID/GID changed to 10001 - it's [recommended](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) for Kubernetes and prevents conflicts with system users⚠️

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
    user: "10001:10001"
    read_only: true
    privileged: false
    tmpfs:
     - /tmp:mode=1700,size=1G,noexec,nosuid,nodev,uid=10001,gid=10001
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

### Example Deployment (PSS Restricted Level Compliant)
```yaml
apiVersion: v1
kind: Deployment
metadata:
  name: nginx-pss-restricted
spec:
  containers:
  - name: nginx
    image: ammnt/nginx:latest
    securityContext:
      capabilities:
        drop:
          - ALL
      privileged: false
      runAsUser: 10001
      runAsGroup: 10001
      seccompProfile:
        type: RuntimeDefault
      runAsNonRoot: true
      readOnlyRootFilesystem: true
      allowPrivilegeEscalation: false
...
```

## 🔥 Why Choose This Image?

### **GCC hardened compilation suite (-fhardened) providing comprehensive security:**
- **Memory protection** - stack smashing protection, stack clash protection
- **Control Flow Integrity** - full CFI protection against ROP/JOP attacks (Intel CET)
- **Initialization hardening** - automatic zero-initialization to prevent data leaks
- **Binary hardening** - position idependent executables (PIE) for ASLR (PaX ASLR, Linux kernel ASLR)
- **Runtime protections** - FORTIFY_SOURCE level 3 for buffer overflow detection
- **C++ assertions** - enhanced standard library security checks
- **Linker hardening** - read-only relocations and immediate binding (ELF hardening, RELRO)

### **Runtime Security**
- **Rootless by design** - unprivileged runtime user (Docker Bench Security, OCI Runtime Specification)
- **Distroless base** - built from `scratch` with zero bloat (SLSA Level 3 requirements)
- **Minimal attack surface** - no shell, no package manager and no unnecessary modules (CIS Docker Benchmark, Principle of Least Privilege)
- **Server header removal** - anonymous signature ("security through obscurity")
- **Kubernetes PSS compliant** - fully conforms to Pod Security Standards (baseline & restricted)
- **Docker security standards** - follows CIS Docker Benchmarks and best practices
- **Native QUIC and HTTP/3 support** - OpenSSL and QUIC without patches or experimental implementations (RFC 9114, RFC 9000)
- **Native PQC support** - hybrid post-quantum key exchange algorithms in elliptic curves (NIST PQC Standardization, FIPS 203/204/205)
- **Native TLS 1.3 with 0-RTT** (RFC 8446, RFC 9001)

### **Supply Chain Integrity**
- **Signed images** - signatures and **provenance attestation** (SLSA Level 3 requirements, in-toto attestations)
- **Comprehensive scanning** by security tools (Scout, Trivy, Snyk, Grype, Dockle, Hadolint)
- **SBOM generation** with Syft (NTIA Software Component Transparency)

## 🚀 Ultimate Optimization

### **Size Optimization**
- **Multi-stage build** with Alpine builder + scratch final image (Dockerfile best practices, BuildKit optimizations)
- **Static compilation** - static binary with minimal dependencies
- **Mint tool integration** - slimmed version of the image
- **UPX runtime efficiency** - minimal memory overhead with fast decompression (Executable compression)
- **Binary stripping** and **LTO optimization** (DWARF debugging standard)

### **Performance Features**
- **zlib-ng** with modern compression algorithms (RFC 1950, RFC 1951, RFC 1952)
- **PCRE2 with JIT** compilation for regex performance
- **Thread pool support** for async I/O operations
- **TCP Fast Open** and **SSL session resumption** (RFC 7413, RFC 8446)
- **Graceful shutdown** - SIGQUIT handling for proper connection draining (RFC 7230)
- **Brotli** and **ZSTD** compression mechanisms support (RFC 7932, RFC 8878)
- **Native TLS compression** - support for certificate compression (RFC 8879)

### **Quality Metrics**
- **Image efficiency** - perfect score in Dive analysis (100%)
- **Comprehensive OCI labels** - standardized metadata and annotations
- **No excess ENTRYPOINT** - no unnecessary wrapper scripts or bloat (12-factor app methodology, Cloud Native patterns)
- **Built-in HEALTHCHECK** - Configuration validation every 30s with 3s timeout (Docker HEALTHCHECK specification)

## 🤝 Contributing & Support

Found an issue or have an improvement?
- [Open an Issue](https://github.com/ammnt/nginx/issues/new?template=bug_report.md)
- [Feature Request](https://github.com/ammnt/nginx/issues/new?template=feature_request.md)

> **Note:** This image is designed for security-conscious production environments. For development purposes, consider using the official NGINX image with full debugging capabilities.

## 📄 License

This project is open source and maintained with ❤️ by [ammnt](https://msftcnsi.com).
