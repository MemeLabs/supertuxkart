FROM docker.io/library/ubuntu:20.10

ARG TAG=1.2

RUN : \
  && apt-get update -y \
  && apt-get upgrade -y \
  && apt-get install -y \
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
  && mkdir -p /stk/stk-{code,assets} \
  && git clone -b ${TAG} https://github.com/supertuxkart/stk-code /stk/stk-code \
  && svn co https://svn.code.sf.net/p/supertuxkart/code/stk-assets /stk/stk-assets \
  && cd /stk/stk-code \
  && mkdir cmake_build \
  && cd cmake_build \
  && cmake .. -DSERVER_ONLY=ON \
  && make install

ENTRYPOINT ["supertuxkart"]
CMD ["--server-config=/server_config.xml"]
