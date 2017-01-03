#! /bin/bash
# ============================================================================
# osx_defaults.sh
# Configure the OSX settings
# ============================================================================

notice "Configuring the OSX default settings"
# ========================
# Interfaces
# ========================

# Set a faster keyboard repeat rate.
defaults write -g KeyRepeat -int 3

# Disable press-and-hold for keys in favor of key repeat.
defaults write -g ApplePressAndHoldEnabled -bool false

# ========================
# Screen
# ========================

# Require password immediately after sleep or screen saver.
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Set highlight color to red
defaults write NSGlobalDomain AppleHighlightColor -string "1.000000 0.733333 0.721569"

# Use dark menu bar and dock
defaults write NSGlobalDomain AppleInterfaceStyle Dark

# Use Appearance Graphite
defaults write NSGlobalDomain AppleAquaColorVariant 6

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

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

# ========================
# Security
# ========================

# Enable firewall. Possible values:
#   0 = off
#   1 = on for specific sevices
#   2 = on for essential services
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1

# Disable guest account login
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false

success "Done configuring the OSX default settings"
