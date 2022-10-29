FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

ADD https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip /tmp/awscli.zip
ADD https://bootstrap.pypa.io/get-pip.py /tmp/get-pip.py
ADD https://raw.githubusercontent.com/dceoy/print-github-tags/master/print-github-tags /usr/local/bin/print-github-tags
ADD . /usr/local/src/code-to-ecr

RUN set -e \
      && ln -sf bash /bin/sh \
      && ln -s python3 /usr/bin/python

RUN set -e \
      && apt-get -y update \
      && apt-get -y dist-upgrade \
      && apt-get -y install --no-install-recommends --no-install-suggests \
        apt-transport-https ca-certificates curl git python3 python3-distutils \
        unzip \
      && apt-get -y autoremove \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*

RUN set -e \
      && /usr/bin/python3 /tmp/get-pip.py install -U --no-cache-dir \
      git-remote-codecommit pip pyproject.toml \
      && rm -f /tmp/get-pip.py

RUN set -e \
      && cd /tmp \
      && unzip awscli.zip \
      && ./aws/install \
      && rm -f /tmp/awscli.zip

RUN set -eo pipefail \
      && chmod +x /usr/local/bin/print-github-tags \
      && print-github-tags --release --latest aws-cloudformation/rain \
        | xargs -I{} curl -SL -o /tmp/rain.zip \
          https://github.com/aws-cloudformation/rain/releases/download/{}/rain-{}_linux-amd64.zip \
          https://github.com/lh3/bwa/releases/download/v{}/bwa-{}.tar.bz2 \
      && unzip -d /usr/local/src /tmp/rain.zip \
      && mv /usr/local/src/rain-* /usr/local/src/rain \
      && cd /usr/local/bin \
      && find ../src/rain ../src/code-to-ecr -type f -executable \
        -exec ln -s {} /usr/local/bin \;

ENTRYPOINT ["/usr/local/bin/code-to-ecr"]
