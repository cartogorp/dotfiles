# Basic shell configuration
setopt PROMPT_SUBST
setopt PROMPT_PERCENT

# Basic history configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Basic options
setopt HIST_IGNORE_DUPS     # Don't record duplicates in history
setopt EXTENDED_HISTORY     # Record timestamp of command in HISTFILE
setopt HIST_VERIFY         # Show command with history expansion before running it

### Added by Zinit's installer
if [[ ! -f ~/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
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

# Now load the plugins (replace the current plugin section)
# Load syntax highlighting and autosuggestions first
zinit wait lucid for \
    atinit"zicompinit; zicdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
    atload"!_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions

# Load completions
zinit ice wait lucid blockf atpull'zinit creinstall -q .'
zinit load zsh-users/zsh-completions

# Load prompt system for customization after theme if needed
# autoload -Uz promptinit
# promptinit

# Oh My Posh configuration (load after prompt system)
if command -v oh-my-posh > /dev/null; then
  eval "$(oh-my-posh init zsh --config ~/.config/themes/cartogorp-custom/oh-my-posh/cartogorp-hybrid.omp.json)"  
fi

# Load vi-mode (without waiting, to ensure proper initialization)
zinit ice lucid
zinit load jeffreytse/zsh-vi-mode

# Load z jump plugin
zinit ice wait lucid
zinit load agkozak/zsh-z

# Better history search
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward

# Use modern completion system
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case insensitive completion

# Additional shell options
setopt AUTO_CD              # cd by typing directory name
setopt EXTENDED_GLOB        # Extended globbing
setopt GLOB_DOTS           # Include hidden files in glob
setopt INTERACTIVE_COMMENTS # Allow comments in interactive shell

eval $(keychain --eval ~/.ssh/thinkpad-github)
export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket

# Remove any existing nvim alias
unalias nvim 2>/dev/null || true

# Function to launch Neovim in Kitty when not already in Kitty
function nvim {
  # Check if we're already in Kitty
  if [[ -n "$KITTY_WINDOW_ID" || "$TERM" == "xterm-kitty" ]]; then
    # If in Kitty, just run nvim normally
    NVIM_LISTEN_ADDRESS=/tmp/nvimsocket command nvim --listen /tmp/nvimsocket "$@"
  else
    # If not in Kitty, launch Kitty with nvim as the command
    kitty -e zsh -c "NVIM_LISTEN_ADDRESS=/tmp/nvimsocket nvim --listen /tmp/nvimsocket \"$@\"" &
  fi
}

