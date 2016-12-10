My Dotfiles
===========

Everything I need to get setup on a new machine. Currently working with

* OSX

## What's here

* **script/setup/** - Scripts that configure new computers (currently only osx) from scratch.
  These scripts perform such tasks as:
    * osx.sh:
        * Insalling [Homebrew][1] & associated packages
        * Installing mac applications using [Homebrew Cask][2]


## Installation

#### Prerequisites

* `curl` - For the command below

#### Installation Steps
1. Run the `setup.sh`. This will install all the necessary software, setup
   commonly used directories, and install dotfiles.

```sh
curl -s https://raw.githubusercontent.com/Stratus3D/dotfiles/master/setup.sh | bash 2>&1 | tee ~/setup.log
```


[Download
plug.vim](https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim)
and put it in the "autoload" directory.

```sh
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

* Git clone
* Copy the .vimrc to ~/

```
… then run the following in Vim:
:source %
:PlugInstall
```

## Software

This is software that I need for my day-to-day programming work.

### Tools

* Git ([https://git-scm.com/](https://git-scm.com/))
* Vim ([http://www.vim.org/](http://www.vim.org/))

OSX Only

* iTerm2 [https://iterm2.com/](https://iterm2.com/)

[1]: http://brew.sh
[2]: http://caskroom.io
