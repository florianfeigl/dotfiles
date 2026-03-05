# Plan: Cloud-init Repo + Waybar Fix + Chezmoi Migration

## Aktueller Stand

### Cloud-init Repo (`/home/flori/src/Grive/Repositories/cloud-init`)
- Remote: `git@github.com:florianfeigl/cloud-init.git`
- 1 Commit (Initial commit), `pkgs/` ist untracked
- **Existiert**: `pkgs/arch/` mit 10 `.lst`-Dateien (1:1 aus dotfiles übernommen)
- **Leer**: `configs/`, `pkgs/debian/`, `scripts/`, `sddm/`
- **README.md**: Nur Heading `# cloud-init`

### Dotfiles Repo
- Uncommitted: `mimeapps/.config/mimeapps.list`, `nvim/.config/nvim/lazy-lock.json`, `nvim/.config/nvim/lazyvim.json`
- Zu entfernen: `pkgs/`, `scripts/`, `sddm/`

---

## Teil 1: Cloud-init Repo vervollständigen

### 1a. Debian/Ubuntu Paketlisten (`pkgs/debian/`)

Erstelle 8 Dateien mit Debian/Ubuntu apt-Paketnamen:

**`pkgs/debian/base.lst`**:
```
build-essential
bat
curl
eza
fd-find
fzf
git
htop
btop
jq
man-db
manpages
neovim
openssh-server
p7zip-full
pv
ripgrep
tmux
wget
zsh
```

**`pkgs/debian/fonts.lst`**:
```
# Nerd Fonts are not available in apt repositories.
# Install via the official Nerd Fonts installer script:
#   curl -fsSL https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/install.sh | bash -s -- CascadiaCode
#   curl -fsSL https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/install.sh | bash -s -- FiraCode
#   curl -fsSL https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/install.sh | bash -s -- Hack
#   curl -fsSL https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/install.sh | bash -s -- Iosevka
#   curl -fsSL https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/install.sh | bash -s -- JetBrainsMono
#   curl -fsSL https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/install.sh | bash -s -- LiberationMono
#   curl -fsSL https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/install.sh | bash -s -- Meslo
#   curl -fsSL https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/install.sh | bash -s -- SourceCodePro
#
# Also install Font Awesome from apt:
fonts-font-awesome
```

**`pkgs/debian/latex.lst`**:
```
texlive-base
texlive-bibtex-extra
texlive-binaries
texlive-fonts-extra
texlive-fonts-recommended
texlive-lang-german
texlive-latex-base
texlive-latex-extra
texlive-latex-recommended
texlive-science
texlive-pictures
texlive-plain-generic
texlive-publishers
```

**`pkgs/debian/media.lst`**:
```
imv
mpd
ncmpcpp
newsboat
zathura
zathura-pdf-poppler
```

**`pkgs/debian/network.lst`**:
```
network-manager
network-manager-gnome
nmap
wireshark
```

**`pkgs/debian/productivity.lst`**:
```
ffmpegthumbnailer
# lazygit: not in apt -- install from GitHub releases
libreoffice
libreoffice-l10n-de
poppler-utils
wl-clipboard
# yazi: not in apt -- install via cargo: cargo install --locked yazi-fm yazi-cli
zoxide
```

**`pkgs/debian/sound.lst`**:
```
pipewire
pipewire-alsa
pipewire-jack
pipewire-pulse
wireplumber
```

**`pkgs/debian/sway.lst`**:
```
sway
swayidle
swaylock
waybar
wofi
pavucontrol
xdg-desktop-portal-wlr
```

**KEINE Debian-Listen für**: `hyprland.lst` (nicht in Debian), `kde.lst` (anderes Paketschema, nachträglich ergänzen wenn benötigt)

### 1b. Cloud-init User-Data Configs (`configs/`)

