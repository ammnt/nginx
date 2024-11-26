ARG BASE_VERSION=3.20
FROM docker.io/library/alpine:${BASE_VERSION}
ENV OPENSSL_BRANCH=openssl-3.4
ENV APP_BRANCH=release-1.27.3
RUN NB_CORES="${BUILD_CORES-$(getconf _NPROCESSORS_CONF)}" \
&& apk -U upgrade && apk add --no-cache \
    openssl \
    pcre \
    zlib-ng \
    libgcc \
    libstdc++ \
    g++ \
    make \
    build-base \
    linux-headers \
    ca-certificates \
    automake \
    autoconf \
    git \
    talloc \
    talloc-dev \
    libtool \
    pcre-dev \
    zlib-ng-dev \
    binutils \
    gnupg \
    cmake \
    go \
    libxslt \
    libxslt-dev \
    tini \
    musl-dev \
    ncurses-libs \
    gd-dev \
    brotli-libs \
&& cd /tmp && git clone -b "${APP_BRANCH}" https://github.com/nginx/nginx && rm -rf /tmp/nginx/docs/html/* \
&& sed -i -e 's@"nginx/"@" "@g' /tmp/nginx/src/core/nginx.h \
&& sed -i -e 's@"nginx version: "@" "@g' /tmp/nginx/src/core/nginx.c \
&& sed -i -e 's@r->headers_out.server == NULL@0@g' /tmp/nginx/src/http/ngx_http_header_filter_module.c \
&& sed -i -e 's@r->headers_out.server == NULL@0@g' /tmp/nginx/src/http/v2/ngx_http_v2_filter_module.c \
&& sed -i -e 's@r->headers_out.server == NULL@0@g' /tmp/nginx/src/http/v3/ngx_http_v3_filter_module.c \
&& sed -i -e 's@<hr><center>nginx</center>@@g' /tmp/nginx/src/http/ngx_http_special_response.c \
&& sed -i -e 's@NGINX_VERSION      ".*"@NGINX_VERSION      " "@g' /tmp/nginx/src/core/nginx.h \
&& sed -i -e 's/SSL_OP_CIPHER_SERVER_PREFERENCE);/SSL_OP_CIPHER_SERVER_PREFERENCE | SSL_OP_PRIORITIZE_CHACHA);/g' /tmp/nginx/src/event/ngx_event_openssl.c \
&& addgroup --gid 101 -S nginx && adduser -S nginx -s /sbin/nologin -G nginx --uid 101 --no-create-home \
&& git clone --recursive --depth 1 --single-branch -b ${OPENSSL_BRANCH} https://github.com/openssl/openssl \
&& git clone --depth=1 --recursive --shallow-submodules https://github.com/google/ngx_brotli && git clone --depth=1 --recursive --shallow-submodules https://github.com/nginx/njs \
&& cd /tmp/njs && ./configure && make -j "${NB_CORES}" && make clean \
&& mkdir /var/cache/nginx && cd /tmp/nginx && ./auto/configure \
    --with-debug \
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --user=nginx \
    --group=nginx \
    --http-log-path=/tmp/access.log \
    --error-log-path=/tmp/error.log \
    --conf-path=/etc/nginx/nginx.conf \
    --pid-path=/tmp/nginx.pid \
    --lock-path=/tmp/nginx.lock \
    --http-client-body-temp-path=/var/cache/nginx/client_temp \
    --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
    --with-openssl="/tmp/openssl" \
    --with-openssl-opt=enable-ec_nistp_64_gcc_128 \
    --with-cc-opt="-O3 -g -m64 -march=westmere -falign-functions=32 -flto -funsafe-math-optimizations -fstack-protector-strong --param=ssp-buffer-size=4 -Wimplicit-fallthrough=0 -Wno-error=strict-aliasing -Wformat -Wno-error=pointer-sign -Wno-implicit-function-declaration -Wno-int-conversion -Wno-error=unused-result -Wno-unused-result -fcode-hoisting -Werror=format-security -Wno-deprecated-declarations -Wp,-D_FORTIFY_SOURCE=2 -DTCP_FASTOPEN=23 -fPIC" \
    --with-ld-opt="-lrt -ltalloc -Wl,-Bsymbolic-functions -lpcre -Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie" \
    --with-compat \
    --with-file-aio \
    --with-pcre-jit \
    --with-threads \
    --with-http_realip_module \
    --with-http_stub_status_module \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_v3_module \
    --with-http_gzip_static_module \
    --with-stream \
    --with-stream_realip_module \
    --with-stream_ssl_module \
    --with-stream_ssl_preread_module \
    --without-stream_split_clients_module \
    --without-stream_set_module \
    --without-http_geo_module \
    --without-http_scgi_module \
    --without-http_uwsgi_module \
    --without-http_autoindex_module \
    --without-http_split_clients_module \
    --without-http_memcached_module \
    --without-http_ssi_module \
    --without-http_empty_gif_module \
    --without-http_browser_module \
    --without-http_userid_module \
    --without-http_mirror_module \
    --without-http_referer_module \
    --without-mail_pop3_module \
    --without-mail_imap_module \
    --without-mail_smtp_module \
    --add-module=/tmp/njs/nginx \
    --add-module=/tmp/ngx_brotli \
&& make -j "${NB_CORES}" && make install && make clean && strip /usr/sbin/nginx* \
&& chown -R nginx:nginx /var/cache/nginx && chmod -R g+w /var/cache/nginx \
&& chown -R nginx:nginx /etc/nginx && chmod -R g+w /etc/nginx \
&& update-ca-certificates && apk --purge del libgcc musl-dev g++ make build-base linux-headers automake autoconf git talloc talloc-dev libtool zlib-ng-dev binutils gnupg cmake go pcre-dev ca-certificates openssl libxslt-dev apk-tools gd-dev \
&& rm -rf /tmp/* /var/cache/apk/ /var/cache/misc /root/.gnupg /root/.cache /root/go /etc/apk \
&& ln -sf /dev/stdout /tmp/access.log && ln -sf /dev/stderr /tmp/error.log

COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./default.conf /etc/nginx/conf.d/default.conf

ENTRYPOINT [ "/sbin/tini", "--" ]

EXPOSE 8080/tcp 8443/tcp 8443/udp
LABEL description="Distroless NGINX built with QUIC and HTTP/3 support🚀" \
      maintainer="ammnt <admin@msftcnsi.com>" \
      org.opencontainers.image.description="Distroless NGINX built with QUIC and HTTP/3 support🚀" \
      org.opencontainers.image.authors="ammnt, admin@msftcnsi.com" \
      org.opencontainers.image.title="Distroless NGINX built with QUIC and HTTP/3 support🚀" \
      org.opencontainers.image.source="https://github.com/ammnt/nginx/"

STOPSIGNAL SIGQUIT
USER nginx
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
