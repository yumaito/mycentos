FROM centos:latest
MAINTAINER yumaito

RUN yum update -y && \
    yum install -y epel-release && \
    yum install -y sudo bzip2 make which wget tar git vim jq gcc patch readline-devel zlib-devel libyaml-devel openssl-devel \
    gdbm-devel ncurses-devel libxml-devel && \
    yum clean all

RUN echo 'alias vi=vim' >> /etc/profile

COPY ./vim/.vimrc /.vimrc
COPY ./vim/.vim/dein.toml /.vim/rc/dein.toml
COPY ./vim/.vim/dein_lazy.toml /.vim/rc/dein_lazy.toml
