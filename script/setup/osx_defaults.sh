#! /bin/bash
# ============================================================================
# osx_defaults.sh
# Configure the OSX settings
# ============================================================================

notice "Configuring the OSX default settings"

# Close any open System Preferences panes, to prevent them from overriding
# settings were about to change
osascript -e 'tell application "System Preferences" to quit'

# ========================
# Interfaces
# ========================

# Set a faster keyboard repeat rate. (recommanded: 3)
defaults write NSGlobalDomain KeyRepeat -int 1

# Disable press-and-hold for keys in favor of key repeat.
defaults write -g ApplePressAndHoldEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Disable fn states keys
defaults write -g com.apple.keyboard.fnState -bool true

# ========================
# Login
# ========================

# Write a login message
sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText -string 'Discipline is the key'
# sudo defaults delete /Library/Preferences/com.apple.loginwindow LoginwindowText

# ========================
# Screen
# ========================

# Require password immediately after sleep or screen saver.
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Set highlight color to red
defaults write NSGlobalDomain AppleHighlightColor -string "1.000000 0.733333 0.721569"

# Indicate Hidden App Icons on Dock
defaults write com.apple.dock showhidden -bool TRUE; killall Dock

# ========================
# Finder
# ========================

# Disable the warning when changing file extensions
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Allow text-selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# Disable the crash reporter
defaults write com.apple.CrashReporter DialogType -string "none"

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles YES

# Show path on title bar
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Keep folders on top when sorting by name (Sierra only)
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Set sidebar icon size to medium
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Avoid creating .DS_Store files on USB volumes
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# ========================
# Security
# ========================

# Enable Secure Keyboard Entry in Terminal.app
# See: https://security.stackexchange.com/a/47786/8918
defaults write com.apple.terminal SecureKeyboardEntry -bool true

# Enable crash reporting as notifications
defaults write com.apple.CrashReporter UseUNC 1

success "Done configuring the OSX default settings"
