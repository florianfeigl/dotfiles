# Chezmoi Setup Instructions - Fresh Installation

This document provides clear, step-by-step instructions for setting up chezmoi with dotfiles in `~/repos/chezmoi`.

**Date:** 2026-03-15  
**Configuration Version:** Latest with Kanata optimization + Dependency docs

---

## Quick Start (Recommended)

If you're setting up on a fresh system:

```bash
# 1. Create repos directory
mkdir -p ~/repos

# 2. Clone chezmoi with custom source path
chezmoi init git@github.com:florianfeigl/chezmoi.git \
  --source ~/repos/chezmoi \
  --apply

# 3. Verify installation
chezmoi source-path          # Should show: /home/vlad/repos/chezmoi
chezmoi diff                 # Should show no differences
```

That's it! All configurations will be deployed to your home directory.

---

## What Gets Installed

After running the quick start command, you'll have:

### Configuration Files in `$HOME`
- `.zshrc` - Zsh shell configuration
- `.tmux.conf` - Tmux terminal multiplexer config
- `.gitconfig` - Git configuration
- `.vimrc` - Vim fallback config

### Configuration Directories in `~/.config`
- `alacritty/` - Terminal emulator
- `ghostty/` - Terminal emulator
- `kitty/` - Terminal emulator
- `fuzzel/` - Application launcher
- `hyprland/` - Hyprland compositor (Arch only)
- `sway/` - Sway compositor (Debian only)
- `waybar/` - Waybar status bar (Arch only)
- `kanata/` - Keyboard remapper
- `systemd/user/` - User systemd services
- `nvim/` - Neovim + plugins
- `yazi/` - Terminal file manager
- Plus many more...

### Systemd Services
- `kanata.service` - Keyboard remapper (auto-starts with session)

---

## Day-to-Day Workflow

### Update dotfiles from remote

```bash
chezmoi update          # Pull latest + apply
```

### Edit a specific file

```bash
chezmoi edit ~/.zshrc           # Edit in $EDITOR, auto-syncs back
chezmoi edit ~/.config/nvim/init.lua
```

### Preview changes before applying

```bash
chezmoi diff                    # Show what would change
chezmoi apply                   # Apply changes
```

### Navigate to source directory

```bash
chezmoi cd                      # cd into ~/repos/chezmoi for git operations
```

---

## Important: sourceDir Configuration

The `.chezmoi.toml.tmpl` file includes:

```toml
sourceDir = "{{ .chezmoi.homeDir }}/repos/chezmoi"

[data]
    hostname = "{{ .chezmoi.hostname }}"
```

This ensures chezmoi always uses `~/repos/chezmoi` as the source, regardless of where you initialize it.

**Benefit:** You can see and manage your dotfiles directly in `~/repos/chezmoi` instead of hidden in `~/.local/share/chezmoi`.

---

## After Initial Setup

### 1. Enable Kanata keyboard service

```bash
systemctl --user enable kanata
systemctl --user start kanata
```

**Verify it's working:**
```bash
journalctl --user -u kanata -n 20
```

### 2. Fix Waybar clock (if not showing)

The clock needs the correct locale. Set it in your shell:

```bash
echo 'export LANG=en_GB.UTF-8' >> ~/.zshrc
source ~/.zshrc
systemctl --user restart waybar
```

### 3. Install missing dependencies

See `~/repos/cloud-init/INFO.md` for comprehensive dependency lists:

**Arch Linux:**
```bash
pacman -S --needed - < ~/repos/cloud-init/pkgs/arch/base.lst
pacman -S --needed - < ~/repos/cloud-init/pkgs/arch/hyprland.lst
```

**Debian/Ubuntu:**
```bash
xargs apt-get install -y < ~/repos/cloud-init/pkgs/debian/base.lst
xargs apt-get install -y < ~/repos/cloud-init/pkgs/debian/sway.lst
```

### 4. Install Kanata from Rust

```bash
# Install Rust (if not already installed)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install kanata
cargo install --locked kanata
```

---

## Troubleshooting

### Chezmoi won't find the source directory

**Problem:** `chezmoi source-path` shows wrong path

**Solution:** Ensure `~/.config/chezmoi/chezmoi.toml` has:
```toml
sourceDir = "/home/vlad/repos/chezmoi"
```

Or re-run initialization:
```bash
chezmoi init git@github.com:florianfeigl/chezmoi.git \
  --source ~/repos/chezmoi \
  --apply
```

### Kanata keyboard remapper not working

See: `~/.local/share/chezmoi/INFO-CLOUD-INIT.md` → Troubleshooting → Kanata Issues

Common fix:
```bash
systemctl --user restart kanata
journalctl --user -u kanata -n 50    # View logs
```

### Waybar shows no clock/time

See: `~/.local/share/chezmoi/INFO-CLOUD-INIT.md` → Troubleshooting → Waybar Issues

Quick fix:
```bash
echo 'export LANG=en_GB.UTF-8' >> ~/.zshrc
source ~/.zshrc
systemctl --user restart waybar
```

### Missing dependencies

See: `~/repos/cloud-init/INFO.md` for complete dependency lists and installation commands.

---

## Recovery: If ~/.local/share/chezmoi Gets Out of Sync

If you make changes in `~/repos/chezmoi` but `~/.local/share/chezmoi` doesn't update:

```bash
# Pull latest from remote
cd ~/repos/chezmoi
git pull origin main

# Re-apply to home directory
chezmoi apply -v
```

---

## Distro-Specific Notes

### Arch Linux
- Gets Hyprland + Waybar by default
- Uses `pacman` for package management
- See `pkgs/arch/` for all package lists

### Debian/Ubuntu
- Gets Sway instead of Hyprland
- Uses `apt` for package management
- Some package names differ from Arch
- See `pkgs/debian/` for all package lists

---

## Additional Resources

- **Main Repository:** https://github.com/florianfeigl/chezmoi
- **Cloud-Init (Dependencies):** https://github.com/florianfeigl/cloud-init
- **Kanata:** https://github.com/jtroo/kanata
- **Hyprland:** https://hyprland.org/
- **Chezmoi Docs:** https://www.chezmoi.io/

---

## Need Help?

See the comprehensive troubleshooting guide in:
`~/.local/share/chezmoi/INFO-CLOUD-INIT.md`

Or check the recovery notes:
`~/.local/share/chezmoi/RECOVERY-NOTE.md`
