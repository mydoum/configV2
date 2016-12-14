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

# ========================
# Finder
# ========================

# Disable the warning when changing file extensions
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Allow text-selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# Disable the crash reporter
defaults write com.apple.CrashReporter DialogType -string "none"

success "Done configuring the OSX default settings"
