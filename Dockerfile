FROM centos:latest
MAINTAINER yumaito

RUN yum update -y && \
    yum install -y epel-release && \
    yum install -y sudo bzip2 make which wget tar git vim jq gcc patch readline-devel zlib-devel libyaml-devel openssl-devel \
    gdbm-devel ncurses-devel libxml-devel && \
    yum clean all
