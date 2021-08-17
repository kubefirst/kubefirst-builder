FROM docker:latest

RUN apk --no-cache add \
  ansible \
  bash \
  binutils \
  binutils-gold \
  coreutils \
  curl \
  findutils \
  g++ \
  gcc \
  git \
  gnupg \
  go \
  grep \
  groff \
  jq \
  less \
  libc6-compat \
  libgcc \
  libstdc++ \
  linux-headers \
  make \
  musl \
  musl-dev \
  openssh-client \
  openssl \
  postgresql \
  postgresql-dev \
  python3 \
  python3-dev \
  py3-pip \
  sed \
  unzip \
  util-linux \
  zip \
  && rm -rf /var/cache/apk/*

RUN pip3 install awscli --upgrade 

RUN echo $HOME && cd ~ && touch .profile \
  && (curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash) \
  && (echo "export NVM_NODEJS_ORG_MIRROR=https://unofficial-builds.nodejs.org/download/release" >> .profile) \
  && (echo "nvm_get_arch() { nvm_echo \"x64-musl\"; }" >> .profile) \
  && (echo "export NVM_IOJS_ORG_MIRROR=https://example.com" >> .profile) \
  && source .profile

RUN ln -s /lib /lib64 \
  && export NVM_DIR="$HOME/.nvm" \
  && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
  && source ~/.profile \
  && nvm_get_arch \
  && echo $NVM_NODEJS_ORG_MIRROR \
  && nvm install 14 --no-progress 

ENV KUBECTL_VERSION v1.17.17 
ENV AWS_IAM_AUTH_VERSION 0.5.2 

ADD https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl /usr/local/bin/kubectl
ADD https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${AWS_IAM_AUTH_VERSION}/aws-iam-authenticator_${AWS_IAM_AUTH_VERSION}_linux_amd64 /usr/local/bin/aws-iam-authenticator
ADD https://amazon-eks.s3.us-west-2.amazonaws.com/1.18.9/2020-11-02/bin/linux/amd64/aws-iam-authenticator /usr/local/bin/aws-iam-authenticator
RUN chmod +x /usr/local/bin/kubectl /usr/local/bin/aws-iam-authenticator

# install hashicorp vault
ENV VAULT_VERSION 1.6.2
RUN curl -LO https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip \
  && unzip vault_${VAULT_VERSION}_linux_amd64.zip \
  && chmod +x vault \
  && mv vault /usr/local/bin/vault \
  && rm -f vault_${VAULT_VERSION}_linux_amd64.zip


# DESIRED_VERSION is the helm version to install
ENV DESIRED_VERSION v3.5.0

RUN mkdir -p $HOME/.helm && export HELM_HOME="$HOME/.helm" && curl -L https://git.io/get_helm.sh | /bin/bash

CMD [ "/bin/bash" ]
