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

### Imagem intermediária de compilação
FROM base AS builder
WORKDIR /app


COPY ../.. /app
RUN go mod download \
    && go mod verify

### precisa definiar o nome do aplicativo, pode pegar por ARGS

RUN go build -o aa-app -a .

### Criação da imagem final do ambiente de produção
FROM alpine:latest as production

RUN apk update \
    && apk add --no-cache \
    ca-certificates \
    && update-ca-certificates

# copia o executável do builder
COPY --from=builder /app/aa-app /usr/aa-app
EXPOSE 8080

ENTRYPOINT ["/usr/aa-app"]