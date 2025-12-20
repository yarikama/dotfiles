#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Starting Dotfiles Installation...${NC}"

if [[ "$OSTYPE" == "darwin"* ]]; then
  echo -e "${GREEN}Detected macOS. Installing dependencies with Homebrew...${NC}"
  if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  brew install stow nvim tmux ripgrep fd fzf node python gcc zsh
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  echo -e "${GREEN}Detected Linux. Installing dependencies with apt...${NC}"
  sudo apt update
  sudo apt install -y stow neovim tmux ripgrep fd-find fzf nodejs npm python3-pip build-essential zsh
fi

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  echo -e "${GREEN}Installing Tmux Plugin Manager...${NC}"
  mkdir -p ~/.tmux/plugins
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
  echo -e "${BLUE}TPM already installed.${NC}"
fi

echo -e "${GREEN}Linking configurations with GNU Stow...${NC}"
cd ~/dotfiles || {
  echo "Error: ~/dotfiles directory not found"
  exit 1
}
rm -f ~/.zshrc
rm -f ~/.tmux.conf

stow nvim
stow tmux
stow zsh

if [ "$SHELL" != "$(which zsh)" ]; then
  echo -e "${GREEN}Changing default shell to zsh...${NC}"
  chsh -s "$(which zsh)"
fi

echo -e "${BLUE}==================================================${NC}"
echo -e "${GREEN}Installation Complete!${NC}"
echo -e "${BLUE}Final Steps:${NC}"
echo -e "1. Restart your terminal or run: ${GREEN}source ~/.zshrc${NC}"
echo -e "2. Open tmux and press ${GREEN}Prefix + I${NC} to install tmux plugins."
echo -e "3. Open nvim, LazyVim will handle the rest automatically."
echo -e "${BLUE}==================================================${NC}"
