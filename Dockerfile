FROM golang:1.18.6-alpine3.16

WORKDIR /usr/src/app

# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
COPY go.mod ./
RUN go mod download && go mod verify

COPY hello.go .
RUN go build -v -o /usr/local/bin/app ./...

FROM scratch

WORKDIR /home

COPY --from=0 /usr/local/bin .
CMD ["./app"]