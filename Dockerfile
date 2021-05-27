FROM golang:latest AS builder
WORKDIR /app
COPY . /app
RUN go build
FROM alpine:latest AS kube
WORKDIR /app
ARG ARCH_VALUE
ENV DOCKER_ARCH=$ARCH_VALUE
RUN apk add gettext ca-certificates openssl \
    && wget https://storage.googleapis.com/kubernetes-release/release/$(wget https://storage.googleapis.com/kubernetes-release/release/stable.txt -q -O -)/bin/linux/{$DOCKER_ARCH}/kubectl -q -O /usr/local/bin/kubectl \
FROM alpine:latest
RUN apk add --no-cache curl
COPY --from=builder /app/Watch /
COPY --from=kube /usr/local/bin/kubectl /usr/local/bin/kubectl
ENTRYPOINT ["/Watch"]
