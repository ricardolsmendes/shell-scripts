#!/usr/bin/env bash

set -eo pipefail

# Input args:
# - $1: the version ID, e.g.: 1.0.0 (mandatory)

# Input validation
if [[ $1 == "" ]]
then
  echo "The version ID (e.g.: 1.0.0) is mandatory"
  exit 1
fi


# Variables
versionId=$1
version="${versionId}-RELEASE"


# Maven setup
echo "[Maven] Setting $version as the new version..."
mvn versions:set -DnewVersion="$version"

echo -e '\n[Maven] Confirming the changes...'
mvn versions:commit


# Git commands
echo -e '\n[Git] Staging the changes...'
git add pom.xml **/pom.xml

echo -e '\n[Git] Committing the changes...'
git commit -m "chore: release version $versionId"

echo -e "\n[Git] Creating the $version tag..."
git tag "$version"
