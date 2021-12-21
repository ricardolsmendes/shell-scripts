# shell-scripts

A collection of Shell Scripts intended to automate regular tasks.

## For Developers

### git-update-nested-repos.sh

Update all Git local repositories nested to a given directory by running
`git pull` and `git fetch --prune` for each of them.

### maven-prepare-release.sh

Set up the version of a [Maven](https://maven.apache.org/)-based project by
updating the parent and child `pom.xml` files, commit the changes to Git and
create a tag as well.

### maven-set-up-version.sh

Set up the version of a [Maven](https://maven.apache.org/)-based project by
updating the parent and child `pom.xml` files, and commit the changes to Git.

## How to contribute

Please make sure to take a moment and read the [Code of
Conduct](https://github.com/ricardolsmendes/shell-scripts/blob/master/.github/CODE_OF_CONDUCT.md).

### Report issues

Please report bugs and suggest features via the [GitHub
Issues](https://github.com/ricardolsmendes/shell-scripts/issues).

Before opening an issue, search the tracker for possible duplicates. If you find
a duplicate, please add a comment saying that you encountered the problem as
well.

### Contribute code

Please make sure to read the [Contributing
Guide](https://github.com/ricardolsmendes/shell-scripts/blob/master/.github/CONTRIBUTING.md)
before making a pull request.
