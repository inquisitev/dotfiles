#!/bin/bash

if [[ "$(hostname -f)" != *jdnet.deere.com* ]]; then
   (
      cd ~/.local/share/chezmoi
      git config --local submodule.private-dotfiles.update none
   )
fi

