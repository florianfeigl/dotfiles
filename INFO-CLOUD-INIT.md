# Chezmoi Dotfiles - Dependency & Configuration Information

**NOTE:** This file should be located at `~/repos/cloud-init/INFO.md`. It's temporarily stored here due to system recovery. Move it to the correct location when cloud-init repository is restored.

---

This document provides comprehensive information about all dependencies required for the chezmoi dotfiles configuration, organized by category and distribution.

**Last Updated:** 2026-03-15  
**Target Systems:** Arch Linux, Debian/Ubuntu  
**Configuration Repository:** https://github.com/florianfeigl/chezmoi

---

## Table of Contents

1. [System Requirements](#system-requirements)
2. [Package Lists](#package-lists)
3. [Rust/Cargo Tools](#rustcargo-tools)
4. [Runtime Requirements](#runtime-requirements)
5. [Installation Instructions](#installation-instructions)
6. [Locale Configuration](#locale-configuration)
7. [Troubleshooting](#troubleshooting)

---

## System Requirements

### Supported Distributions

- **Arch Linux** (Primary - with Hyprland + Waybar)
- **Debian/Ubuntu** (Secondary - with Sway)

### Minimum Hardware

- **CPU:** x86_64 compatible
- **RAM:** 4GB recommended
- **Storage:** 2GB for full installation
- **Display:** Wayland-capable (Hyprland on Arch, Sway on Debian)

---

## Package Lists

All package lists are maintained in this repository:
- Arch: `pkgs/arch/*.lst`
- Debian: `pkgs/debian/*.lst`

### Arch Linux (`pkgs/arch/`)

#### Core System (Base + Development)
**File:** `base.lst`

Includes:
- Shell: `zsh`
- Editors: `neovim`
- Terminal Multiplexer: `tmux`
- Git + VCS: `git`, `github-cli`
- Dev Tools: `base-devel` (gcc, make, etc.)
- CLI Utilities: `bat`, `eza`, `ripgrep`, `fzf`, `fd`, `jq`
- Monitoring: `htop`, `btop`

**Installation:**
```bash
pacman -S --needed - < pkgs/arch/base.lst
```

#### Terminals
**Terminals used:** alacritty, kitty, ghostty

These are all included in base.lst or available via AUR:
```bash
pacman -S alacritty
```

#### Hyprland Desktop (Arch Only)
**File:** `hyprland.lst`

Includes:
- **Compositor:** `hyprland`, `hypridle`, `hyprlock`, `hyprpaper`
- **Status Bar:** `waybar`
- **Launcher:** `fuzzel`
- **Notifications:** `swaync`
- **Power Management:** `power-profiles-daemon`
- **Portal Support:** `xdg-desktop-portal`, `xdg-desktop-portal-hyprland`
- **Screenshot:** `hyprshot`

**Installation:**
```bash
pacman -S --needed - < pkgs/arch/hyprland.lst
```

#### Sway Desktop (Debian/Ubuntu, optional for Arch)
**File:** `sway.lst`

If you prefer Sway instead of Hyprland:
```bash
pacman -S --needed - < pkgs/arch/sway.lst
```

#### Additional Categories

**Fonts** (`fonts.lst`):
- Nerd Fonts for terminal/UI: MesloLGS, IosevkaTerm

**Sound** (`sound.lst`):
- PipeWire audio stack
- Pulseaudio control utilities

**Network** (`network.lst`):
- NetworkManager
- Network diagnostics tools

**Media** (`media.lst`):
- Image viewer, music player, PDF reader

**Productivity** (`productivity.lst`):
- File manager, office tools

**LaTeX** (`latex.lst`):
- TeX Live distribution for document compilation

### Debian/Ubuntu (`pkgs/debian/`)

**Note:** Debian package names differ from Arch. The same `*.lst` files exist with Debian equivalents.

#### Installation Example

```bash
# Install base packages
xargs apt-get install -y < pkgs/debian/base.lst

# Install Sway (Debian default)
xargs apt-get install -y < pkgs/debian/sway.lst
```

---

## Rust/Cargo Tools

### Critical Tool: Kanata

**Purpose:** Keyboard remapper with home-row mods support  
**Source:** Rust (must compile from source)  
**Installation:**

```bash
# Requires Rust/Cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install kanata (locked version for reproducibility)
cargo install --locked kanata
```

**Configuration:** `~/.config/kanata/config.kbd`  
**Service:** `~/.config/systemd/user/kanata.service`

### Why Cargo?

Kanata is rapidly evolving and best installed from source. System packages are often outdated.

**Verify installation:**
```bash
kanata --version
systemctl --user start kanata
systemctl --user status kanata
```

### Optional Rust Tools

Other tools that might be useful:
- `ripgrep` (rg) - Fast text search
- `exa` (ls replacement)
- `fd` (find replacement)

These are already in `base.lst` as system packages but can be installed via cargo if preferred.

---

## Runtime Requirements

### Browser & GUI Apps

Tools assumed to be available (install per preference):
- **Web Browser:** firefox, chromium, brave (AUR)
- **File Manager:** thunar, nautilus
- **Text Editor Fallback:** vim, nano

### Language Servers (Neovim)

Installed automatically via Mason (inside Neovim):
- LSP servers: lua, rust, python, javascript, bash, json, yaml, etc.
- Formatters: prettier, black, stylua
- Linters: eslint, pylint, shellcheck

**First run:** `:Mason` inside Neovim to install and manage LSPs

### Node.js / NPM

**Why needed:** Some Neovim plugins and general scripting  
**Installation:**

```bash
# Arch
pacman -S nodejs npm

# Debian
apt-get install nodejs npm
```

**Note:** Specific NPM packages are NOT tracked centrally. Install per-project as needed.

---

## Installation Instructions

### Quick Start (Arch Linux)

```bash
# 1. Install base system packages
pacman -S --needed - < pkgs/arch/base.lst

# 2. Install Hyprland desktop
pacman -S --needed - < pkgs/arch/hyprland.lst

# 3. Install Rust toolchain
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# 4. Install kanata
cargo install --locked kanata

# 5. Deploy dotfiles
chezmoi init git@github.com:florianfeigl/chezmoi.git --apply

# 6. Enable services
systemctl --user enable --now kanata

# 7. Verify installation
kanata --version
waybar --version
chezmoi diff
```

### Quick Start (Debian/Ubuntu)

```bash
# 1. Install base system packages
xargs apt-get install -y < pkgs/debian/base.lst

# 2. Install Sway desktop
xargs apt-get install -y < pkgs/debian/sway.lst

# 3. Install Rust toolchain
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# 4. Install kanata
cargo install --locked kanata

# 5. Deploy dotfiles
chezmoi init git@github.com:florianfeigl/chezmoi.git --apply

# 6. Enable services
systemctl --user enable --now kanata

# 7. Verify installation
kanata --version
chezmoi diff
```

### Manual Installation (per category)

If you don't need everything, install categories selectively:

```bash
# Just core dev tools
pacman -S --needed - < pkgs/arch/base.lst

# Add Hyprland later
pacman -S --needed - < pkgs/arch/hyprland.lst

# Add media tools
pacman -S --needed - < pkgs/arch/media.lst

# Add LaTeX
pacman -S --needed - < pkgs/arch/latex.lst
```

---

## Locale Configuration

### Current System Locale

The dotfiles expect `en_GB.UTF-8` but work with any UTF-8 locale.

**Check current locale:**
```bash
locale
localectl status
```

### Setting Locale (Arch)

```bash
# View available locales
locale -a

# Ensure en_GB.UTF-8 is enabled in /etc/locale.gen
sudo nano /etc/locale.gen

# Uncomment: en_GB.UTF-8 UTF-8
# Then regenerate:
sudo locale-gen

# Set system-wide
sudo localectl set-locale LANG=en_GB.UTF-8 LC_ALL=en_GB.UTF-8
```

### Setting Locale (Debian)

```bash
# Reconfigure locales
sudo dpkg-reconfigure locales

# Select en_GB.UTF-8 and make it default
sudo update-locale LANG=en_GB.UTF-8 LC_ALL=en_GB.UTF-8
```

### Verify Locale for Waybar (Critical)

If Waybar shows no time/date:

```bash
# Test with explicit locale
LANG=en_GB.UTF-8 waybar

# Check systemd service environment
systemctl --user show waybar.service -p Environment

# If empty, set it in user environment:
echo 'export LANG=en_GB.UTF-8' >> ~/.bashrc
echo 'export LANG=en_GB.UTF-8' >> ~/.zshrc

# Or set per-service:
mkdir -p ~/.config/systemd/user/waybar.service.d
cat > ~/.config/systemd/user/waybar.service.d/override.conf <<EOF
[Service]
Environment="LANG=en_GB.UTF-8"
Environment="LC_ALL=en_GB.UTF-8"
EOF

systemctl --user daemon-reload
systemctl --user restart waybar
```

---

## Troubleshooting

### Kanata Issues

#### DEL Key produces tilde (~) instead of Delete

**Status:** FIXED in latest config (2026-03-15)

All function keys are now properly mapped. Update your config:
```bash
chezmoi update
chezmoi apply
systemctl --user restart kanata
```

#### Kanata won't start

```bash
# Check service status
systemctl --user status kanata

# View logs
journalctl --user -u kanata -n 50

# Test manually
~/.cargo/bin/kanata --cfg ~/.config/kanata/config.kbd
```

**Common issues:**
- Kanata binary not found: `cargo install --locked kanata`
- Config file not found: `chezmoi apply`
- Device permission: Usually requires uinput, handled by systemd service

### Waybar Issues

#### No clock/time displayed

**Root cause:** Locale not set in user session

**Solution:**
```bash
# 1. Verify locale is installed
locale -a | grep en_GB

# 2. Regenerate if missing
sudo locale-gen

# 3. Set in user environment
echo 'export LANG=en_GB.UTF-8' >> ~/.zshrc
source ~/.zshrc

# 4. Restart waybar
systemctl --user restart waybar
```

#### Waybar won't start

```bash
# Check if it's already running
ps aux | grep waybar

# Kill any stuck processes
killall -9 waybar

# Test manually
waybar --log-level debug 2>&1 | tee /tmp/waybar.log

# Check for missing dependencies
pacman -Q gtk3 libsystemd

# View systemd logs
journalctl --user -u waybar -n 50
```

#### Tooltip calendar not showing

**Configuration:** Calendar feature requires GTK3 and proper locale  
**Fix:**
- Ensure `gtk3` is installed
- Verify locale (see above)
- Check browser zoom isn't affecting rendering

### Neovim Issues

#### LSPs not available after startup

```bash
# Open Neovim and run:
:Mason

# Or install specific LSP:
:MasonInstall lua_ls pyright rust-analyzer

# Check logs:
:e $HOME/.local/share/nvim/lsp.log
```

#### Plugins not loading

```bash
# Manually sync Lazy packages
:Lazy sync

# Check for errors
:Lazy check

# View logs
:LspLog
```

### Git/GitHub Issues

#### SSH key not recognized

```bash
# Generate SSH key for GitHub
ssh-keygen -t ed25519 -C "your.email@example.com"

# Add to ssh-agent
ssh-add ~/.ssh/id_ed25519

# Test connection
ssh -T git@github.com
```

### System Integration

#### Services not starting on login

```bash
# Enable kanata service
systemctl --user enable kanata

# Enable mpd (if using music)
systemctl --user enable mpd

# View all enabled services
systemctl --user list-unit-files | grep enabled
```

#### Fonts look wrong in terminal

**Verify Nerd Fonts installation:**
```bash
# Arch
pacman -Q nerd-fonts-meslo nerd-fonts-iosevka

# Check terminal font settings
# Alacritty: ~/.config/alacritty/alacritty.toml
# Kitty: ~/.config/kitty/kitty.conf
# Ghostty: ~/.config/ghostty/config
```

---

## Dependency Summary Table

| Tool | Version | Category | Arch Pkg | Debian Pkg | Install Method |
|------|---------|----------|----------|------------|-----------------|
| chezmoi | latest | Config Mgmt | chezmoi | chezmoi | pacman/apt |
| neovim | 0.9+ | Editor | neovim | neovim | pacman/apt |
| zsh | 5.9+ | Shell | zsh | zsh | pacman/apt |
| tmux | 3.3+ | Multiplexer | tmux | tmux | pacman/apt |
| git | 2.40+ | VCS | git | git | pacman/apt |
| kanata | 1.11+ | Input | -- | -- | cargo (--locked) |
| hyprland | 0.4+ | Compositor | hyprland | -- | pacman |
| waybar | 0.15+ | Bar | waybar | waybar | pacman/apt |
| sway | 1.8+ | Compositor | sway | sway | pacman/apt |
| alacritty | 0.12+ | Terminal | alacritty | alacritty | pacman/apt |
| fuzzel | 1.10+ | Launcher | fuzzel | fuzzel | pacman/apt |
| npm | latest | Runtime | nodejs | nodejs | pacman/apt |
| Rust | 1.70+ | Runtime | rust | rust | rustup |

---

## Verification Checklist

Before proceeding with chezmoi deployment, verify:

- [ ] All system packages installed (`pacman -Q base-devel`, etc.)
- [ ] Kanata installed and working (`kanata --version`)
- [ ] Locale set correctly (`locale` shows en_GB.UTF-8)
- [ ] Rust/Cargo installed (`rustc --version`, `cargo --version`)
- [ ] Git configured (`git config user.name`, `git config user.email`)
- [ ] SSH key available (`ls ~/.ssh/id_rsa` or `ls ~/.ssh/id_ed25519`)
- [ ] Chezmoi ready (`which chezmoi` or `cargo install chezmoi`)

Once verified, deploy:
```bash
chezmoi init git@github.com:florianfeigl/chezmoi.git --apply
```

---

## Related Resources

- **Chezmoi Dotfiles:** https://github.com/florianfeigl/chezmoi
- **Cloud Init:** https://github.com/florianfeigl/cloud-init
- **Kanata:** https://github.com/jtroo/kanata
- **Hyprland:** https://hyprland.org/
- **Waybar:** https://github.com/Alexays/Waybar
- **Neovim:** https://neovim.io/
