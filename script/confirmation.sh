#! /bin/bash

function seek_confirmation() {
    # Asks questions of a user and then does something with the answer.
    # y/n are the only possible answers.
    #
    # USAGE:
    # seek_confirmation "Ask a question"
    # if is_confirmed; then
    #   some action
    # else
    #   some other action
    # fi
    #
    # Credit: https://github.com/kevva/dotfiles
    # ------------------------------------------------------

    input "$@"
    read -p " (y/n) " -n 1
    echo ""
}

function is_confirmed() {
  if [[ "${REPLY}" =~ ^[Yy]$ ]]; then
    return 0
  fi
  return 1
}

function is_not_confirmed() {
  if [[ "${REPLY}" =~ ^[Nn]$ ]]; then
    return 0
  fi
  return 1
}
