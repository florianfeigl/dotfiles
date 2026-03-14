# Index - Chezmoi Configuration Files

**Current Location:** `~/.local/share/chezmoi/`  
**Recommended Target:** `~/repos/chezmoi/`  
**Date Generated:** 2026-03-15

---

## 📋 Documentation Files

Start here depending on your situation:

### For Fresh Installation
👉 **Read:** `SETUP-INSTRUCTIONS.md`
- Step-by-step setup with `~/repos/chezmoi` as source
- Post-installation checklist
- Quick start command

### For System Recovery
👉 **Read:** `RECOVERY-NOTE.md`
- What happened during the optimization session
- All files that were created/modified
- Step-by-step recovery procedure
- Git commit templates

### For Dependency Management
👉 **Read:** `INFO-CLOUD-INIT.md`
- Complete dependency lists (Arch + Debian)
- Installation instructions for all tools
- Kanata setup (keyboard remapper)
- Troubleshooting guide
- Locale configuration

### For Daily Use
👉 **Read:** `README.md`
- Chezmoi workflow commands
- File organization
- Distro-specific configurations

---

## 🔧 Configuration Files

### Optimized in this Session

| File | Changes | Lines | Notes |
|------|---------|-------|-------|
| `dot_config/kanata/config.kbd` | Enhanced documentation | 122 | Comprehensive comments, timing config, expansion notes |
| `dot_config/systemd/user/kanata.service` | Logging + priority | 28 | Systemd journal integration, high priority for input |
| `.chezmoi.toml.tmpl` | Added sourceDir | 4 | Configured for ~/repos/chezmoi |
| `README.md` | Added custom init | 141 | Installation instructions with --source flag |

### Existing Files
- `.chezmoiignore` - Distro-specific excludes (Arch/Debian)
- `AGENTS.md` - AI agent configuration
- `migrate.sh` - Migration script from GNU Stow

---

## 📂 Directory Structure

```
~/.local/share/chezmoi/
├── dot_config/
│   ├── alacritty/           # Terminal emulator
│   ├── ghostty/             # Terminal emulator
│   ├── kitty/               # Terminal emulator
│   ├── fuzzel/              # App launcher
│   ├── hypr/                # Hyprland (Arch only)
│   ├── sway/                # Sway (Debian only)
│   ├── waybar/              # Status bar
│   ├── kanata/              # ✅ OPTIMIZED
│   ├── systemd/user/        # ✅ OPTIMIZED
│   ├── nvim/                # Neovim + plugins
│   ├── yazi/                # File manager
│   ├── mimeapps.list        # App associations
│   └── [other configs]
│
├── dot_zshrc                # Shell config
├── dot_tmux.conf            # Tmux config
├── dot_gitconfig            # Git config
├── dot_vimrc                # Vim config
│
├── .chezmoi.toml.tmpl       # ✅ CONFIGURED
├── .chezmoiignore           # Distro-specific excludes
├── .git/                    # Git repository
│
└── Documentation/
    ├── INDEX.md             # ← You are here
    ├── SETUP-INSTRUCTIONS.md
    ├── RECOVERY-NOTE.md
    ├── INFO-CLOUD-INIT.md
    └── README.md
```

---

## 🚀 Quick Reference

### Fresh Install
```bash
mkdir -p ~/repos
chezmoi init git@github.com:florianfeigl/chezmoi.git \
  --source ~/repos/chezmoi \
  --apply
```

### Daily Use
```bash
chezmoi update          # Pull + apply
chezmoi edit ~/.zshrc   # Edit file
chezmoi diff            # Preview changes
chezmoi cd              # cd into source
```

### Recovery
```bash
# See RECOVERY-NOTE.md for full procedure
cd ~/.local/share/chezmoi
cat RECOVERY-NOTE.md
```

### Dependencies
```bash
# See INFO-CLOUD-INIT.md for details
# Arch: pacman -S --needed - < ~/repos/cloud-init/pkgs/arch/base.lst
# Debian: xargs apt-get install -y < ~/repos/cloud-init/pkgs/debian/base.lst
```

---

## ✅ What Was Accomplished

### Session: 2026-03-15

#### Phase 1: Kanata Optimization
- ✅ Enhanced configuration with comprehensive documentation
- ✅ Optimized systemd service with proper logging and priorities
- ✅ Added expansion notes for future features

#### Phase 2: Waybar Diagnostics
- ✅ Identified root cause: Locale not set in user session
- ✅ Documented solution in INFO-CLOUD-INIT.md

#### Phase 3: Dependency Documentation
- ✅ Created 555-line comprehensive INFO.md
- ✅ Included installation instructions for all distros
- ✅ Added extensive troubleshooting section

#### Phase 4: Configuration
- ✅ Set sourceDir to ~/repos/chezmoi
- ✅ Updated README with custom init command
- ✅ Created recovery guide
- ✅ Created setup instructions

---

## 📍 File Locations After Recovery

After following the RECOVERY-NOTE.md procedure:

```
~/repos/
├── chezmoi/           # ← Main source directory
│   ├── dot_config/
│   ├── README.md      # With updated init instructions
│   ├── .chezmoi.toml.tmpl
│   └── .git/
│
└── cloud-init/        # ← Dependencies
    ├── INFO.md        # Copied from INFO-CLOUD-INIT.md
    ├── pkgs/
    └── .git/

~/.local/share/chezmoi/
└── [Managed by chezmoi, syncs with ~/repos/chezmoi]

$HOME/
├── .zshrc             # Deployed from chezmoi
├── .tmux.conf         # Deployed from chezmoi
├── .gitconfig         # Deployed from chezmoi
└── .config/           # Deployed from chezmoi
    ├── kanata/
    ├── waybar/
    ├── nvim/
    └── [etc]
```

---

## 🔗 Related Repositories

- **Chezmoi Dotfiles:** https://github.com/florianfeigl/chezmoi
- **Cloud-Init (Dependencies):** https://github.com/florianfeigl/cloud-init

---

## 📝 Notes

- All optimizations are backward-compatible
- Configuration supports both Arch Linux and Debian/Ubuntu
- Kanata is marked as critical dependency (source installation)
- Locale flexible (not hardcoded, but documented)
- NPM tracked as runtime only (no specific packages)

---

**Last Updated:** 2026-03-15  
**Status:** ✅ Ready for Recovery and Deployment
