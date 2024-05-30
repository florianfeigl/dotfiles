# vi mode
#bindkey -v
#bindkey -l

# history with fzf
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward
source <(fzf --zsh)
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# aliases 
alias ll="ls -al"

# paths 
export PATH="$HOME/.tmux/plugins/tmuxifier/bin:$PATH"

# editor
export VISUAL="nvim"
export EDITOR="$VISUAL"

# eval tmuxifier
eval "$(tmuxifier init -)"
