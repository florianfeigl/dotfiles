#!/usr/bin/env bash
set -euo pipefail

# migrate.sh -- Migrate from GNU Stow to chezmoi
#
# Run this on systems where dotfiles were previously managed with stow.
# It removes stow symlinks and dangling references, then applies chezmoi.
#
# Prerequisites:
#   chezmoi init git@github.com:florianfeigl/dotfiles.git
#
# Usage:
#   cd $(chezmoi source-path)
#   ./migrate.sh

echo "=== Dotfiles Migration: Stow -> chezmoi ==="
echo ""

# 1. Find and remove the old stow repo clone
echo "--- Locating old stow dotfiles repo ---"
OLD_STOW_DIRS=(
    "$HOME/src/Grive/Repositories/dotfiles"
    "$HOME/dotfiles"
    "$HOME/.dotfiles"
)

OLD_REPO=""
for dir in "${OLD_STOW_DIRS[@]}"; do
    if [ -d "$dir" ] && [ -d "$dir/.git" ]; then
        OLD_REPO="$dir"
        break
    fi
done

if [ -n "$OLD_REPO" ]; then
    echo "  found: $OLD_REPO"

    # Remove stow symlinks using the old repo
    echo ""
    echo "--- Removing stow symlinks ---"
    STOW_PKGS=(alacritty environment.d ghostty hyprland kanata kitty mimeapps mpd ncmpcpp nvim sway tmux vim weechat wofi yazi zsh)

    for pkg in "${STOW_PKGS[@]}"; do
        if [ -d "$OLD_REPO/$pkg" ]; then
            stow -d "$OLD_REPO" -D --target="$HOME" "$pkg" 2>/dev/null \
                && echo "  unstowed: $pkg" \
                || echo "  skip: $pkg (not stowed)"
        fi
    done
else
    echo "  no old stow repo found, skipping unstow"
fi

# 2. Clean up dangling symlinks
echo ""
echo "--- Cleaning dangling symlinks ---"
find "$HOME/.config" -maxdepth 2 -type l ! -exec test -e {} \; -print -delete 2>/dev/null || true
for f in "$HOME/.zshrc" "$HOME/.tmux.conf" "$HOME/.vimrc"; do
    if [ -L "$f" ] && [ ! -e "$f" ]; then
        rm "$f" && echo "  removed dangling: $f"
    fi
done
echo "  done"

# 3. Apply chezmoi
echo ""
echo "--- Applying chezmoi ---"
if ! command -v chezmoi &>/dev/null; then
    echo "ERROR: chezmoi not found."
    echo "Install it first, then run:"
    echo "  chezmoi init git@github.com:florianfeigl/dotfiles.git --apply"
    exit 1
fi

chezmoi apply -v

echo ""
echo "=== Migration complete ==="
echo ""
echo "Useful commands:"
echo "  chezmoi update        # pull + apply latest changes"
echo "  chezmoi diff          # preview pending changes"
echo "  chezmoi apply -v      # apply changes"
echo "  chezmoi edit <file>   # edit a managed file"
echo "  chezmoi cd            # cd to source directory"
