FROM ubuntu:bionic
MAINTAINER Jonir Rings
# shared data
VOLUME ["/data"]

# change the mirror to USTC (only for china mainland)
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
RUN apt-get update --fix-missing

# general dependencies
RUN apt-get install -y curl fish vim

# install target toolchain
RUN apt-get install -y build-essential gcc-arm-linux-gnueabihf gcc-aarch64-linux-gnu

# install Rust
WORKDIR /root
ENV USER root
RUN curl https://sh.rustup.rs -sSf > rustup.sh
RUN chmod +x rustup.sh
RUN /bin/sh -c './rustup.sh -y'
RUN echo 'export PATH="$HOME/.cargo/bin:$PATH"' > /root/.profile
# change the rust mirror to USTC (only for china mainland)
RUN echo 'export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static' >> /root/.profile
RUN echo 'export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup' >> /root/.profile

# load env
RUN source /root/.profile

# install cross-compiled standard crates
RUN /root/.cargo/bin/rustup target add armv7-unknown-linux-gnueabihf aarch64-unknown-linux-gnu

# configure cargo for cross compilation
COPY ./configure.sh /root/configure.sh
RUN chmod +x /root/configure.sh
RUN /root/configure.sh

# generate hello world
WORKDIR /root
ENV USER root
ENV PATH $PATH:/root/.cargo/bin
RUN cargo new hello

# build
WORKDIR /root/hello
RUN cargo build --target=armv7-unknown-linux-gnueabihf
RUN cargo build --target=aarch64-unknown-linux-gnu

WORKDIR /root
ENTRYPOINT /bin/bash