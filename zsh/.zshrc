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

export TERM="alacritty"

# evals
eval "$(tmuxifier init -)"

# fzf
eval "(fzf)" # legacy
# source <(fzf --zsh) # new (0.48.0 or later)

# starship
eval "$(starship init zsh)"
