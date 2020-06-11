FROM golang:1.14.4 AS builder
WORKDIR /go/src/github.com/zalando/postgres-operator/
COPY . .
RUN make linux


FROM alpine:3.12.0
MAINTAINER Team ACID @ Zalando <team-acid@zalando.de>

# We need root certificates to deal with teams api over https
RUN apk --no-cache add ca-certificates

COPY --from=builder /go/src/github.com/zalando/postgres-operator/build/* /

RUN addgroup -g 1000 pgo
RUN adduser -D -u 1000 -G pgo -g 'Postgres Operator' pgo

USER 1000:1000

ENTRYPOINT ["/postgres-operator"]