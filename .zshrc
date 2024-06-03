# vi mode
#bindkey -v
#bindkey -l

# history settings
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward
HISTSIZE=1000
SAVEHIST=2000

# aliases 
alias ls="eza"
alias ll="eza -alh"
alias tree="eza --tree"

# exports 
export PATH="$HOME/.tmux/plugins/tmuxifier/bin:$PATH"

export VISUAL="nvim"
export EDITOR="$VISUAL"

export TERM="alacritty"

# eval tmuxifier
eval "$(tmuxifier init -)"

# fzf config
source <(fzf --zsh)
