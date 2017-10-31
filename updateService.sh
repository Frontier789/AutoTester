#!/bin/sh

sleep 10

while true; do
  git pull origin master
  ./updateAllLibs.sh
  sleep 30
done

