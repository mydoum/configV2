My Dotfiles
===========

Everything I need to get setup on a new machine. Currently only working with

* OSX

## What's here

* setup.sh:
    * Script to be downloaded, it will install git, clone the repo and
      launch the proper script depending on the distribution
* **script/setup/** - Scripts that configure new computers (currently only osx) from scratch. These scripts perform such tasks as:
    * osx.sh:
        * Insalling [Homebrew][1] & associated packages
        * Installing mac applications using [Homebrew Cask][2]
        * Installing Apple store applications with [Mas][3]
        * Generate a SSH key and send it to github and bitbucket

## Installation

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

## Software

Softwares that I need for my day-to-day programming work.

### Tools

* Git ([https://git-scm.com/](https://git-scm.com/))
* Vim ([http://www.vim.org/](http://www.vim.org/))

[1]: http://brew.sh
[2]: http://caskroom.io
[3]: https://github.com/mas-cli/mas

### Resources

I'm inspired by these dotfiles repos

* [NathanielLandau](https://github.com/natelandau/shell-scripts)
* [Cowboy](https://github.com/cowboy/dotfiles)
