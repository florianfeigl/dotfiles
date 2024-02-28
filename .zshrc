# aliases 
alias ll="ls -al"

# paths 
export PATH="$HOME/.tmux/plugins/tmuxifier/bin:$PATH"

# warp
WARP_THEMES_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/warp-terminal/themes"
export WARP_SHELL="starship"

# editor
export VISUAL="nvim"
export EDITOR="$VISUAL"

# eval 
eval "$(tmuxifier init -)"
eval "$(starship init zsh)"
