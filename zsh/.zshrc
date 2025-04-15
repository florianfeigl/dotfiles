# Starship prompt
eval "$(starship init zsh)"

# zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found

# Load completions
autoload -U compinit && compinit

zinit cdreplay -q

# Editor for local and remote sessions
export VISUAL="nvim"
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR="nvim"
else
  export EDITOR="$VISUAL"
fi

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# Aliases
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --color'
  alias ll='eza -lah --color'
  alias tree='eza --tree'
else
  alias ls='ls --color=auto'
  alias ll='ls -lah --color=auto'
  
  # Hinweis ausgeben, falls eza nicht installiert ist
  echo "Hinweis: 'eza' ist nicht installiert. Nutze Standard 'ls'."
  
  # Optional: Fallback für tree, falls vorhanden
  if command -v tree >/dev/null 2>&1; then
    alias tree='tree -C'
  else
    echo "Hinweis: 'tree' ist ebenfalls nicht installiert."
  fi
fi

# Prüfe, ob bat installiert ist
if command -v bat >/dev/null 2>&1; then
  alias cat='bat'
else
  echo "Hinweis: 'bat' ist nicht installiert. Nutze Standard 'cat'."
fi

alias vi="nvim"
alias cat="bat"

# Exports
export PATH="$HOME/.tmux/plugins/tmuxifier/bin:$HOME/.cargo/bin:$HOME/.local/bin:/opt/nvim-linux64/bin:$PATH"
export TERMINAL="ghostty"
export TERM="ghostty"

# SOURCE & EVAL
source <(fzf --zsh)
eval "$(zoxide init --cmd cd zsh)"
eval "$(tmuxifier init -)"

# SSH-Agent starten, wenn nicht verbunden
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
  eval "$(ssh-agent -s)"
fi

# Keybindings
bindkey -e
bindkey "^f" autosuggest-accept
bindkey "Home" beginning-of-line
bindkey "End" end-of-line
bindkey "Insert" overwrite-mode
bindkey '^[[3~' delete-char
#bindkey '^k' history-search-backward
#bindkey '^j' history-search-forward

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':completion:*' special-dirs true
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# mdp
export MPD_HOST=172.22.173.139

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

