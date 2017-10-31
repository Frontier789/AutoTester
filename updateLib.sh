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

  res_folder=`pwd`
  root_folder=`pwd`
  compilers="g++ clang++"
  
  echo pulling $1
  cd $1
  git pull origin master
  cd $root_folder
  echo pull done
  
  echo > $res_folder/make_${1}_clean.log
  
  for compiler in $compilers
  do
    echo compiling using $compiler
    cd $root_folder/$1/$3
	make clean >> $res_folder/make_${1}_clean.log 2>&1
    make -j4 CXX=$compiler > $res_folder/make_${1}_${compiler}.log 2>&1
    if [ $? -eq 0 ]; then
      echo build succeeded
	  if [ -d "../test" ]; then
        echo building tests
        cd ../test
        make clean >> $res_folder/make_${1}_clean.log 2>&1
		make -j4 CXX=$compiler > $res_folder/make_${1}_test_${compiler}.log 2>&1
	    
		if [ $? -eq 0 ]; then
          echo tests succeeded
        else
          echo tests failed
        fi
      fi
    else
      echo failed miserably
    fi
  done
fi

