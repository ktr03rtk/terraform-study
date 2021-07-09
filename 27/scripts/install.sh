#!/bin/sh

BASE_URL=https://github.com/mercari/tfnotify/releases/download

DOWNLOAD_URL="${BASE_URL}/v0.7.0/tfnotify_linux_amd64.tar.gz"
wget ${DOWNLOAD_URL} -P /tmp
tar zxvf /tmp/tfnotify_linux_amd64.tar.gz -C /tmp
mv /tmp/tfnotify_linux_amd64/tfnotify /usr/local/bin/tfnotify