#!/usr/bin/env bash

set -eo pipefail


subfolders=$(find . -mindepth 1 -maxdepth 1 -type d)

for folder in $subfolders
do
  cd $folder
  echo -e "\n========================================"
  echo "Processing $folder"

  echo -e "\n1. Updating current branch..."
  git pull

  echo -e "\n2. Updating objects and refs from origin..."
  git fetch --prune

  echo -e "\n3. All branches:"
  git branch --all

  echo -e "\nDone!"
  cd ..
done