**`configs/user-data-arch.yaml`**:
```yaml
#cloud-config

hostname: archbox
manage_etc_hosts: true

users:
  - name: flo
    gecos: Florian
    groups: [wheel, video, audio, input, docker]
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/zsh
    lock_passwd: false
    ssh_authorized_keys:
      - ssh-ed25519 REPLACE_WITH_YOUR_PUBLIC_KEY

# Arch Linux: pacman packages
# cloud-init package module does not natively support pacman,
# so we install via runcmd.
runcmd:
  # Update system
  - [pacman, -Syu, --noconfirm]

  # Install base packages
  - [pacman, -S, --needed, --noconfirm, base-devel, bat, curl, eza, fd, fzf, git, htop, btop, jq, man-db, man-pages, neovim, openssh, p7zip, pv, ripgrep, tmux, wget, zsh]

  # Install fonts
  - [pacman, -S, --needed, --noconfirm, otf-font-awesome, ttf-cascadia-code-nerd, ttf-firacode-nerd, ttf-hack-nerd, ttf-iosevka-nerd, ttf-jetbrains-mono-nerd, ttf-liberation-mono-nerd, ttf-meslo-nerd, ttf-sourcecodepro-nerd]

  # Install sound (PipeWire)
  - [pacman, -S, --needed, --noconfirm, pipewire, pipewire-alsa, pipewire-jack, pipewire-pulse, wireplumber]

  # Install network
  - [pacman, -S, --needed, --noconfirm, networkmanager, network-manager-applet, nmap, wireshark-cli]

  # Install media
  - [pacman, -S, --needed, --noconfirm, imv, mpd, ncmpcpp, newsboat, zathura, zathura-pdf-poppler]

  # Install productivity
  - [pacman, -S, --needed, --noconfirm, ffmpegthumbnailer, lazygit, libreoffice-still, libreoffice-still-de, poppler, wl-clipboard, yazi, zoxide]

  # Install AUR helper (yay) as user flo
  - [su, -c, "git clone https://aur.archlinux.org/yay.git /tmp/yay && cd /tmp/yay && makepkg -si --noconfirm && rm -rf /tmp/yay", flo]

  # Clone dotfiles and init chezmoi
  - [su, -c, "git clone git@github.com:florianfeigl/dotfiles.git ~/.local/share/chezmoi && chezmoi apply", flo]

  # Enable services
  - [systemctl, enable, --now, NetworkManager]
  - [systemctl, enable, --now, sshd]
```

**`configs/user-data-debian.yaml`**:
```yaml
#cloud-config

hostname: debbox
manage_etc_hosts: true

users:
  - name: flo
    gecos: Florian
    groups: [sudo, video, audio, input, docker]
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/zsh
    lock_passwd: false
    ssh_authorized_keys:
      - ssh-ed25519 REPLACE_WITH_YOUR_PUBLIC_KEY

package_update: true
package_upgrade: true

packages:
  # base
  - build-essential
  - bat
  - curl
  - eza
  - fd-find
  - fzf
  - git
  - htop
  - btop
  - jq
  - man-db
  - manpages
  - neovim
  - openssh-server
  - p7zip-full
  - pv
  - ripgrep
  - tmux
  - wget
  - zsh
  # fonts
  - fonts-font-awesome
  # sound
  - pipewire
  - pipewire-alsa
  - pipewire-jack
  - pipewire-pulse
  - wireplumber
  # network
  - network-manager
  - network-manager-gnome
  - nmap
  - wireshark
  # media
  - imv
  - mpd
  - ncmpcpp
  - newsboat
  - zathura
  - zathura-pdf-poppler
  # productivity
  - ffmpegthumbnailer
  - libreoffice
  - libreoffice-l10n-de
  - poppler-utils
  - wl-clipboard
  - zoxide

runcmd:
  # Install Nerd Fonts for user flo
  - [su, -c, "curl -fsSL https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/install.sh | bash -s -- Meslo JetBrainsMono FiraCode", flo]

  # Clone dotfiles and init chezmoi
  - [su, -c, "git clone git@github.com:florianfeigl/dotfiles.git ~/.local/share/chezmoi && chezmoi apply", flo]
```

**`configs/user-data-hyprland.yaml`** (extends arch base):
```yaml
#cloud-config

# Use with: merge_how in meta-data, or combine with user-data-arch.yaml
# This adds Hyprland desktop packages on top of the base Arch config.

runcmd:
  # Install Hyprland desktop
  - [pacman, -S, --needed, --noconfirm, hypridle, hyprland, hyprlock, hyprpaper, hyprshot, swaync, waybar, xdg-desktop-portal, xdg-desktop-portal-hyprland, power-profiles-daemon]

  # Install KDE/SDDM
  - [pacman, -S, --needed, --noconfirm, plasma-desktop, sddm, sddm-kcm, kde-gtk-config, breeze-gtk, powerdevil]

  # Install SDDM theme
  - [cp, -r, /var/lib/cloud-init/sddm/sddm-astronaut-theme, /usr/share/sddm/themes/]

  # Enable SDDM
  - [systemctl, enable, sddm]
```

