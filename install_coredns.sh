#!/bin/bash

# Fetch coredns files
wget https://github.com/coredns/coredns/releases/download/v1.6.9/coredns_1.6.9_linux_amd64.tgz
wget https://github.com/coredns/coredns/releases/download/v1.6.9/coredns_1.6.9_linux_amd64.tgz.sha256

shasum -a 256 coredns_1.6.9_linux_amd64.tgz
cat coredns_1.6.9_linux_amd64.tgz.sha256

tar -zxvf coredns_1.6.9_linux_amd64.tgz
sudo mv coredns /usr/local/bin/coredns

sudo mkdir -p /etc/coredns/zones
sudo cp db.opsschool.example /etc/coredns/zones