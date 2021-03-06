#!/bin/sh

if [ $# -lt 3 ]; then
  echo usage: $0 folder git-link make-path-in-folder
  exit
fi

res_folder=`pwd`
root_folder=`pwd`
compilers="g++ clang++"
  
echo pulling $1
cd $1
git pull origin master
cd $root_folder
echo pull done
  
echo > $res_folder/make_${1}_clean.log

compile_ok=1

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
      
      target=$res_folder/make_${1}_test_${compiler}.log
      echo 'compile time:' > $target
      date >> $target
      echo >> $target
      make -j4 CXX=$compiler >> $target 2>&1
       
      if [ $? -eq 0 ]; then
        echo tests succeeded
      else
        echo tests failed
      fi
    fi
  else
    compile_ok=0
    echo failed miserably
  fi
done

echo done compiling, pushing to git ok=$compile_ok
cd $root_folder
./updateGit.sh $compile_ok

