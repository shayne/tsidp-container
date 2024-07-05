FROM golang:1.22.5-alpine3.20 AS builder
RUN apk update && apk add --no-cache git

ARG TARGETOS TARGETARCH
RUN GOOS=$TARGETOS GOARCH=$TARGETARCH go install -ldflags="-w -s" tailscale.com/cmd/tsidp@latest
RUN apk del git

# ---

FROM scratch

COPY --from=builder /go/bin/tsidp /go/bin/tsidp
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

ENV TAILSCALE_USE_WIP_CODE=1
ENTRYPOINT ["/go/bin/tsidp"]
