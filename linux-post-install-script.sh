#!/usr/bin/env bash

# set -e

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
    wget https://raw.githubusercontent.com/markbroeders/dotfiles/main/.zshrc -O $HOME/.zshrc && source $HOME/.zshrc

    # TODO Install Plugins
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
}

# TODO Create dynamic variable for helix download
setup_helix() {
    wget https://github.com/helix-editor/helix/releases/download/25.07.1/helix-25.07.1-source.tar.xz
    mkdir $HOME/Downloads/helix && tar -xvf helix-25.07.1-source.tar.xz -C $HOME/Downloads/helix
    cp -r $HOME/Downloads/helix/runtime $HOME/.config/helix/
    rm -rf helix* # Clean up

    # DOES NOT WORK WITH NEW UBUNTU VERSIONS - MOVED TO SNAP INSTEAD
    # sudo add-apt-repository ppa:maveonair/helix-editor
    # sudo apt update && sudo apt install helix -y
}

get_config_files() {
    git clone https://github.com/markbroeders/dotfiles ~/.dotfiles  

    config_files=("foot" "helix" "kanshi" "mako" "sway" "wlogout" "wofi")
    for config in "${config_files[@]}"; do
        cp -rv $HOME/.dotfiles/config/"$config" $HOME/.config/
    done
}

enable_systemd_services() {
    mkdir -p $HOME/.config/systemd/user
    cp -rv $HOME/.dotfiles/config/systemd/user/kanshi.service $HOME/.config/systemd/user/
    cp -rv $HOME/.dotfiles/config/systemd/user/sway-session.target $HOME/.config/systemd/user/

    # ENABLING IS NOT NECESSARY, IS IN SWAY CONFIG FILE
    # systemctl --user enable --now kanshi.service
}

# TODO WORKS! But add more packages
install_basic_packages() {
    dependencies=("git" "curl" "build-essential" "sway" "swayidle" "swaylock" "ddcutil" "wofi" "kanshi" "pulseaudio-utils" "clipman" "nodejs" "npm" "ubuntu-restricted-extras" "python3-pylsp" "zsh" "syncthing")
    
    # Install missing dependencies
    for dependency in "${dependencies[@]}"; do
        if ! command_exists "$dependency"; then
            # if ! package_installed "$dependency"; then
                sudo apt install "$dependency" -y
            # fi
        fi
    done
}

install_snap_packages() {
    packages=("libreoffice" "obsidian" "spotify" "marksman" "helix")
    for package in "${packages[@]}"; do
        if ! command_exists "$package"; then
            sudo snap install "$package" --classic
        fi
    done
}

# TODO
miscellaneous() {
    # Set a nice looking wallpaper
    mkdir -p $HOME/Afbeeldingen/Wallpapers
    cp $HOME/.dotfiles/config/backgrounds/Cosmic\ Beta\ NASA.jpeg $HOME/Afbeeldingen/Wallpapers/

    # Development Tools
    sudo npm install -g prettier

    # Install some fonts
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip    
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/CascadiaCode.zip
    mkdir -p $HOME/.local/share/fonts/CaskaydiaCove/
    mkdir -p $HOME/.local/share/fonts/FiraCode/
    unzip $HOME/Downloads/FiraCode.zip -d $HOME/.local/share/fonts/FiraCode
    unzip $HOME/Downloads/CascadiaCode.zip -d $HOME/.local/share/fonts/CaskaydiaCove
    fc-cache -fv
    rm $HOME/Downloads/*.zip

    # Autotiling Sway
    pip install --break-system-packages i3ipc
    mkdir -p $HOME/.local/bin
    wget https://raw.githubusercontent.com/nwg-piotr/autotiling/master/autotiling/main.py -O $HOME/.local/bin/autotiling && chmod +x $HOME/.local/bin/autotiling

    sudo apt autoremove -y && sudo apt clean -y
}

sudo apt update && sudo apt dist-upgrade -y

# # Install all basic and necessary packages
install_basic_packages
# # Get my dotfiles repository and copy the needed config directories to my .config folder
get_config_files
# # Enable Sway and Kanshi services
enable_systemd_services
# # Install useful packages
install_snap_packages
# # Helix as text editor
setup_helix
# # Setup ZSH as my default shell
setup_oh_my_zsh
# # Various things
miscellaneous

# TODO
# sudo systemctl enable --now syncthing@mark.service
# Configure Syncthing: backup ~/.local/state/syncthing/config.xml?
# Set up my password manager
# Copy .ssh folder from my personal Drive

