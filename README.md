# shell-scripts

A collection of general-purpose Shell Scripts intended to automate
regular developer's tasks.

## git-update-nested-repos.sh

Update all Git local repositories nested to a given directory by running
`git pull` and `git fetch --prune` for each of them.

## maven-prepare-release.sh

Set up the version of a [Maven](https://maven.apache.org/)-based project by
updating the parent and child `pom.xml` files, commit the changes to Git and
create a tag as well.

## maven-set-up-version.sh

Set up the version of a [Maven](https://maven.apache.org/)-based project by
updating the parent and child `pom.xml` files, and commit the changes to Git.
