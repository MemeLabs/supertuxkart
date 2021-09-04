FROM docker.io/library/ubuntu:20.10

ARG TAG=1.2

RUN : \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    sudo \
    tini \
    ca-certificates \
    build-essential \
    cmake \
    git \
    libbluetooth-dev \
    libcurl4-openssl-dev \
    libenet-dev \
    libfreetype6-dev \
    libharfbuzz-dev \
    libjpeg-dev \
    libogg-dev \
    libopenal-dev \
    libpng-dev \
    libsdl2-dev \
    libssl-dev \
    libvorbis-dev \
    nettle-dev \
    pkg-config \
    subversion \
    zlib1g-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && update-ca-certificates \
  && addgroup --gid 10001 --system stk \
  && adduser  --uid 10000 --system --ingroup stk --home /home/stk stk \
  && echo "stk ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/stk \
  && chmod 0440 /etc/sudoers.d/stk \
  && :

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

USER stk
WORKDIR /home/stk

RUN : \
  && mkdir stk-{code,assets} \
  && git clone -b ${TAG} https://github.com/supertuxkart/stk-code stk-code \
  && svn co https://svn.code.sf.net/p/supertuxkart/code/stk-assets stk-assets \
  && mkdir stk-code/cmake_build \
  && cd stk-code/cmake_build \
  && cmake .. -DSERVER_ONLY=ON \
  && make -j$(nproc) \
  && sudo make install \
  && rm -rf /home/stk/stk-{code,assets} \
  && :

ENV PATH="/usr/local/bin:${PATH}"
ENTRYPOINT ["tini", "--", "entrypoint.sh", "supertuxkart"]
