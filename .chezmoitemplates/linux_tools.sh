# wezterm
install_wezterm() {
   curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
   echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
   sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
   sudo apt install -y wezterm
}

init_wezterm() {
   :
}

# lazygit
install_lazygit() {
   LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
   curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
   tar xf lazygit.tar.gz lazygit
   sudo install lazygit -D -t /usr/local/bin/
}
init_lazygit() {
   export PATH="~/bin:$PATH"
}

# nvim
install_nvim() {
   mkdir -p ~/tools
   sudo apt-get install -y ninja-build gettext cmake unzip curl sqlite3 libsqlite3-dev
   (
      cd ~/tools
      sudo rm -r yazi
      git clone https://github.com/neovim/neovim
      cd neovim
      git checkout bc2fe135d1
      make CMAKE_BUILD_TYPE=RelWithDebInfo
      sudo make install
   )
}

init_nvim() {
   export PATH="$HOME/tools/neovim/bin/nvim:$PATH"
}

# yazi
install_yazi() {
   (
      cd ~/tools
      sudo rm -r yazi
      git clone https://github.com/sxyazi/yazi.git
      (
         cd yazi
         ~/.cargo/bin/cargo build --release --locked
         export PATH="~/tools/yazi/target/release:$PATH"
      )

      ~/tools/yazi/target/release/ya pkg add ourongxing/fast-enter
      ~/tools/yazi/target/release/ya pkg add DreamMaoMao/easyjump
      ~/tools/yazi/target/release/ya pkg add AnirudhG07/rich-preview
      ~/tools/yazi/target/release/ya pkg add dedukun/relative-motions
   )
}
init_yazi() {
   sudo cp ~/tools/yazi/target/release/yazi /usr/bin
   sudo cp ~/tools/yazi/target/release/ya /usr/bin
   export PATH="$HOME/tools/yazi/target/release:$PATH"
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

   sudo apt-add-repository -y ppa:fish-shell/release-4
   sudo apt update
   sudo apt install -y fish
   fish -c '
      set -gx OMF_CONFIG $HOME/.config/omf
      set -gx OMF_PATH $HOME/.local/share/omf
      set -gx OMF_INSTALLER YES
      set -gx NONINTERACTIVE 1

      curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
      and fisher install jorgebucaran/fisher
      and fisher install jorgebucaran/nvm.fish

      curl -L https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | source
      '
   fish -c 'omf install bobthefish'
}

init_fish() {
   :
}
