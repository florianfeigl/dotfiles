# vi mode
#bindkey -v
#bindkey -l

# history settings
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward
HISTSIZE=1000
SAVEHIST=2000

# aliases 
alias ll="ls -al"

# paths 
export PATH="$HOME/.tmux/plugins/tmuxifier/bin:$PATH"

# editor
export VISUAL="nvim"
export EDITOR="$VISUAL"

# eval 
eval "$(tmuxifier init -)"
