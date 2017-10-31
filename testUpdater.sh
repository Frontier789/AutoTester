#!/bin/sh

rm -rf flib11
cp -r bkup flib11
./updateLib.sh flib11 https://github.com/Frontier789/Flib.git src
