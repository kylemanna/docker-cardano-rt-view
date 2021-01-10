FROM alpine:latest as builder

ARG VER=0.2.0
ARG URL=https://github.com/input-output-hk/cardano-rt-view/releases/download/${VER}/cardano-rt-view-${VER}-linux-x86_64.tar.gz

# Use alpine to download with curl wich pulls in PKI certs.
RUN apk add --update curl && \
    mkdir -p /opt/cardano-rt-view && \
    cd /opt/cardano-rt-view && \
    curl -L ${URL} | tar zxvf -

FROM busybox
COPY --from=builder /opt/ /opt/
EXPOSE 8024 
EXPOSE 3000 
WORKDIR /opt/cardano-rt-view
RUN mkdir -pv /config
COPY cardano-rt-view.json /config/cardano-rt-view.json
CMD /opt/cardano-rt-view/cardano-rt-view --config /config/cardano-rt-view.json
