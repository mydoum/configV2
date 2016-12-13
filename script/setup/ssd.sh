#! /bin/bash

notice "Making the OS a better life for SSD's"

# Turn off local Time Machine snapshots [laptops only]
sudo tmutil disablelocal

# Turn off hibernation [laptops only]
sudo pmset -a hibernatemode 0

if [[ -f /var/vim/sleepimage ]]; then
    rm /var/vm/sleepimage
fi

