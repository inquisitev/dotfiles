#!/bin/bash

if [[ "$(hostname -f)" == *jdnet.deere.com* ]]; then
   (
      cd ~/.local/share/chezmoi
      git submodule add --force git@github.deere.com:l6ti0g0/private-dotfiles.git private-dotfiles
   )
fi

