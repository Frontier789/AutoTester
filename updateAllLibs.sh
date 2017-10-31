#!/bin/bash

folders=("flib11")
gits=("https://github.com/Frontier789/Flib.git")
makefs=("src")

for (( i=0; i<${#folders[@]}; i++ )); do
  ./updateLib.sh ${folders[$i]} ${gits[$i]} ${makefs[$i]}
done
