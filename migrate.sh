#!/usr/bin/env bash
set -euo pipefail

# migrate.sh -- Migrate from GNU Stow to chezmoi
#
# Run this on systems where dotfiles are currently managed with stow.
# It removes stow symlinks, then sets up chezmoi with this repo as source.
#
# Usage:
#   cd ~/path/to/dotfiles
#   ./migrate.sh

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Dotfiles Migration: Stow -> chezmoi ==="
echo "Repo: $REPO_DIR"
echo ""

# 1. Remove stow symlinks
echo "--- Removing stow symlinks ---"
STOW_PKGS=(alacritty environment.d ghostty hyprland kanata kitty mimeapps mpd ncmpcpp nvim sway tmux vim weechat wofi yazi zsh)

for pkg in "${STOW_PKGS[@]}"; do
    if [ -d "$REPO_DIR/$pkg" ] 2>/dev/null; then
        stow -D --target="$HOME" "$pkg" 2>/dev/null && echo "  unstowed: $pkg" || echo "  skip: $pkg (not stowed or already removed)"
    else
        echo "  skip: $pkg (directory not found -- already migrated)"
    fi
done

# Also clean up any dangling symlinks that point into the old stow structure
echo ""
echo "--- Cleaning dangling symlinks ---"
find "$HOME/.config" -maxdepth 2 -type l ! -exec test -e {} \; -print -delete 2>/dev/null || true
for f in "$HOME/.zshrc" "$HOME/.tmux.conf" "$HOME/.vimrc"; do
    if [ -L "$f" ] && [ ! -e "$f" ]; then
        rm "$f" && echo "  removed dangling: $f"
    fi
done

# 2. Check chezmoi is installed
echo ""
echo "--- Checking chezmoi ---"
if ! command -v chezmoi &>/dev/null; then
    echo "chezmoi not found. Installing..."
    if command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm chezmoi
    elif command -v apt-get &>/dev/null; then
        sudo sh -c 'curl -fsLS get.chezmoi.io | sh -s -- -b /usr/local/bin'
    else
        echo "ERROR: Could not install chezmoi. Install it manually."
        exit 1
    fi
fi
echo "chezmoi $(chezmoi --version) found"

# 3. Initialize chezmoi with this repo
echo ""
echo "--- Initializing chezmoi ---"
chezmoi init --source "$REPO_DIR" --apply

echo ""
echo "=== Migration complete ==="
echo ""
echo "chezmoi is now managing your dotfiles from: $REPO_DIR"
echo ""
echo "Useful commands:"
echo "  chezmoi diff          # preview changes"
echo "  chezmoi apply -v      # apply changes"
echo "  chezmoi edit <file>   # edit a managed file"
echo "  chezmoi cd            # cd to source directory"
