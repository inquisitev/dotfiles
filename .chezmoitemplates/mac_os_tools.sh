# wezterm
install_wezterm() {
   curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
   echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
   sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
}

init_wezterm() {
   :
}

# lazygit
install_lazygit() {
   LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
   curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_arm64.tar.gz"
   tar xf lazygit.tar.gz lazygit
   sudo install lazygit -D -t /usr/local/bin/
}

init_lazygit() {
   export PATH="~/bin:$PATH"
}

# nvim
install_nvim() {
   curl -LO https://github.com/neovim/neovim/releases/download/v0.11.0/nvim-macos-arm64.tar.gz
   sudo rm -rf /opt/nvim
   sudo tar -C ~/bin -xzf nvim-macos-arm64.tar.gz
   rm nvim-macos-arm64.tar.gz

}
init_nvim() {
   export PATH="$HOME/bin/nvim-linux-x86_64/bin:$PATH"
}

# yazi
install_yazi() {
   git clone https://github.com/sxyazi/yazi.git
   (
      cd yazi
      ~/.cargo/bin/cargo build --release --locked
      mv target/release/yazi target/release/ya ~/bin
   )
}
init_yazi() {
   export PATH="~/bin:$PATH"
}

# gh
install_gh() {
   sudo apt install -y gh
}

init_gh() {
   :
}

# rust
install_rust() {
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path --default-toolchain stable --profile minimal --component cargo
   export PATH="$HOME/.cargo/bin:$PATH"
   rustup update
}
init_rust() {
   export PATH="$HOME/.cargo/bin:$PATH"
}
# nvm
install_nvm() {
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
}
init_nvm() {
   export NVM_DIR="$HOME/.nvm"
   [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
   [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
}

init_nvm() {
   export NVM_DIR="$HOME/.nvm"
   [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
   [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
}

install_node() {
   init_nvm
   nvm install node
}

init_node() {
   :
}

install_fish() {

   (
      git clone https://github.com/powerline/fonts.git --depth=1
      cd fonts
      ./install.sh
      cd ..
      rm -rf fonts
   )

   sudo apt-add-repository ppa:fish-shell/release-4
   sudo apt update
   sudo apt install fish
   fish -c "fisher install jorgebucaran/nvm.fish"
   curl -L https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
   fish -c "omf install bobthefish"
}

init_fish() {
   :
}
