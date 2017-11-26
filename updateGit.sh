#!/bin/sh

if [ $# -eq 0 ]; then
  ok=1
else
  ok=$1
fi

rm -f result.png

if [ $ok -eq 1 ]; then
  cp passed.png result.png
else
  cp failed.png result.png
fi

dat=`date`

git add *.sh *.log result.png .gitignore
git commit -m "updated logs at ${dat}"
git push origin master

