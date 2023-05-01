ARG GBVERSION=v3/v3.1.3
ARG GBAVERSION=@v1.0.1

FROM golang:1.20.3-alpine3.17

WORKDIR /go/dummy
RUN go mod init dummy
RUN go get github.com/go-bindata/go-bindata/${GBVERSION}
RUN go get github.com/elazarl/go-bindata-assetfs/go-bindata-assetfs${GBAVERSION}
RUN GOMODULE111=on CGO_ENABLED=0 GOOS=linux go build github.com/elazarl/go-bindata-assetfs/go-bindata-assetfs
RUN GOMODULE111=on CGO_ENABLED=0 GOOS=linux go build github.com/go-bindata/go-bindata/go-bindata

FROM alpine:3.17
COPY --from=0 /go/dummy/go-bindata-assetfs /usr/bin/
COPY --from=0 /go/dummy/go-bindata /usr/bin/
ENTRYPOINT ["/usr/bin/go-bindata-assetfs"]
