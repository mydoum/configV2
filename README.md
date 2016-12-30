My Dotfiles
===========

Everything I need to get setup on a new machine. Currently only working with

* OSX


# Installation

**Warning** : Be sure to backup all you dotfiles before launching this script

### With git

```sh
$ git clone https://github.com/mydoum/dotfiles.git ~/dotfiles
$ cd ~/dotfiles
$ chmod +x setup.sh
$ ./setup.sh
```
### Remotely install using curl

```sh
curl -s https://raw.githubusercontent.com/mydoum/dotfiles/master/setup.sh | bash 2>&1 | tee ~/setup.log
```

# What's here

** setup.sh **

Script to be downloaded, it will install git, clone the repository and
launch the proper script depending on the distribution

## OSX Configuration

**script/setup/osx_defaults.sh**

* Set a faster keyboard repeat rate
* Disable press-and-hold for keys in favor of key repeat
* Require password immediately after sleep or screen saver
* Disable the warning when changing file extensions
* Allow text-selection in Quick Look
* Disable the crash reporter
* Disable the “Are you sure you want to open this application?” dialog
* Show hidden files in Finder
* Show path on title bar

## OSX programs installation

** script/setup/osx.sh **

* Insalling [Homebrew][1] & associated packages
* Installing mac applications using [Homebrew Cask][2]
* Installing Apple store applications with [Mas][3]
* Generate a SSH key and send it to github and bitbucket

## Softwares configuration

* Bash
* Vim
* Iterm
* Git

[1]: http://brew.sh
[2]: http://caskroom.io
[3]: https://github.com/mas-cli/mas

# Resources

I'm inspired by these dotfiles repos

* [NathanielLandau](https://github.com/natelandau/shell-scripts)
* [Cowboy](https://github.com/cowboy/dotfiles)
