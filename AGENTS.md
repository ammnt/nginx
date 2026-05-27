# AGENTS.md — AI Agent Instructions for Distroless NGINX

## 🎯 Project Overview
Production-ready, security-hardened NGINX image built from scratch with HTTP/3, QUIC, ECH, and PQC support.
- **Base:** Scratch (distroless)
- **Builder:** Alpine Linux (multi-stage)
- **Compiler:** GCC with `-fhardened` flags
- **User:** 10001:10001 (rootless by design)
- **Registry:** ghcr.io/ammnt/nginx, Docker Hub: ammnt/nginx

## 🏗️ Build System

### Key Technologies
- **BuildKit** with Docker Buildx for multi-stage builds
- **Static compilation** — no dynamic linking to system libraries
- **Mint** for image slimming (post-build optimization)
- **UPX** for binary compression (with careful exclusions)
- **Cosign** for signing and attestation

### Build Arguments (from .env)
```bash
BASE_VERSION    # Alpine base version
BASE_HASH       # Alpine image digest
OPENSSL_VERSION # OpenSSL version
APP_VERSION     # NGINX version
VCS_REF         # Git commit SHA
BUILD_DATE      # Build timestamp
```

### Critical Build Constraints
- ❌ NEVER add shell/package manager to final image
- ❌ NEVER add NJS module (security: libxml2/libxslt vulns)
- ❌ NEVER change user from 10001:10001
- ❌ NEVER add ENTRYPOINT scripts (only CMD)
- ✅ MUST compile with `-fhardened` flags
- ✅ MUST strip binaries after compilation
- ✅ MUST include HEALTHCHECK
- ✅ MUST support TLS 1.3, QUIC, HTTP/3, ECH, PQC

## 📁 File Structure Conventions

### Dockerfile.template
- Multi-stage: `builder` (Alpine) → `final` (scratch)
- Build phases: deps → build → strip → final
- Static linking with musl
- No unnecessary layers (chain RUN commands)

### NGINX Configuration
- `nginx.conf` — main configuration
- `default.conf` — default server block
- `example.conf` — reference for HTTP/3, ECH, PQC
- Listen on 8080 (HTTP) and 8443 (HTTPS) by default

### Security Scanning Matrix
- Hadolint → Dockerfile linting
- Trivy/Grype/Snyk/Clair → Vulnerability scanning
- Dockle → CIS benchmark validation
- Syft → SBOM generation (CycloneDX)
- Scout → Docker official scanning
- CodeQL → SAST analysis (separate workflow)

## 🔒 Security Rules

### Container Security
- User: 10001:10001 (non-root)
- Read-only root filesystem
- Drop ALL capabilities
- No new privileges
- Seccomp profile provided (`nginx-seccomp.json`)
- HEALTHCHECK interval: 30s, timeout: 3s

### Image Hardening
- `-fhardened` GCC flag (includes: stack-protector-strong, PIE, FORTIFY_SOURCE=3, -fstack-clash-protection, -fcf-protection=full, -ftrivial-auto-var-init=zero, -D_GLIBCXX_ASSERTIONS)
- LTO (Link Time Optimization)
- Strip DWARF debug symbols
- Remove static libraries after build
- UPX compression with `--lzma --best`

### Supply Chain
- All images signed with Cosign (key in `cosign.pub`)
- Provenance attestations (SLSA Level 3)
- Pin GitHub Actions to specific commits
- SBOM for every release
- No external images in CI (use pinned versions)

## 🚫 Anti-Patterns

### Dockerfile
```dockerfile
# ❌ DON'T do this
FROM alpine  # Final stage must be scratch
RUN apk add nginx  # No package managers
USER root  # Never run as root
COPY --from=builder /bin/sh /bin/sh  # No shells

# ✅ DO this
FROM scratch
COPY --from=builder /usr/local/nginx /usr/local/nginx
USER 10001:10001
```

### Configuration
```nginx
# ❌ DON'T do this
server_tokens on;  # Never expose version
user root;  # Never run as root
listen 80;  # No privileged ports

# ✅ DO this
server_tokens off;
listen 8080;
```

## 🧪 Testing and CI/CD

### CI Pipeline Stages
1. **Build** — Compile NGINX with hardening flags
2. **Slim** — Run Mint for optimization
3. **Scan** — Matrix of 8 security scanners
4. **Sign** — Cosign signing + attestation
5. **Release** — GitHub Release + Docker Hub sync

## 📝 Contribution Guidelines

### PR Requirements
- ✅ Must pass all 8 security scanners
- ✅ Must have Dive efficiency score = 100%
- ✅ Must not increase image size (target: <20MB)
- ✅ Must maintain PSS Restricted compliance
- ✅ Must include changelog in PR description
- ✅ Signed commits preferred (but not required)

### Version Bumping
- Update `.env` with new versions
- Update `example.conf` if configuration changes
- Update `SECURITY.md` if security posture changes
- Don't forget to update `README.md` badges

## 🔧 Tool Versions

### Automated (fetched from GitHub API in CI)
- Cosign, Buildx, BuildKit, Mint
- Dive, Grype, Syft, Trivy

### Manual (in .env)
- NGINX version, OpenSSL version
- Alpine base version and hash

## 📚 Key Dependencies

### Compile-time
- OpenSSL (with QUIC, PQC, ECH support)
- zlib-ng (replacement for zlib)
- PCRE2 (with JIT)
- Brotli (compression)
- ZSTD (compression)

### Build-time only
- GCC + musl-dev
- Make, Perl, Linux headers
- Git (for version detection)

## 🎨 Code Style

### Shell Scripts (in CI)
```bash
# Use strict mode
set -euo pipefail

# Always quote variables
echo "${VARIABLE}"
```

### YAML (GitHub Actions)
- Use specific commit hashes for actions
- Prefer `>> $GITHUB_OUTPUT` over `::set-output`
- Group related steps with emoji in names
- Use job outputs for cross-job data sharing

## 📞 Getting Help

- Issues: [GitHub Issues](https://github.com/ammnt/nginx/issues)
- Security: See `SECURITY.md` for responsible disclosure
- Discussions: Use GitHub Discussions for questions
