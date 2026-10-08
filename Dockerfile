FROM alpine:3.22 AS downloader

ARG FRP_VERSION=0.71.0
ARG TARGETARCH

RUN apk add --no-cache curl tar \
    && ARCH="${TARGETARCH:-amd64}" \
    && curl -fsSL -o /tmp/frp.tar.gz \
        "https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_${ARCH}.tar.gz" \
    && tar -xzf /tmp/frp.tar.gz -C /tmp \
    && mv /tmp/frp_${FRP_VERSION}_linux_${ARCH}/frpc /frpc \
    && mv /tmp/frp_${FRP_VERSION}_linux_${ARCH}/frps /frps

FROM alpine:3.22

RUN apk add --no-cache ca-certificates

COPY --from=downloader /frpc /usr/local/bin/frpc
COPY --from=downloader /frps /usr/local/bin/frps

CMD ["frpc", "-c", "/etc/frp/frpc.toml"]
