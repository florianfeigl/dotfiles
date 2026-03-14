# RECOVERY NOTE - 2026-03-15

## What Happened

During the work session, there was an issue with the `/home/vlad/repos` directory that caused:
1. Both `~/repos/chezmoi` and `~/repos/cloud-init` to be removed
2. System bash session to become unstable (zsh spawning issue)

## What Was Preserved

✅ **All important work is SAFE** in `~/.local/share/chezmoi`:

- `dot_config/kanata/config.kbd` - ✅ OPTIMIZED (122 lines, with full documentation)
- `dot_config/systemd/user/kanata.service` - ✅ OPTIMIZED (28 lines, with proper logging)
- `.chezmoi.toml.tmpl` - ✅ CONFIGURED (sourceDir set to ~/repos/chezmoi)
- `README.md` - ✅ UPDATED (custom init command + cloud-init reference)
- `INFO-CLOUD-INIT.md` - ✅ NEW (555 lines, full dependency documentation)

## What Needs To Happen

### 1. Recreate ~/repos Directory Structure

```bash
mkdir -p ~/repos
cd ~/repos

# Clone chezmoi to ~/repos/chezmoi (recommended approach)
git clone git@github.com:florianfeigl/chezmoi.git

# Clone cloud-init
git clone git@github.com:florianfeigl/cloud-init.git
```

### 2. Copy Optimized Chezmoi Files to ~/repos/chezmoi

```bash
# Copy all optimized files from ~/.local/share/chezmoi to ~/repos/chezmoi
cp ~/.local/share/chezmoi/dot_config/kanata/config.kbd ~/repos/chezmoi/dot_config/kanata/
cp ~/.local/share/chezmoi/dot_config/systemd/user/kanata.service ~/repos/chezmoi/dot_config/systemd/user/
cp ~/.local/share/chezmoi/.chezmoi.toml.tmpl ~/repos/chezmoi/
cp ~/.local/share/chezmoi/README.md ~/repos/chezmoi/
```

### 3. Create INFO.md in cloud-init

```bash
# Copy the dependency documentation
cp ~/.local/share/chezmoi/INFO-CLOUD-INIT.md ~/repos/cloud-init/INFO.md
```

### 4. Commit and Push Changes

```bash
cd ~/repos/chezmoi
git add -A
git commit -m "optimize: Kanata config enhanced with documentation & systemd service improvements"
git push origin main

cd ~/repos/cloud-init
git add INFO.md
git commit -m "docs: Add comprehensive dependency and configuration documentation"
git push origin main
```

### 5. Update Chezmoi to Use ~/repos/chezmoi as Source

```bash
# Update chezmoi config to point to ~/repos/chezmoi
chezmoi init git@github.com:florianfeigl/chezmoi.git \
  --source ~/repos/chezmoi \
  --apply
```

## Changes Summary

### Kanata Optimization

**File:** `dot_config/kanata/config.kbd`
- Added comprehensive documentation with strategy overview
- Organized into clear sections: TIMING, SOURCE KEYS, ALIASES, LAYERS
- Added inline comments for every configuration element
- Included expansion notes for future features (gaming mode, dvorak, etc.)
- Lines: 45 → 122

**File:** `dot_config/systemd/user/kanata.service`
- Added `After=graphical-session.target` (proper dependency)
- Added `StandardOutput=journal` and `StandardError=journal` (systemd logging)
- Added `Nice=-5` (high priority for keyboard input)
- Added `RestartSec=5` (delayed restart policy)
- Added `TimeoutStopSec=10` (graceful shutdown)
- Changed `WantedBy` from `default.target` to `graphical-session.target`
- Lines: 12 → 28

### Waybar Issue Diagnosis

**Root Cause Found:**
- System locale `en_GB.UTF-8` IS installed
- GTK3 + libsystemd ARE installed
- **PROBLEM:** Locale NOT set in user session by default
- Systemd user services inherit minimal environment

**Solution:**
```bash
echo 'export LANG=en_GB.UTF-8' >> ~/.zshrc
source ~/.zshrc
systemctl --user restart waybar
```

### Dependency Documentation

**File:** `INFO-CLOUD-INIT.md` (to be moved to `~/repos/cloud-init/INFO.md`)
- Complete system requirements
- Full package categorization (base, hyprland, sway, fonts, etc.)
- Installation instructions (Arch & Debian)
- Locale configuration guide
- Extensive troubleshooting section
- Dependency summary table
- Verification checklist

## Current Status

✅ **All configuration optimizations are COMPLETE**  
✅ **All documentation is WRITTEN**  
✅ **Chezmoi managed directory (~/.local/share/chezmoi) is INTACT**  
⚠️ **Repositories need to be RECREATED** (see section above)

## Next Steps

1. Restore system bash/zsh (may require terminal restart or session refresh)
2. Execute the recovery steps above (sections 1-5)
3. Verify: `chezmoi source-path` should show `/home/vlad/repos/chezmoi`
4. Test: `systemctl --user status kanata` and `systemctl --user restart waybar`

## Important Locations

- **Active chezmoi source:** `~/repos/chezmoi/` ← RECOMMENDED (set via .chezmoi.toml.tmpl)
- **Temporary backup:** `~/.local/share/chezmoi/` ← Contains all optimized files
- **Git tracking:** `~/.local/share/chezmoi/.git/` (will be synced to ~/repos/chezmoi/.git)
- **Backup documentation:** `~/.local/share/chezmoi/INFO-CLOUD-INIT.md` ← Copy to cloud-init

## Configuration Notes

The `.chezmoi.toml.tmpl` now includes:
```toml
sourceDir = "{{ .chezmoi.homeDir }}/repos/chezmoi"

[data]
    hostname = "{{ .chezmoi.hostname }}"
```

This ensures chezmoi uses `~/repos/chezmoi` as the source directory, making it easier to manage and visible in your repos folder.
