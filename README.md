# andreixmanu dotfiles

## Installation guide

1. Install git on your sistem
```shell
sudo pacman -S git # for arch based
sudo apt install git # for debian based
sudo dnf install git # for fedora based 
```

2. *Inside your home folder* clone the repo
```shell
git clone https://github.com/andreixmanu/dotfiles && cd dotfiles
```
This will create a folder in your home directory called 'dotfiles'.

3. Make sure the installation script has the execution permission.
```shell
chmod +x install.sh
```
4. Execute the installation script
```shell
./install.sh
```

## General Information

### List of tools:

- [Alacritty](https://alacritty.org/) : standard terminal
- [Kitty](https://sw.kovidgoyal.net/kitty/) : hyperland terminal
- [Neovim](https://neovim.io/) : text editor (plugins included)
- [Btop](https://github.com/aristocratos/btop) : terminal based resources monitor
- [Neofetch](https://github.com/dylanaraps/neofetch) : command-line system information tool
- [Tmux](https://github.com/tmux/tmux) : terminal multiplexer

### Hyperland-only tools
These tools only work if you are using Hyperland WM. If you are not using Hyperland, the script will automatically remove these tools from the dotfiles folder. If you want to keep them, answer 'y' when prompted.

- [hypr](https://hyprland.org/) : hyperland configuration
- [waybar](https://github.com/Alexays/Waybar) : status bar for wayland DE
- [rofi](https://github.com/davatorium/rofi) : A window switcher, Application launcher and dmenu replacement.