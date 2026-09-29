
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

### Plugins
# powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k
# Big 3
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light Aloxaf/fzf-tab

# Load zsh-completions
autoload -U compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space

# For duplicates
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# OMZP Plugins
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::extract
zinit snippet OMZP::aws
zinit snippet OMZP::command-not-found

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

# ls: BSD (macOS) and GNU (Linux) spell colour differently
if [[ "$OSTYPE" == darwin* ]]; then
  alias ls='ls -G'
  _LS_PREVIEW='ls -G $realpath'
else
  alias ls='ls --color=auto'
  _LS_PREVIEW='ls --color=auto $realpath'
fi
zstyle ':fzf-tab:complete:cd:*' fzf-preview "$_LS_PREVIEW"
zstyle ':fzf-tab:__zoxide_z:*' fzf-preview "$_LS_PREVIEW"

# Aliases
alias e='exit'
alias cl='clear'

export PATH="$HOME/.local/bin:$PATH"

# macOS only: Google Cloud SDK installed via Homebrew
if [[ "$OSTYPE" == darwin* ]]; then
  export CLOUDSDK_PYTHON=/opt/homebrew/opt/python@3.12/bin/python3.12
  export PATH="/opt/homebrew/share/google-cloud-sdk/bin:$PATH"
  [[ -f /opt/homebrew/share/google-cloud-sdk/path.zsh.inc ]] && \
    source /opt/homebrew/share/google-cloud-sdk/path.zsh.inc
  [[ -f /opt/homebrew/share/google-cloud-sdk/completion.zsh.inc ]] && \
    source /opt/homebrew/share/google-cloud-sdk/completion.zsh.inc
fi

# Shell integrations. zoxide asks to be initialised last, so keep it at the
# bottom of this file.
command -v fzf >/dev/null && eval "$(fzf --zsh)"

# See .zshenv for why zoxide's doctor check is off inside Claude Code.
command -v zoxide >/dev/null && eval "$(zoxide init --cmd cd zsh)"