### 1c. SDDM Theme

Kopiere das gesamte `sddm/sddm-astronaut-theme/` Verzeichnis aus dem dotfiles Repo:
```bash
cp -r /home/flori/src/Grive/Repositories/dotfiles/sddm/sddm-astronaut-theme /home/flori/src/Grive/Repositories/cloud-init/sddm/
```

### 1d. README.md

Ersetze die bestehende README mit vollständiger Dokumentation:

```markdown
# cloud-init

Machine provisioning configs for Arch Linux and Debian/Ubuntu, powered by [cloud-init](https://cloud-init.io/).

## Structure

| Directory | Description |
|-----------|-------------|
| `configs/` | cloud-init user-data YAML files |
| `pkgs/arch/` | Arch Linux (pacman) package lists |
| `pkgs/debian/` | Debian/Ubuntu (apt) package lists |
| `sddm/` | SDDM astronaut theme (installed to `/usr/share/sddm/themes/`) |

## Package categories

| List | Arch | Debian | Description |
|------|------|--------|-------------|
| `base.lst` | yes | yes | Core CLI tools, dev essentials |
| `fonts.lst` | yes | yes* | Nerd Fonts (*Debian: via installer script) |
| `hyprland.lst` | yes | -- | Hyprland compositor (Arch only) |
| `kde.lst` | yes | -- | KDE Plasma + SDDM |
| `latex.lst` | yes | yes | TeX Live distribution |
| `media.lst` | yes | yes | Image viewer, music, RSS, PDF |
| `network.lst` | yes | yes | NetworkManager, nmap, wireshark |
| `productivity.lst` | yes | yes | Office, file manager, git TUI |
| `sound.lst` | yes | yes | PipeWire audio stack |
| `sway.lst` | yes | yes | Sway compositor |

## Usage

### cloud-init (VMs / cloud instances)

Place the appropriate `user-data` file where your cloud provider expects it:

- **Proxmox**: Snippets storage, reference in VM config
- **libvirt/QEMU**: `--cloud-init user-data=configs/user-data-arch.yaml`
- **AWS/GCP/Azure**: Paste into user-data field

**Important**: Replace `REPLACE_WITH_YOUR_PUBLIC_KEY` in the user-data file with your actual SSH public key before use.

### Manual package installation

Arch Linux:
```sh
pacman -S --needed - < pkgs/arch/base.lst
```

Debian/Ubuntu:
```sh
xargs apt-get install -y < pkgs/debian/base.lst
```

## Configs

| Config | Target | Description |
|--------|--------|-------------|
| `user-data-arch.yaml` | Arch Linux | Full provisioning: user, packages, dotfiles, services |
| `user-data-debian.yaml` | Debian/Ubuntu | Full provisioning: user, packages, fonts, dotfiles |
| `user-data-hyprland.yaml` | Arch Linux | Desktop addon: Hyprland + KDE/SDDM (combine with arch base) |

## Related

- [dotfiles](https://github.com/florianfeigl/dotfiles) -- Personal dotfiles managed with chezmoi
```

### 1e. Commit cloud-init Repo

```bash
cd /home/flori/src/Grive/Repositories/cloud-init
git add -A
git commit -m "feat: multi-distro package lists, cloud-init configs, and SDDM theme"
git push
```

---

## Teil 2: Global Theme Switch -- Catppuccin Mocha -> Macchiato

**ERLEDIGT** -- Commit `936716c`

Alle Configs global von Catppuccin Mocha auf Macchiato umgestellt:
- 14 Dateien geändert (Hex-Codes + Theme-Referenzen)
- Kanagawa-Reste gelöscht (nvim/kanagawa.lua, yazi kanagawa.yazi flavor, tmux comment)
- 0 verbleibende Mocha/Kanagawa-Referenzen

**Hinweis**: Alacritty benötigt die externe Datei `~/.config/alacritty/catppuccin-macchiato.toml`:
```sh
curl -o ~/.config/alacritty/catppuccin-macchiato.toml https://raw.githubusercontent.com/catppuccin/alacritty/main/catppuccin-macchiato.toml
```

