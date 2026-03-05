# dotfiles

Personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/).

## Usage

Fresh install:

```sh
chezmoi init --apply git@github.com:florianfeigl/dotfiles.git
```

Or with an existing clone:

```sh
chezmoi init --source ~/path/to/dotfiles --apply
```

### Migrating from Stow

If your system still uses stow symlinks, run the migration script first:

```sh
cd ~/path/to/dotfiles
git pull
./migrate.sh
```

This removes all stow symlinks and initializes chezmoi.

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
