# build stage
FROM golang:1.13 as builder

ENV GO111MODULE=on

WORKDIR /app

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN arch=$(arch) && \
    [ "$arch" = "amd64" ] && export GOARCH="amd64" && \
    [ "$arch" = "aarch64" ] && export GOARCH="arm64" && \
    CGO_ENABLED=0 GOOS=linux go build

# final stage
FROM scratch

COPY --from=builder /app/imagepullsecret-patcher /app/

ENTRYPOINT ["/app/imagepullsecret-patcher"]