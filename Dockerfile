FROM alpine:3.8

ENV PYTHON_VERSION 3.6.8-r0

ENV PIP get-pip.py
ADD https://bootstrap.pypa.io/get-pip.py /tmp/

ENV ROOT_PATH=${PATH}:~/.local/bin

COPY ./requirements.txt /requirements/

RUN apk add --update --no-cache \
  bash \
  curl \
  freetype \
  g++ \
  gcc \
  jq \
  libffi-dev \
  libressl-dev \
  libsodium \
  libstdc++ \
  linux-headers \
  make \
  musl-dev \
  nginx \
  openblas \
  py3-zmq \
  python3=$PYTHON_VERSION \
  python3-dev \
  tini \
  zip \
  --virtual .builddeps build-base libffi-dev \

 && ln -s /usr/include/locale.h /usr/include/xlocale.h \
 && apk --no-cache add --virtual .builddeps\
  build-base \
  freetype-dev \
  gfortran \
  linux-headers \
  libressl-dev \
  libsodium \
  make \
  musl-dev \
  openblas-dev \
  pkgconf \
  python3-dev \
  wget

RUN pip3 install awscli \
  virtualenv
RUN virtualenv /venv
RUN /venv/bin/pip3 install --upgrade pip
RUN /venv/bin/pip3 install setuptools==41.0.0 \
  awscli \
  autopep8 \
  pylint \
  coverage \
  sphinx \
  sphinx-rtd-theme \
  s3pypi
RUN /venv/bin/pip3 install --no-cache-dir -r /requirements/requirements.txt

RUN rm -rf /tmp