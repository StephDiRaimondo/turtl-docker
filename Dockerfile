FROM alpine:latest

RUN apk --no-cache add gcc git nano libuv-dev readline

# Install ccl
WORKDIR /tmp/
RUN mkdir -p /opt/ccl
RUN wget ftp://ftp.clozure.com/pub/release/1.11/ccl-1.11-linuxx86.tar.gz
RUN tar xvzf ccl-1.11-linuxx86.tar.gz -C /opt/ccl --strip-components=1

# install quicklisp
COPY quicklisp_install /quicklisp_install
#RUN wget https://beta.quicklisp.org/quicklisp.lisp
COPY quicklisp.lisp /quicklisp.lisp
