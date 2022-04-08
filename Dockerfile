FROM golang:1.14 as build

#ENV GOPROXY=https://goproxy.cn
#ENV GO111MODULE=on

WORKDIR /go/cache

ADD go.mod .
ADD go.sum .
RUN go mod download

WORKDIR /go/release


ADD . .
RUN GOOS=linux CGO_ENABLED=0 go build -ldflags="-s -w" -installsuffix cgo -o robFoodDD main.go


FROM ubuntu
RUN apt-get update
RUN update-ca-certificates
ADD ca-certification.cer /ets/ssl/certs
COPY --from=build /go/release/robFoodDD /bin/robFoodDD


ENTRYPOINT ["/bin/robFoodDD"]
