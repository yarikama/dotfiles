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
  brew install stow nvim tmux ripgrep fd fzf node python gcc zsh zoxide lazygit vivid git-delta
  brew install --cask font-jetbrains-mono-nerd-font
  # Skip the cask when Ghostty was installed some other way (e.g. the .dmg).
  [ -d /Applications/Ghostty.app ] || brew install --cask ghostty
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  echo -e "${GREEN}Detected Linux. Installing dependencies with apt...${NC}"
  sudo apt update
  sudo apt install -y stow neovim tmux ripgrep fd-find fzf nodejs npm \
    python3-pip build-essential zsh zoxide curl git unzip
  # Not packaged on every release. .zshrc skips vivid and git falls back to
  # less when delta is missing.
  for pkg in vivid lazygit git-delta; do
    sudo apt install -y "$pkg" || echo "$pkg is not packaged here; skipping"
  done
  # Ghostty and fonts are left out on purpose: on a server the terminal (and
  # its font) runs on the machine you SSH in from. For a Linux desktop, see
  # https://ghostty.org/docs/install/binary

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
# Work from wherever this repo was cloned, not a fixed ~/dotfiles, and link
# into $HOME explicitly: stow's default target is the parent directory,
# which is only $HOME when the repo sits directly in it.
cd "$(dirname "$0")" || exit 1

# Stow refuses to replace real files. Move any that are in the way aside
# rather than deleting them; existing symlinks are left for stow to handle.
for f in .zshrc .zshenv .tmux.conf .p10k.zsh .config/ghostty/config .config/lazygit/config.yml .config/git/config; do
  if [ -e "$HOME/$f" ] && [ ! -L "$HOME/$f" ]; then
    mv "$HOME/$f" "$HOME/$f.pre-dotfiles"
    echo "Moved existing ~/$f to ~/$f.pre-dotfiles"
  fi
done

# On macOS Ghostty also reads a config from Application Support and layers it
# on top of ~/.config/ghostty/config, so move that one aside too.
GHOSTTY_MAC_CONFIG="$HOME/Library/Application Support/com.mitchellh.ghostty/config"
if [ -f "$GHOSTTY_MAC_CONFIG" ] && [ ! -L "$GHOSTTY_MAC_CONFIG" ]; then
  mv "$GHOSTTY_MAC_CONFIG" "$GHOSTTY_MAC_CONFIG.pre-dotfiles"
  echo "Moved Ghostty's Application Support config to config.pre-dotfiles"
fi

for pkg in nvim tmux zsh ghostty lazygit git; do
  stow -t "$HOME" "$pkg"
done

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
