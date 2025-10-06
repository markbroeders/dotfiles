#!/usr/bin/env bash

set -e

test_fn() {
    echo "TEST FUNCTION STARTED"
    if command_exists "spotify"; then
        echo "Spotify is installed"
    fi
    echo "TEST FUNCTION DONE"
}

# Check if a command is available
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

setup_oh_my_zsh() {
    # Change shell to zsh
    sudo chsh -s /usr/bin/zsh $USER
    
    # Install oh-my-zsh
    sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
    
    # TODO Overwrite the .zshrc
    wget https://raw.githubusercontent.com/FlareXes/dotfiles/main/.zshrc -O $HOME/.zshrc && source $HOME/.zshrc

    # TODO Install Plugins
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
}

setup_helix() {
    wget https://github.com/helix-editor/helix/releases/download/25.07.1/helix-25.07.1-source.tar.xz -O $HOME/Downloads/
    mkdir $HOME/Downloads/helix
    tar -xvf helix-25.07.1-source.tar.xz -C $HOME/Downloads/helix
    cp -r $HOME/Downloads/helix/runtime $HOME/.config/helix/

    sudo add-apt-repository ppa:maveonair/helix-editor
    sudo apt update && sudo apt install helix -y
}

get_config_files() {
    git clone https://github.com/mbroeders/dotfiles ~/.dotfiles  

    config_files=("foot" "helix" "kanshi" "mako" "sway" "wlogout" "wofi" "pulseaudio-utils" "clipman")
    for config in "${config_files[@]}"; do
        cp -rv $HOME/.dotfiles/config/"$config" $HOME/.config/
    done
}

enable_systemd_services() {
    mdir -p $HOME/.config/systemd/user
    cp -rv $HOME/.dotfiles/config/systemd/user/kanshi.service $HOME/.config/systemd/user/
    cp -rv $HOME/.dotfiles/config/systemd/user/sway-session.target $HOME/.config/systemd/user/

    # systemctl --user enable --now kanshi.service
}

# TODO add more packages
install_basic_packages() {
    dependencies=("git" "curl" "build-essential" "sway" "swayidle" "swaylock" "ddcutil" "wofi")
    
    # Install missing dependencies
    for dependency in "${dependencies[@]}"; do
        if ! command_exists "$dependency"; then
            if ! package_installed "$dependency"; then
                sudo apt install "$dependency" -y
            fi
        fi
    done
}

install_snap_packages() {
    packages=("libreoffice" "obsidian" "spotify" "marksman")
    for package in "${packages[@]}"; do
        if ! command_exists "$package"; then
            sudo snap install "$package" --dangerous --classic
        fi
    done
}

# TODO
miscellaneous() {
    # Set a nice looking wallpaper
    mkdir -p $HOME/Afbeeldingen/Wallpapers
    cp $HOME/.dotfiles/backgrounds/Cosmic\ Beta\ NASA.jpeg $HOME/Afbeeldingen/Wallpapers/

    # Development Tools
    sudo apt install nodejs npm -y
    sudo npm install -g prettier
    sudo apt install python3-pylsp -y

    # Install some fonts
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip -O $HOME/Downloads/
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/CascadiaCode.zip -O $HOME/Downloads/
    mkdir -p $HOME/.local/share/fonts/CaskaydiaCove/
    mkdir -p $HOME/.local/share/fonts/FiraCode/
    unzip $HOME/Downloads/FiraCode.zip -d $HOME/.local/share/fonts/FiraCode
    unzip $HOME/Downloads/CascadiaCode.zip -d $HOME/.local/share/fonts/CaskaydiaCove
    fc-cache -fv
    rm $HOME/Downloads/*.zip
       
}

# sudo apt update && sudo apt dist-upgrade -y

# # Install all basic and necessary packages
# install_basic_packages
# # Get my dotfiles repository and copy the needed config directories to my .config folder
# get_config_files
# # Enable Sway and Kanshi services
# enable_systemd_services
# # Install useful packages
# install_snap_packages
# # Helix as text editor
# setup_helix
# # Setup ZSH as my default shell
# setup_oh_my_zsh
# # Various things
# miscellaneous

# TODO
# sudo systemctl enable --now syncthing@mark.service
# Configure Syncthing: backup ~/.local/state/syncthing/config.xml?
# Set up my password manager
# Copy .ssh folder from my personal Drive

