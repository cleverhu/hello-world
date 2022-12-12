# Build the manager binary
FROM --platform=$BUILDPLATFORM docker.m.daocloud.io/library/golang:1.18 as builder

ENV GOPROXY=https://goproxy.cn,direct

# Copy in the go src
WORKDIR /app
COPY . .

ARG TARGETARCH
# Build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=$TARGETARCH GO111MODULE=off go build  -o hello-world main.go

# Copy the controller-manager into a thin image
FROM docker.m.daocloud.io/library/alpine:3.13
RUN apk add --no-cache tzdata
WORKDIR /root/
COPY --from=builder /app/hello-world .

RUN chmod +x /root/hello-world

ENTRYPOINT  ["/root/hello-world"]
