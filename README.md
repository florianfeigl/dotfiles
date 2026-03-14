# chezmoi

Personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/).

## Usage

### Fresh install

**Recommended:** Clone to `~/repos/chezmoi` for easier management and visibility:

```sh
mkdir -p ~/repos
chezmoi init git@github.com:florianfeigl/chezmoi.git \
  --source ~/repos/chezmoi \
  --apply
```

This clones the repo to `~/repos/chezmoi/` and deploys all configs.

**Alternative:** Use default location (`~/.local/share/chezmoi/`):

```sh
chezmoi init git@github.com:florianfeigl/chezmoi.git --apply
```

### Day-to-day workflow

```sh
chezmoi update          # pull latest changes from remote and apply
chezmoi edit <file>     # edit a managed file in the source dir
chezmoi apply -v        # apply local source changes to $HOME
chezmoi cd              # cd into the source repo for git operations
chezmoi diff            # preview what would change
```

### Migrating from Stow

If your system still uses stow symlinks, run the migration script first:

```sh
chezmoi init git@github.com:florianfeigl/chezmoi.git
cd $(chezmoi source-path)
./migrate.sh
chezmoi apply
```

This removes all stow symlinks and deploys configs via chezmoi.

### Verify deployment

After `chezmoi apply`, reload your compositor to confirm the configs are active:

```sh
# Hyprland (Arch)
hyprctl reload

# Sway (Debian)
swaymsg reload
```

What to check:

- **Monitor resolution** returns to native (no unexpected scaling)
- **Keyboard layout** switches to `de`
- **Waybar** appears with Catppuccin Macchiato colors
- **Terminal** (alacritty) uses Macchiato color scheme and correct padding

If the compositor does not pick up the new config, log out and back in.

## Structure

| Path | Description |
|------|-------------|
| `dot_config/alacritty/` | GPU-accelerated terminal emulator (TOML config) |
| `dot_config/ghostty/` | Ghostty terminal emulator (Catppuccin Macchiato) |
| `dot_config/hypr/` | Hyprland compositor + hypridle/hyprlock (Arch only) |
| `dot_config/kanata/` | Keyboard remapper (CapsLock->Esc/Ctrl, home row mods) |
| `dot_config/kitty/` | Kitty terminal emulator (Catppuccin Macchiato) |
| `dot_config/mimeapps.list` | Default application associations |
| `dot_config/mpd/` | Music Player Daemon (PipeWire + FIFO visualizer) |
| `dot_config/ncmpcpp/` | MPD client with spectrum visualizer |
| `dot_config/nvim/` | Neovim (Lazy.nvim, LSP, Treesitter, Catppuccin Macchiato) |
| `dot_config/starship.toml` | Starship prompt config |
| `dot_config/sway/` | Sway compositor (Debian only) |
| `dot_config/systemd/` | Systemd user services (kanata) |
| `dot_config/waybar/` | Waybar status bar (Catppuccin Macchiato, Arch only) |
| `dot_config/weechat/` | IRC client (secrets managed via pass) |
| `dot_config/wofi/` | Wayland application launcher |
| `dot_config/yazi/` | Terminal file manager (Catppuccin Macchiato) |
| `dot_zshrc` | Zsh + zinit + Starship prompt |
| `dot_tmux.conf` | Terminal multiplexer (TPM, vim-tmux-navigator) |
| `dot_vimrc` | Minimal vimrc fallback |

## Distro-specific configs

Managed via `.chezmoiignore` templates:

- **Arch Linux**: deploys Hyprland + Waybar, skips Sway
- **Debian**: deploys Sway, skips Hyprland + Waybar

## Theme

[Catppuccin Macchiato](https://github.com/catppuccin/catppuccin) across all applications. Font: MesloLGS Nerd Font Mono.

## Related

- [cloud-init](https://github.com/florianfeigl/cloud-init) -- Machine provisioning (package lists, cloud-init configs, SDDM theme)
  - See **`INFO.md`** in cloud-init for complete dependency and configuration information
- [AI Assistance Documentation](./docs/ai-assistance.md) -- Documentation of AI-assisted fixes and improvements

## TODO

### System Configuration Improvements
- **Low-battery warning system**: Implement automatic monitoring with visual/audible alerts at critical battery levels (e.g., 15%)
- **Graceful shutdown on power loss**: Automatic save of work and clean shutdown procedures
- **Configuration**: Explore systemd services or dedicated monitoring daemon solutions

## mpd + ncmpcpp

### Setup

1. Install: `pacman -S mpd ncmpcpp`
2. Create directories: `mkdir -p ~/.mpd/playlists`
3. Apply configs: `chezmoi apply`
4. Start mpd: `systemctl --user enable --now mpd`
5. Launch: `ncmpcpp`

### Local music

Place files in `~/Music`. Update database: `mpc update`

### Internet radio

```sh
# Add a stream
mpc add https://stream.example.com/radio.mp3
mpc play

# Save as playlist
mpc save "radio-stations"
```
