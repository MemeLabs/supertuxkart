FROM registry.fedoraproject.org/fedora-minimal:35 as builder

ARG TAG=1.3

RUN : \
  && set -x \
  && microdnf update -y \
  && microdnf install -y \
    sudo \
    git \
    subversion \
    cmake \
    angelscript-devel \
    bluez-libs-devel \
    desktop-file-utils \
    SDL2-devel \
    freealut-devel \
    freetype-devel \
    gcc-c++ \
    libcurl-devel \
    libjpeg-turbo-devel \
    libpng-devel \
    libsquish-devel \
    libtool \
    libvorbis-devel \
    openal-soft-devel \
    openssl-devel \
    libcurl-devel \
    harfbuzz-devel \
    libogg-devel \
    openssl-devel \
    pkgconf \
    wiiuse-devel \
    zlib-devel \
  && microdnf clean all \
  && :

RUN : \
  && set -x \
  && mkdir stk-{code,assets} \
  && git clone -b ${TAG} https://github.com/supertuxkart/stk-code stk-code \
  && svn co https://svn.code.sf.net/p/supertuxkart/code/stk-assets stk-assets \
  && mkdir stk-code/cmake_build \
  && cd stk-code/cmake_build \
  && cmake .. -DSERVER_ONLY=ON \
  && make -j$(nproc) \
  && sudo make install \
  && :

FROM registry.fedoraproject.org/fedora-minimal:35

COPY --from=builder \
  /lib64/libcurl.so.4 \
  /lib64/libresolv.so.2 \
  /lib64/libcrypto.so.1.1 \
  /lib64/libz.so.1 \
  /lib64/libstdc++.so.6 \
  /lib64/libm.so.6 \
  /lib64/libgcc_s.so.1 \
  /lib64/libc.so.6 \
  /lib64/libnghttp2.so.14 \
  /lib64/libidn2.so.0 \
  /lib64/libssh.so.4 \
  /lib64/libpsl.so.5 \
  /lib64/libssl.so.1.1 \
  /lib64/libgssapi_krb5.so.2 \
  /lib64/libkrb5.so.3 \
  /lib64/libk5crypto.so.3 \
  /lib64/libcom_err.so.2 \
  /lib64/libldap_r-2.4.so.2 \
  /lib64/liblber-2.4.so.2 \
  /lib64/libbrotlidec.so.1 \
  /lib64/ld-linux-x86-64.so.2 \
  /lib64/libunistring.so.2 \
  /lib64/libkrb5support.so.0 \
  /lib64/libkeyutils.so.1 \
  /lib64/libsasl2.so.3 \
  /lib64/libbrotlicommon.so.1 \
  /lib64/libselinux.so.1 \
  /lib64/libcrypt.so.2 \
  /lib64/libpcre2-8.so.0 \
  /lib64/

COPY --from=builder \
  /usr/local/bin/supertuxkart \
  /usr/local/bin/

COPY --from=builder \
  /usr/local/share/supertuxkart/ \
  /usr/local/share/supertuxkart/

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

RUN : \
  && set -x \
  && microdnf update -y \
  && microdnf install -y \
    tini \
  && microdnf clean all -y \
  && update-ca-trust \
  && :

ENV PATH="/usr/local/bin:${PATH}"
ENTRYPOINT ["tini", "--", "entrypoint.sh", "supertuxkart"]
