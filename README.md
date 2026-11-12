# dotfiles

## 🚀 One-line Installation

Simply clone and run the install script:

```bash
git clone https://github.com/yarikama/dotfiles.git ~/dotfiles && cd ~/dotfiles && ./install.sh
```

It installs the tools with Homebrew (macOS) or apt (Linux), moves any existing
config files aside as `*.pre-dotfiles`, and links each package into `$HOME`
with GNU Stow.

## Packages

| Package | Links to | What it is |
|---|---|---|
| `zsh` | `~/.zshrc`, `~/.zshenv`, `~/.p10k.zsh` | zinit, Powerlevel10k, fzf-tab, zoxide |
| `tmux` | `~/.tmux.conf` | `C-a` prefix, status line on top |
| `nvim` | `~/.config/nvim` | LazyVim |
| `ghostty` | `~/.config/ghostty/config` | Terminal: font, theme, transparency |
| `lazygit` | `~/.config/lazygit/config.yml` | Git TUI colours, delta as its diff pager |
| `git` | `~/.config/git/config` | delta for `git diff` / `show` / `log -p`; identity stays in `~/.gitconfig` |

## Theme: Monokai Pro everywhere

| Where | How it matches |
|---|---|
| Ghostty | `theme = Monokai Pro`, background opacity 0.88 with blur |
| tmux | Hand-written status line in Monokai Pro hex colours, transparent background |
| Neovim | `monokai-pro.nvim` with a transparent background, so Ghostty's opacity still shows |
| Prompt (p10k) | Colours use ANSI palette slots, so they follow the terminal theme |
| Completion / `ls` | `vivid generate ansi` for `LS_COLORS`, which also uses palette slots |
| fzf / fzf-tab | `FZF_DEFAULT_OPTS` colours |
| lazygit | Theme colours in `config.yml` |
| delta (git diffs) | Monokai Extended syntax theme, Monokai Pro hex colours for files, hunks and line numbers |

To change theme later, change Ghostty's `theme`. The prompt and completion colours
follow it automatically; tmux, Neovim, fzf and lazygit carry their own colours.

## Platforms

- **macOS**: everything, including Ghostty and the JetBrains Mono Nerd Font.
- **Linux**: the same shell, tmux, Neovim and lazygit setup. Ghostty and fonts
  are not installed, because on a server the terminal runs on the machine you
  connect from. Options that only exist on macOS (titlebar style, P3 colour,
  blur) are ignored by Ghostty on Linux.
- **SSH**: Ghostty installs its terminfo on remote hosts on first connect, so
  tmux and Neovim work over SSH. The tmux battery segment only appears on
  machines that have a battery.

## After installing

1. Restart the terminal, or run `source ~/.zshrc`.
2. Open tmux and press `Prefix + I` to install the tmux plugins.
3. Open nvim; LazyVim installs the rest on first start.
4. Quit Ghostty fully (`Cmd + Q`) and reopen it so transparency and the titlebar
   style take effect.
