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
elif [ "$distro" == "debian" -o "$distro" == "ubuntu"]; then
  echo "Updating the system"
  sleep 1
  sudo apt update && sudo apt upgrade -y
elif [ "$distro" == "fedora" ]; then
  echo "Updating the system"
  sleep 1
  sudo dnf update -y
else
  echo "Unsupported distro"
  exit 1
fi

# create an array of package names
packages_basic=(neovim tmux zsh curl stow rust neofetch curl btop kitty alacritty)
packages_hypr=(neovim tmux zsh curl stow rust neofetch curl btop alacritty kitty hypr rofi waybar)

echo "Are you using Hyperland desktop environment? (Y/n)"
read -r response

# install the necessary packages based on the user's distro
if [ "$distro" == "arch" ]; then
  echo "Installing the necessary packages for the development environment"
  sleep 1
  if [ "$response" == "n" -o "$response" == "N" ]; then
    sudo pacman -S "${packages_basic[@]}" --noconfirm
  else
    sudo pacman -S "${packages_hypr[@]}" --noconfirm
  fi
elif [ "$distro" == "debian" -o "$distro" == "ubuntu" ]; then
  echo "Installing the necessary packages for the development environment"
  sleep 1
  if [ "$response" == "n" -o "$response" == "N" ]; then
    sudo apt install "${packages_basic[@]}" -y
  else
    sudo apt install "${packages_hypr[@]}" -y
  fi
elif [ "$distro" == "fedora" ]; then
  echo "Installing the necessary packages for the development environment"
  sleep 1
  if [ "$response" == "n" -o "$response" == "N" ]; then
    sudo dnf install "${packages_basic[@]}" -y
  else
    sudo dnf install "${packages_hypr[@]}" -y
  fi
else
  echo "Unsupported distro"
  exit 1
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

# remove the symlink to the installation file
cd "$HOME"
rm install.sh

# check if bash is the default shell and change it to zsh
if [ "$SHELL" == "/bin/bash" ]; then

  # ask the user if they want to change the default shell to zsh
  echo "Do you want to change the default shell to zsh and install oh-my-zsh? (Y/n)"
  read -r response2
  if [ "$response2" == "n" -o "$response2" == "N" ]; then
    echo "My job here is done!"
    exit 1
  fi
  echo "Changing the default shell to zsh"
  chsh -s /bin/zsh
  # install oh-my-zsh
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

fi

echo "For the shell changes to take effect, you need to log out and log back in"
echo "My job here is done!"

# TODO add installation of the necessary fonts
# TODO customize package installations for different distros
# TODO add git submodules 
# TODO add colors to the output