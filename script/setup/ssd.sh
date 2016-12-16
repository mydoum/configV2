#! /bin/bash

notice "Making the OS a better life for SSD's"

seek_confirmation "Do you have a SSD ?"

if is_confirmed; then
    # Turn off local Time Machine snapshots [laptops only]
    sudo tmutil disablelocal

    # Turn off hibernation [laptops only]
    sudo pmset -a hibernatemode 0

    if [[ -f /var/vim/sleepimage ]]; then
        rm /var/vm/sleepimage
    fi
    if ! [[ -f /Library/LaunchDaemons/com.nullvision.noatime.plist ]]; then
	    # Disable records last access time for every file
        echo '<?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
          <dict>
            <key>Label</key>
            <string>com.nullvision.noatime</string>
            <key>ProgramArguments</key>
            <array>
              <string>mount</string>
              <string>-vuwo</string>
              <string>noatime</string>
              <string>/</string>
            </array>
            <key>RunAtLoad</key>
            <true/>
          </dict>
        </plist>' | sudo tee /Library/LaunchDaemons/com.nullvision.noatime.plist
        sudo chown root:wheel /Library/LaunchDaemons/com.nullvision.noatime.plist
    fi
fi