---

## Teil 3: Dotfiles Repo aufräumen

### 3a. Verzeichnisse löschen

```bash
cd /home/flori/src/Grive/Repositories/dotfiles
rm -rf pkgs/ scripts/ sddm/
```

### 3b. README.md aktualisieren

Entferne die "Non-stow directories" Sektion komplett (Zeilen 33-39) und ersetze sie durch einen Verweis:

```markdown
## Related

- [cloud-init](https://github.com/florianfeigl/cloud-init) -- Machine provisioning (package lists, cloud-init configs, SDDM theme)
```

---

## Teil 4: Stow zu Chezmoi In-Place Migration

### 4a. Vorbereitung

```bash
# Chezmoi installieren (falls nicht vorhanden)
pacman -S chezmoi

# Bestehende Stow-Symlinks entfernen
cd /home/flori/src/Grive/Repositories/dotfiles
for pkg in alacritty ghostty hyprland kanata kitty mimeapps mpd ncmpcpp nvim sway tmux vim weechat wofi yazi zsh; do
  stow -D --target=$HOME $pkg 2>/dev/null
done
```

### 4b. Repo-Struktur umbauen

Chezmoi erwartet eine flache Struktur im Source Directory mit spezieller Namenskonvention.
Das dotfiles Repo wird zum chezmoi Source Directory (`~/.local/share/chezmoi` symlinkt hierhin oder chezmoi wird mit `--source` konfiguriert).

**Umbau-Mapping** (alte Stow-Struktur -> neue Chezmoi-Struktur):

| Stow-Pfad | Chezmoi-Pfad |
|-----------|-------------|
| `zsh/.zshrc` | `dot_zshrc` |
| `zsh/.config/starship.toml` | `dot_config/starship.toml` |
| `tmux/.tmux.conf` | `dot_tmux.conf` |
| `vim/.vimrc` | `dot_vimrc` |
| `alacritty/.config/alacritty/` | `dot_config/alacritty/` |
| ~~`environment.d/`~~ | **VERWORFEN** -- wird nicht migriert |
| `ghostty/.config/ghostty/` | `dot_config/ghostty/` |
| `hyprland/.config/hypr/` | `dot_config/hypr/` |
| `hyprland/.config/waybar/` | `dot_config/waybar/` |
| `kanata/.config/kanata/` | `dot_config/kanata/` |
| `kanata/.config/systemd/user/kanata.service` | `dot_config/systemd/user/kanata.service` |
| `kitty/.config/kitty/` | `dot_config/kitty/` |
| `mimeapps/.config/mimeapps.list` | `dot_config/mimeapps.list` |
| `mpd/.config/mpd/` | `dot_config/mpd/` |
| `ncmpcpp/.config/ncmpcpp/` | `dot_config/ncmpcpp/` |
| `nvim/.config/nvim/` | `dot_config/nvim/` |
| `sway/.config/sway/` | `dot_config/sway/` |
| `weechat/.config/weechat/` | `dot_config/weechat/` |
| `wofi/.config/wofi/` | `dot_config/wofi/` |
| `yazi/.config/yazi/` | `dot_config/yazi/` |

**Script zur Konvertierung**:
```bash
cd /home/flori/src/Grive/Repositories/dotfiles

# Erstelle chezmoi dot_config Verzeichnis
mkdir -p dot_config

# Verschiebe .config/* Inhalte aus jedem Stow-Paket
for pkg in alacritty ghostty hyprland kanata kitty mimeapps mpd ncmpcpp nvim sway weechat wofi yazi; do
  if [ -d "$pkg/.config" ]; then
    cp -r $pkg/.config/* dot_config/
  fi
done

# zsh hat sowohl .zshrc als auch .config/starship.toml
cp zsh/.zshrc dot_zshrc
cp -r zsh/.config/* dot_config/

# tmux und vim haben Dateien direkt im Home
cp tmux/.tmux.conf dot_tmux.conf
cp vim/.vimrc dot_vimrc

# Alte Stow-Verzeichnisse entfernen
rm -rf alacritty environment.d ghostty hyprland kanata kitty mimeapps mpd ncmpcpp nvim sway tmux vim weechat wofi yazi zsh
# environment.d wird verworfen und nicht migriert

# power_menu.sh muss executable bleiben
chmod +x dot_config/waybar/power_menu.sh
```

