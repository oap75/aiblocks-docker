#!/usr/bin/env bash

set -ue

# install deps
apt-get update
apt-get install -y $STELLAR_CORE_BUILD_DEPS

# clone, compile, and install stellar core
git clone --branch $STELLAR_CORE_VERSION --recursive --depth 1 https://github.com/aiblocks/aiblocks-core.git

#mv /stellar-core/ /aiblocks-core/
cd /aiblocks-core/
./autogen.sh
./configure
#cd /pastel
#./refac_tool.py -p=../aiblocks-core/ -i=changes.txt > report.log
#cd ../aiblocks-core/
make
make install
cd ..

# install confd for config file management
wget -nv -O /usr/local/bin/confd https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64
chmod +x /usr/local/bin/confd

# cleanup
rm -rf aiblocks-core
apt-get remove -y git build-essential pkg-config autoconf automake libtool bison flex libpq-dev wget pandoc gcc-9 g++-9 mono-mcs software-properties-common
apt-get autoremove -y
apt-get autoclean -y
# install deps
apt-get install -y $STELLAR_CORE_DEPS

# cleanup apt cache
rm -rf /var/lib/apt/lists/*
