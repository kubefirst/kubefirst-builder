FROM docker.io/alpine:3.20.3 as getter
WORKDIR /tmp
RUN apk add --no-cache wget tar
RUN wget https://get.helm.sh/helm-v3.16.1-linux-amd64.tar.gz 
RUN tar --no-same-permissions -zxvf helm-v3.16.1-linux-amd64.tar.gz linux-amd64/helm

FROM docker.io/alpine:3.20.3
LABEL org.opencontainers.image.source=https://github.com/kubefirst/kubefirst-builder
LABEL org.opencontainers.image.description="Minimal alpine image with Helm"
LABEL org.opencontainers.image.licenses=MIT
COPY --from=getter /tmp/linux-amd64/helm ./helm
ENTRYPOINT ["./helm"]
