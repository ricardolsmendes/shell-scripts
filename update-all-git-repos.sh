#!/bin/bash

for d in $(find . -mindepth 1 -maxdepth 1 -type d)
do
  cd $d
  echo -e "\n========================================"
  echo Processing $d
  
  echo -e "\n1. Updating current branch..."
  git pull

  echo -e "\n2. Updating objects and refs from origin..."
  git fetch --prune
  
  echo -e "\n3. All branches:"
  git branch --all

  echo -e "\nDone!"
  cd ..
done
