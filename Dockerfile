FROM alpine:latest

RUN apk --no-cache add gcc git nano libuv-dev readline

# Install ccl
WORKDIR /tmp/
RUN mkdir -p /opt/ccl
RUN wget ftp://ftp.clozure.com/pub/release/1.11/ccl-1.11-linuxx86.tar.gz
RUN tar xvzf ccl-1.11-linuxx86.tar.gz -C /opt/ccl --strip-components=1

# install quicklisp
COPY quicklisp_install /opt/quicklisp_install
COPY quicklisp.lisp /tmp/quicklisp.lisp
#RUN wget https://beta.quicklisp.org/quicklisp.lisp
RUN cat /opt/quicklisp_install | /opt/ccl/lx86cl64 --load /tmp/quicklisp.lisp

# install RethinkDB
RUN apk add rethinkdb --update-cache --repository http://nl.alpinelinux.org/alpine/edge/testing --allow-untrusted

# install turtl API
WORKDIR /opt/ 
RUN git clone https://github.com/turtl/api.git --depth 1
WORKDIR /root/quicklisp/local-projects
RUN git clone git://github.com/orthecreedence/cl-hash-util
RUN /opt/ccl/lx86cl64 -l /root/quicklisp/setup.lisp

# config
COPY config.footer /opt/api/config/
COPY turtl-setup turtl-start /opt/
RUN chmod a+x /opt/turtl-setup /opt/turtl-start
COPY launch.lisp /opt/api/
COPY rethinkdb.conf /etc/rethinkdb/instances.d/instance1.conf

# cleaning
RUN rm -rf /opt/ccl-1.11-linuxx86.tar.gz

# general settings
EXPOSE 8181
WORKDIR /opt/api
VOLUME /var/lib/rethinkdb/instance1
CMD /opt/turtl-setup
