FROM docker:latest

RUN apk --no-cache add \
  bash \
  coreutils \
  curl \
  openssl \
  python3 \
  py3-pip \
  sed \
  util-linux \
  && rm -rf /var/cache/apk/*

RUN pip3 install pyyaml semver --upgrade 

# DESIRED_VERSION is the helm version to install
ENV DESIRED_VERSION v3.5.0
RUN mkdir -p $HOME/.helm && export HELM_HOME="$HOME/.helm" && curl -L https://git.io/get_helm.sh | /bin/bash

CMD [ "/bin/bash" ]
