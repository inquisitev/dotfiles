# wezterm
function init_wezterm
    :
end

function init_lazygit
    set -x PATH ~/bin $PATH
end

function init_nvim
    set -x PATH $HOME/neovim/build/bin $PATH
end

function init_yazi
    set -x PATH $HOME/tools/yazi/target/release $PATH
end

function init_gh
    :
end

function init_rust
    set -x PATH $HOME/.cargo/bin $PATH
end

function init_nvm
    # set -x NVM_DIR $HOME/.nvm
    # if test -s "$NVM_DIR/nvm.sh"
    #     source "$NVM_DIR/nvm.sh"
    # end
    # if test -s "$NVM_DIR/bash_completion"
    #     source "$NVM_DIR/bash_completion"
    # end
end

function init_node
    :
end

function init_fish
    :
end
