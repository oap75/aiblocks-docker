FROM ubuntu:20.04

# git tag from https://github.com/stellar/stellar-core
ARG STELLAR_CORE_VERSION="dev"
ARG STELLAR_CORE_BUILD_DEPS="git build-essential pkg-config autoconf automake libtool bison flex libpq-dev wget pandoc python3"
ARG STELLAR_CORE_DEPS="curl jq libpq5"
ARG CONFD_VERSION="0.16.0"

#COPY  pastel /pastel/
#RUN chmod 777 -R /pastel

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/*
RUN add-apt-repository ppa:ubuntu-toolchain-r/test && \
        apt-get update && \
    apt-get -y install gcc-9 g++-9 mono-mcs && \
    rm -rf /var/lib/apt/lists/*
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-9
RUN apt-get update && \
        apt-get install -y git build-essential pkg-config autoconf automake libtool bison flex libpq-dev wget pandoc python3 vim && \
    rm -rf /var/lib/apt/lists/*

# install stellar core and confd
ADD install.sh /
RUN /install.sh

VOLUME /data

# peer port
EXPOSE 11625

# HTTP port (do NOT expose publicly)
EXPOSE 11626

# configuration options, see here for docs:
# https://github.com/stellar/stellar-core/blob/master/docs/stellar-core_example.cfg

ADD ready.sh /
ADD confd /etc/confd

ADD entry.sh /
CMD ["/entry.sh"]

#CMD ["/usr/local/bin/aiblocks-core", "run", "--conf", "/aiblocks-core.cfg"]
