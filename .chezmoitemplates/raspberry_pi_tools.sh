# wezterm
install_wezterm(){
    curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
    echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
    sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
}

# lazygit
install_lazygit(){
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_arm_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit -D -t /usr/local/bin/
}

# nvim
install_nvim(){
    git clone https://github.com/neovim/neovim.git
    cd neovim
    git checkout v-1.11.0
    sudo apt install -y gettext
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
}

# yazi
install_yazi(){
    git clone https://github.com/sxyazi/yazi.git
    (
        cd yazi
        ~/.cargo/bin/cargo build --release --locked
        mv target/release/yazi target/release/ya ~/bin
    )
}

# gh
install_gh(){
    sudo apt install -y gh
}

# rust
install_rust(){
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path --default-toolchain stable --profile minimal --component cargo
    export PATH="$HOME/.cargo/bin:$PATH"
    rustup update
}

# nvm
install_nvm(){
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
}

init_nvm(){
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
}

install_node(){
    nvm install node
}