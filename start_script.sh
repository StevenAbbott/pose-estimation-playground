#!/usr/bin/env bash

/usr/sbin/sshd -D
git config --global --add safe.directory /pose-estimation-playground
git config --global user.name "StevenAbbott"
git config --global user.email "sbabbott08@gmail.com"


cd /pose-estimation-playground

#poetry env use /bin/python3.7