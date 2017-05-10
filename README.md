My Dotfiles
===========

Everything I need to get setup on a new machine. Currently only working with
MacOS


# Installation

**Warning** : Be sure to backup all you dotfiles before launching this script

### With git

```sh
$ git # When calling git for the first time, macOs will ask you to install some softwares
$ export https_proxy=http://user:pw@myproxy.com:8080 # If you are under an enterprise proxy
$ git clone https://github.com/mydoum/dotfiles.git ~/dotfiles
$ cd ~/dotfiles
$ chmod +x setup.sh
$ ./setup.sh
```

# What's here

**/setup.sh**

Script to be downloaded, it will install git, clone the repository and
launch the proper script depending on the distribution

## MacOS Configuration

**/script/setup/osx_defaults.sh**

* Set a faster keyboard repeat rate
* Disable press-and-hold for keys in favor of key repeat
* Require password immediately after sleep or screen saver
* Disable the warning when changing file extensions
* Allow text-selection in Quick Look
* Disable the crash reporter
* Disable the “Are you sure you want to open this application?” dialog
* Show hidden files in Finder
* Show path on title bar
* Set highlight color to green
* Use dark menu bar and dock
* Use graphite mode
* Enable firewall
* Disable guest account login
* Disable auto-correct
* Keep folders on top when sorting by name
* Automatically open a new Finder window when a volume is mounted
* Use list view in all Finder windows by default
* Disable the warning before emptying the Trash

## MacOS programs installation

**script/setup/osx.sh**

* Insalling [Homebrew][1] & associated packages
* Installing mac applications using [Homebrew Cask][2]
* Installing Apple store applications with [Mas][3]
* Generate a SSH key and send it to github and bitbucket

## Softwares configuration

### Bash



### Vim

![vim example](/screen_vim.png)

### Iterm

* `/hushlogin` : Allows to not show the last login time at term's login
* Show Archey at term's login

### Git

It's better to put git shortcuts in `~/.gitconfig` instead of `~/.bashrc` in order to
keep parameters completion with bash_completion

**/gitconfig**

* git s = git status -s
* git ac = !git add. && git commit -am
* git rao = git remote add origin
* git cm = git commit -m
* git p = git push

[1]: http://brew.sh
[2]: http://caskroom.io
[3]: https://github.com/mas-cli/mas

# Resources

I'm inspired by these dotfiles repos

* [NathanielLandau](https://github.com/natelandau/shell-scripts)
* [Cowboy](https://github.com/cowboy/dotfiles)
* [atomantic](https://github.com/atomantic/dotfiles)
