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
  brew install stow nvim tmux ripgrep fd fzf node python gcc zsh zoxide
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  echo -e "${GREEN}Detected Linux. Installing dependencies with apt...${NC}"
  sudo apt update
  sudo apt install -y stow neovim tmux ripgrep fd-find fzf nodejs npm \
    python3-pip build-essential zsh zoxide curl git unzip

  # Debian/Ubuntu ship fd as fdfind to avoid a name clash. Expose it as fd so
  # the nvim config and anything else expecting the upstream name works.
  if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
  fi
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
  chsh -s "$(which zsh)" || echo "chsh failed; run it yourself or use: sudo chsh -s $(which zsh) $USER"
fi

echo -e "${BLUE}==================================================${NC}"
echo -e "${GREEN}Installation Complete!${NC}"
echo -e "${BLUE}Final Steps:${NC}"
echo -e "1. Restart your terminal or run: ${GREEN}source ~/.zshrc${NC}"
echo -e "2. Open tmux and press ${GREEN}Prefix + I${NC} to install tmux plugins."
echo -e "3. Open nvim, LazyVim will handle the rest automatically."
echo -e "${BLUE}==================================================${NC}"
