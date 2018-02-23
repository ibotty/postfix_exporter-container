FROM fedora:27

ENV POSTFIX_EXPORTER_VERSION=0.1.0

# hack to let it build when option ndots:5 is set, which is not supported by muslc
RUN dnf install -y golang systemd-devel git glibc-devel glibc-static \
 && curl -L https://github.com/kumina/postfix_exporter/archive/${POSTFIX_EXPORTER_VERSION}.tar.gz | tar xz \
 && cd "postfix_exporter-$POSTFIX_EXPORTER_VERSION" \
 && export GOPATH=/gopath \
 && mkdir "$GOPATH" \
 && go get -d ./... \
 && go build --ldflags '-extldflags "-static"' \
 && mv "postfix_exporter-$POSTFIX_EXPORTER_VERSION" /postfix_exporter \
 && strip /postfix_exporter \
 && dnf clean all
