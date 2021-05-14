FROM golang:1.16-alpine AS base
WORKDIR /app

ENV GO111MODULE="on"
ENV GOOS="linux"
ENV CGO_ENABLED=0

# System dependencies
RUN apk update \
    && apk add --no-cache \
    ca-certificates \
    && update-ca-certificates

### Ambiente dev com hot reload
FROM base AS dev
WORKDIR /app

# hot reload
RUN go get -u github.com/cosmtrek/air


ENTRYPOINT ["air"]



