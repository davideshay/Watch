FROM alpine:3.13
RUN apk add --no-cache curl
ADD Watch /
ENTRYPOINT ["/Watch"]
