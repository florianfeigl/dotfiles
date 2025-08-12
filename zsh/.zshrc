##### ────── Basics & Guards ───────────────────────────────────────────────────
# Robustere Defaults
setopt prompt_subst no_beep
setopt auto_pushd pushd_ignore_dups
setopt extended_glob
setopt interactive_comments

# Cache-Verzeichnis
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$ZSH_CACHE_DIR"

# Räumt Konflikte auf (wichtig für zinit/zoxide)
unalias cd 2>/dev/null; unset -f cd 2>/dev/null
unalias zi 2>/dev/null; unset -f zi 2>/dev/null

# Pfad (dedupliziert) – passe nach Bedarf an
typeset -U path PATH
path=(
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  "$HOME/go/bin"
  "/usr/local/sbin"
  "/usr/local/bin"
  "/usr/sbin"
  "/usr/bin"
  "/sbin"
  "/bin"
  $path
)
export PATH

# Standard-Editoren & Pager
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export LESS='-SRFX'

##### ────── Prompt (Starship) ────────────────────────────────────────────────
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

##### ────── Plugin-Manager: zinit ────────────────────────────────────────────
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME/.git" ]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "$ZINIT_HOME/zinit.zsh"

##### ────── Completion-System ────────────────────────────────────────────────
autoload -Uz compinit
compinit -d "$ZSH_CACHE_DIR/zcompdump"
zmodload -i zsh/complist

# Completion-Qualität & Styling
zstyle ':completion:*' completer _complete _ignored _match _approximate
zstyle ':completion:*' matcher-list \
  'm:{a-z}={A-Za-z}' 'r:|[._-]=**' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{cyan}%d%f'
zstyle ':completion:*:messages'     format '%F{yellow}%d%f'
zstyle ':completion:*:warnings'     format '%F{red}%d%f'
# Farbig nach LS_COLORS, wenn vorhanden
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

##### ────── Plugins (Reihenfolge wichtig) ────────────────────────────────────
# 1) Completions zuerst
zinit light zsh-users/zsh-completions
# 2) Autosuggestions
zinit light zsh-users/zsh-autosuggestions
# 3) fzf-tab (verbessert Tab-Completion)
zinit light Aloxaf/fzf-tab
# 4) Syntax-Highlighting IMMER zuletzt
zinit light zsh-users/zsh-syntax-highlighting

# fzf-tab Feinschliff
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:*' show-group full

##### ────── Zoxide (ohne cd-Override) ────────────────────────────────────────
# Installiere zoxide ideal via Paketmanager (Debian/Ubuntu: apt install zoxide)
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"   # nur `z`, KEIN --cmd cd
fi

##### ────── History ──────────────────────────────────────────────────────────
export HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
mkdir -p "$(dirname "$HISTFILE")"
export HISTSIZE=200000
export SAVEHIST=200000
setopt share_history            # History zwischen Sessions teilen
setopt hist_ignore_all_dups     # Duplikate vermeiden
setopt hist_reduce_blanks
setopt hist_ignore_space        # Befehle, die mit Space beginnen, nicht speichern
setopt hist_find_no_dups
setopt extended_history

##### ────── Keybindings (nur autosuggest-accept) ─────────────────────────────
bindkey -e                                   # Emacs-Mode
# einziges zusätzliches Binding: Vorschlag annehmen
bindkey '^f' autosuggest-accept              # Ctrl-f akzeptiert Vorschlag

##### ────── Aliases & Tools ──────────────────────────────────────────────────
# nvim
alias vi='nvim'
alias vim='nvim'

# eza / ls / tree
if command -v eza >/dev/null 2>&1; then
  # Icons nur, wenn ein Nerd Font aktiv ist – bei Bedarf --icons entfernen
  alias ls='eza --group-directories-first --classify --icons=auto'
  alias ll='eza -l --group-directories-first --classify --git --icons=auto'
  alias la='eza -la --group-directories-first --classify --git --icons=auto'
  # "tree"-Ansicht
  alias tree='eza --tree --level=2 --long --icons=auto'
else
  alias ll='ls -alF'
  alias la='ls -A'
fi

# bat / batcat
if command -v bat >/dev/null 2>&1; then
  alias bat='bat'
elif command -v batcat >/dev/null 2>&1; then
  alias bat='batcat'
fi
export BAT_PAGER="${PAGER}"
# Wähle ein Theme, falls installiert (mit `bat --list-themes` prüfen)
export BAT_THEME="ansi"

# grep farbig
alias grep='grep --color=auto'

##### ────── tmuxifier ────────────────────────────────────────────────────────
# Installationspfade (falls du tmuxifier nutzt)
export TMUXIFIER="${TMUXIFIER:-$HOME/.tmuxifier}"
export TMUXIFIER_LAYOUT_PATH="${TMUXIFIER_LAYOUT_PATH:-$TMUXIFIER/layouts}"
if [ -d "$TMUXIFIER" ]; then
  export PATH="$TMUXIFIER/bin:$PATH"
  if command -v tmuxifier >/dev/null 2>&1; then
    eval "$(tmuxifier init -)"
  fi
fi

##### ────── SSH-Agent (nur in Login-Shell starten) ───────────────────────────
if [[ -o login ]]; then
  if ! ssh-add -l >/dev/null 2>&1; then
    eval "$(ssh-agent -s)" >/dev/null
    # Lade alle privaten Keys automatisch
    for key in ~/.ssh/*; do
      if [[ -f "$key" && ! "$key" =~ \.(pub|old)$ && ! "$key" =~ (config|known_hosts)$ ]]; then
        ssh-add -q "$key" 2>/dev/null
      fi
    done
  fi
fi

##### ────── Yazi Helper (nutzt echtes builtin cd) ────────────────────────────
y() {
  local tmp; tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}
