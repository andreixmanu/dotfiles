#!/bin/bash

distro=""
distro_name=""
username=$(whoami)

echo "
                 _          _                                  
                | |        (_)                                 
  __ _ _ __   __| |_ __ ___ ___  ___ __ ___   __ _ _ __  _   _ 
 / _\` | '_ \ / _\` | '__/ _ \ \ \/ / '_ \` _ \ / _\` | '_ \| | | |
| (_| | | | | (_| | | |  __/ |>  <| | | | | | (_| | | | | |_| |
 \__,_|_| |_|\__,_|_|  \___|_/_/\_\_| |_| |_|\__,_|_| |_|\__,_|
                                                               
"

echo "
                 _       _    __ _ _           
                | |     | |  / _(_) |          
              __| | ___ | |_| |_ _| | ___  ___ 
             / _\` |/ _ \| __|  _| | |/ _ \/ __|
            | (_| | (_) | |_| | | | |  __/\__ \\
             \__,_|\___/ \__|_| |_|_|\___||___/

"

sleep 1

echo "Hi $username, this script will install the necessary packages for the development environment"
echo "Are you sure you want to continue? (Y/n)"
read -r response
if [ "$response" == "n" -o "$response" == "N" ]; then
  echo "Exiting..."
  exit 1
fi

# Get the distro name
if [ -f /etc/os-release ]; then
  # Read the contents of os-release into a variable
  source /etc/os-release

  # Print the PRETTY_NAME variable (more user-friendly name)
  distro="$ID"
  distro_name="$PRETTY_NAME"
  # echo "Distro: $distro"
fi

#  update the system
if [ "$distro" == "arch" ]; then
  echo "Updating the system"
  sleep 1
  sudo pacman -Syu --noconfirm
fi
else if [ "$distro" == "debian" -o "$distro" == "ubuntu"]; then
  echo "Updating the system"
  sleep 1
  sudo apt update && sudo apt upgrade -y
fi
else if [ "$distro" == "fedora" ]; then
  echo "Updating the system"
  sleep 1
  sudo dnf update -y
fi

# create an array of package names
packages_basic=(neovim tmux zsh curl stow rust neofetch btop kitty alacritty)
packages_hypr=(neovim tmux zsh curl stow rust neofetch btop alacritty kitty hypr rofi waybar)

echo "Are you using Hyperland desktop environment? (Y/n)"
read -r response

if [ "$response" == "n" -o "$response" == "N" ]; then

  echo "Installing basic packages for $distro_name"
  packages=("${packages_basic[@]}")

  sleep 1 
  
  sudo pacman -S --noconfirm --needed "${packages[@]}"

else

  echo "Installing packages for Hyperland"
  packages=("${packages_hypr[@]}")
  sleep 1
  sudo pacman -S --noconfirm --needed "${packages[@]}"

fi

# create a backup of the existing dotfiles in the .config directory
echo "Creating a backup of the existing dotfiles of the .config folder"
if [ -d "$HOME/.config" ]; then
  mv "$HOME/.config" "$HOME/.config.bak"
  mkdir "$HOME/.config"
fi
echo "Backup created -> $HOME/.config.bak"
echo "If you have any important files in the .config folder, please move them to the new .config directory"

sleep 1
# if the user is not in hyperland, remove some folders from the dotfiles directory
if [ "$response" == "n" -o "$response" == "N" ]; then
  echo "As you are not using Hyperland, removing useless folders from the dotfiles directory"
  rm -rf "$HOME/dotfiles/hypr"
  rm -rf "$HOME/dotfiles/rofi"
  rm -rf "$HOME/dotfiles/waybar"
  rm -rf "$HOME/dotfiles/waybar-bak"
fi

echo ""

# create symlinks between the dotfiles and the .config directory
cd "$HOME/dotfiles"
stow --adopt .

echo "Created symlinks between the dotfiles and the .config directory"
echo "Every time you make changes to the dotfiles, you can run the 'stow --adopt .' command in the dotfiles directory to update the symlinks"
