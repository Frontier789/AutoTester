#!/bin/sh

if [ $# -lt 3 ]; then
  echo usage: $0 folder git-link make-path-in-folder
  exit
fi

if ! [ -d $1 ]; then 
  echo $1 "doeas not exist -> cleaning"
  ./regit.sh $1 $2
  changed=1
else
  
  echo testing for local branch
  cd $1
  git remote show origin origin | grep -q "local out of date"
  grepRet=$?
  cd ..

  if [ $grepRet = 1 ]; then
    echo "local branch is up to date"
    changed=0
  elif [ $grepRet = 0 ]; then
    echo "local branch is behind -> pulling n updating"
    changed=1
  else
    echo "local branch is bugous -> cleaning"
    ./regit.sh $1 $2
    changed=1
  fi

fi


if [ $changed -eq 1 ]; then
  echo testing $1

  ./compileLib.sh $1 $2 $3
fi

