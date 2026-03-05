# dotfiles

Personal dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/) (migration to [chezmoi](https://www.chezmoi.io/) planned).

## Usage

```sh
stow --target=$HOME <package>
```

## Packages

| Package | Description |
|---------|-------------|
| `alacritty` | GPU-accelerated terminal emulator (TOML config) |
| `environment.d` | GTK theme, cursor, icon environment variables |
| `ghostty` | Ghostty terminal emulator (Catppuccin Macchiato) |
| `hyprland` | Hyprland compositor + waybar + hypridle/hyprlock |
| `kanata` | Keyboard remapper (CapsLock->Esc/Ctrl, home row mods) |
| `kitty` | Kitty terminal emulator (Catppuccin Macchiato) |
| `mimeapps` | Default application associations |
| `mpd` | Music Player Daemon (PipeWire + FIFO visualizer) |
| `ncmpcpp` | MPD client with spectrum visualizer |
| `nvim` | Neovim (Lazy.nvim, LSP, Treesitter, Catppuccin Macchiato) |
| `sway` | Sway compositor (Debian workstations) |
| `tmux` | Terminal multiplexer (TPM, vim-tmux-navigator) |
| `vim` | Minimal vimrc fallback |
| `weechat` | IRC client (secrets managed via pass) |
| `wofi` | Wayland application launcher |
| `yazi` | Terminal file manager (Catppuccin Macchiato) |
| `zsh` | Zsh + zinit + Starship prompt |

## Non-stow directories

| Directory | Description |
|-----------|-------------|
| `pkgs/` | Package lists for Arch Linux (base, fonts, hyprland, kde, latex, media, network, productivity, sound, sway) |
| `scripts/` | Utility scripts (brightness, volume) |
| `sddm/` | SDDM login theme (install to `/usr/share/sddm/themes/`) |

## Theme

[Catppuccin Macchiato](https://github.com/catppuccin/catppuccin) across all applications (terminals, neovim, waybar, wofi, sway, yazi). Font: MesloLGS Nerd Font Mono.

## mpd + ncmpcpp

### Setup

1. Install: `pacman -S mpd ncmpcpp`
2. Create directories: `mkdir -p ~/.mpd/playlists`
3. Stow configs: `stow mpd ncmpcpp`
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

### Podcasts

mpd has no native podcast support. Options:

- **podboat** (part of newsboat): CLI podcast manager. Add RSS feeds to
  `~/.newsboat/urls`, download episodes with podboat, play via mpd.
  `pacman -S newsboat`

- **castero**: Dedicated TUI podcast client. Standalone player (does not
  use mpd). `yay -S castero-git`

Recommendation: **podboat** integrates better with your existing mpd setup.
Download episodes to `~/Music/Podcasts/`, they appear in mpd automatically.
