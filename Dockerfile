FROM golang:1.15-alpine

WORKDIR /go/dummy
RUN go mod init dummy
RUN go get github.com/go-bindata/go-bindata/v3@v3.1.3
RUN go get github.com/elazarl/go-bindata-assetfs/go-bindata-assetfs@v1.0.1
RUN GOMODULE111=on CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build github.com/elazarl/go-bindata-assetfs/go-bindata-assetfs
RUN GOMODULE111=on CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build github.com/go-bindata/go-bindata/go-bindata

FROM alpine:3.13.1
COPY --from=0 /go/dummy/go-bindata-assetfs /usr/bin/
COPY --from=0 /go/dummy/go-bindata /usr/bin/
ENTRYPOINT ["/usr/bin/go-bindata-assetfs"]
