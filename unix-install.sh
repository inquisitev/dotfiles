sudo snap install bw
brew install gnupg
bw login
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply https://github.com/inquisitev/dotfiles.git
