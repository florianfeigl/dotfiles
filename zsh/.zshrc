# Starship
eval "$(starship init zsh)"

# fzf
eval "(fzf)" # legacy
# source <(fzf --zsh) # new (0.48.0 or later)

# History-Suche mit den Pfeiltasten
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt appendhistory

autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# Autocomplete
autoload -Uz compinit
compinit

# zsh-autosuggestions
if [[ ! -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
fi
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-syntax-highlighting
if [[ ! -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
fi
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Manuelles Setzen des Keybindings für `fzf`
if [[ -f ~/.fzf.zsh ]]; then
  source ~/.fzf.zsh
  bindkey '^R' fzf-history-widget
fi

# Aliases 
alias ls="eza"
alias ll="eza -alh"
alias tree="eza --tree"

# Exports 
export PATH="$HOME/.tmux/plugins/tmuxifier/bin:$PATH"
export TERM="alacritty"
export VISUAL="nvim"
export EDITOR="$VISUAL"

# EVAL 
eval "$(tmuxifier init -)"

