#!/bin/bash

cd /opt
rm xbps-static-static-0.56_5.x86_64-musl.tar.xz
wget https://alpha.de.repo.voidlinux.org/static/xbps-static-static-0.56_5.x86_64-musl.tar.xz
install -d -m0755 xbps-static-static-0.56_5
cd -
cd /opt/xbps-static-static-0.56_5
tar xvpJf ../xbps-static-static-0.56_5.x86_64-musl.tar.xz
cd -

