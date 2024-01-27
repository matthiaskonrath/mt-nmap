ARG ALPINE_TAG=latest
FROM alpine:${ALPINE_TAG}

LABEL maintainer="Matthias Konrath" \
    description="Mikrotik NMAP Container"

RUN apk -U upgrade \
    && apk add --no-cache \
        nmap \
        nmap-scripts \
    && rm -rf /var/cache/apk/*

ENTRYPOINT ["/usr/bin/nmap"]