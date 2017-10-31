#!/bin/sh

if [ $# -lt 2 ]; then
  echo usage $0 folder git-link
  exit 1
fi

rm -rf $1
mkdir $1
cd $1
git init
git remote add origin $2
git pull origin master
git branch --set-upstream-to=origin/master master

