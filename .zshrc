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
alias ls="eza"
alias ll="eza -alh"
alias tree="eza --tree"

# exports 
export PATH="$HOME/.tmux/plugins/tmuxifier/bin:$PATH"

export VISUAL="nvim"
export EDITOR="$VISUAL"

<<<<<<< HEAD
export TERM="alacritty"

=======
>>>>>>> refs/remotes/origin/main
# eval tmuxifier
eval "$(tmuxifier init -)"

# fzf config
source <(fzf --zsh)