### 4c. Chezmoi-Konfigurationsdateien erstellen

**`.chezmoiroot`**: Nicht benötigt (Standardstruktur).

**`.chezmoi.toml.tmpl`** (im Repo-Root):
```toml
[data]
    hostname = "{{ .chezmoi.hostname }}"
```

**`.chezmoiignore`** (im Repo-Root):
```
# Repo-Metadaten
README.md
LICENSE
.git/
.gitignore
.opencode/

# chezmoi config (wird intern verarbeitet, nicht deployed)
.chezmoi.toml.tmpl

# Distro-spezifisch: Hyprland nur auf Arch
{{ if ne .chezmoi.osRelease.id "arch" }}
dot_config/hypr/
dot_config/waybar/
{{ end }}

# Distro-spezifisch: Sway nur auf Debian
{{ if ne .chezmoi.osRelease.id "debian" }}
dot_config/sway/
{{ end }}
```

### 4d. Chezmoi initialisieren

```bash
# Symlink chezmoi source auf das Repo
chezmoi init --source /home/flori/src/Grive/Repositories/dotfiles

# Überprüfen
chezmoi diff

# Anwenden
chezmoi apply -v
```

### 4e. README.md aktualisieren

```markdown
# dotfiles

Personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/).

## Usage

```sh
chezmoi init --apply git@github.com:florianfeigl/dotfiles.git
```

## Structure

| Path | Description |
|------|-------------|
| `dot_config/alacritty/` | GPU-accelerated terminal emulator (TOML config) |
| `dot_config/ghostty/` | Ghostty terminal emulator (Catppuccin Mocha) |
| `dot_config/hypr/` | Hyprland compositor + hypridle/hyprlock |
| `dot_config/kanata/` | Keyboard remapper (CapsLock->Esc/Ctrl, home row mods) |
| `dot_config/kitty/` | Kitty terminal emulator (Catppuccin Mocha) |
| `dot_config/mimeapps.list` | Default application associations |
| `dot_config/mpd/` | Music Player Daemon (PipeWire + FIFO visualizer) |
| `dot_config/ncmpcpp/` | MPD client with spectrum visualizer |
| `dot_config/nvim/` | Neovim (Lazy.nvim, LSP, Treesitter, Catppuccin Mocha) |
| `dot_config/sway/` | Sway compositor (Debian workstations) |
| `dot_config/systemd/` | Systemd user services (kanata) |
| `dot_config/waybar/` | Waybar status bar (Catppuccin Mocha) |
| `dot_config/weechat/` | IRC client (secrets managed via pass) |
| `dot_config/wofi/` | Wayland application launcher |
| `dot_config/yazi/` | Terminal file manager |
| `dot_zshrc` | Zsh + zinit + Starship prompt |
| `dot_config/starship.toml` | Starship prompt config |
| `dot_tmux.conf` | Terminal multiplexer (TPM, vim-tmux-navigator) |
| `dot_vimrc` | Minimal vimrc fallback |

## Theme

[Catppuccin Mocha](https://github.com/catppuccin/catppuccin) across all applications. Font: MesloLGS Nerd Font Mono.

## Related

- [cloud-init](https://github.com/florianfeigl/cloud-init) -- Machine provisioning (package lists, cloud-init configs, SDDM theme)
```

### 4f. Commits

```bash
# Waybar fix + cleanup (Teil 2 + 3)
git add -A
git commit -m "fix: replace Kanagawa colors with Catppuccin Mocha in waybar calendar; remove pkgs, scripts, sddm (moved to cloud-init repo)"

# Chezmoi migration (Teil 4)
git add -A
git commit -m "refactor: migrate from GNU Stow to chezmoi"
git push
```

---

## Reihenfolge der Ausführung

1. Cloud-init Repo: Debian-Listen, Configs, SDDM, README, commit+push
2. Waybar: Kanagawa -> Catppuccin Mocha in modules-left.json
3. Dotfiles: pkgs/, scripts/, sddm/ löschen, README updaten
4. Dotfiles: Stow -> Chezmoi Konvertierung
5. Dotfiles: README final, commit+push
