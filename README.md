Development Environment Configuration with Ansible
==================================================
# Run it
```
wget -qO- https://raw.github.com/pbassiner/dev-env/master/bootstrap.sh | bash
```
# Disclaimer
This is just for personal convenience. It's not intended to be highly configurable and I'm most likely not following Ansible's conventions and best practices.
# Content (specific for Ubuntu 16.04)
Note: if no version is specified it means the latest will be installed
## Dev Tools
* vim
* zsh
* oh-my-zsh
* terminator
* git
* hub (2.2.3)
* keepassx

## Editors & IDEs
* Sublime Text 3 (build 3114)
* Atom
* IntelliJ IDEA (Community 2016.1.2b)
* MySQL Workbench (6.3.6 for Ubuntu 15.10)

## Utilities
* Google Chrome
* Dropbox

## Development environments
* Oracle Java 7
* Oracle Java 8
* sdkman, which is used to install:
    * sbt (latest)
    * maven (latest)
* docker
* docker-compose (1.7.1)

## Custom configuration
* zsh
    * Set as default shell
    * autocompletion for:
        * hub
        * docker-compose
* Symlinks
    * oh-my-zsh custom theme
    * .zshrc
    * .gitconfig
    * .aliases
    * terminator custom config
    * guake autostart