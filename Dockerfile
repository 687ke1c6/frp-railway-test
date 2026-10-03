FROM alpine:3.22 AS downloader

ARG FRP_VERSION=0.71.0
ARG TARGETARCH=amd64

RUN apk add --no-cache curl tar \
    && curl -fsSL -o /tmp/frp.tar.gz \
        "https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_${TARGETARCH}.tar.gz" \
    && tar -xzf /tmp/frp.tar.gz -C /tmp \
    && mv /tmp/frp_${FRP_VERSION}_linux_${TARGETARCH}/frps /frps

FROM alpine:3.22

RUN apk add --no-cache ca-certificates

COPY --from=downloader /frps /usr/local/bin/frps
COPY frps.toml /etc/frp/frps.toml

EXPOSE 7000

ENTRYPOINT ["/usr/local/bin/frps"]
CMD ["-c", "/etc/frp/frps.toml"]
