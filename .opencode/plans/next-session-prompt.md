# Prompt für nächste Session

Kopiere den folgenden Block als ersten Prompt:

---

## Kontext

Ich habe in der letzten Session mein dotfiles-Setup komplett umgebaut:

- **chezmoi** (`git@github.com:florianfeigl/chezmoi.git`): Von GNU Stow auf chezmoi migriert. Chezmoi Source liegt unter `~/.local/share/chezmoi/`. Catppuccin Macchiato als globales Theme. Alacritty ist Standard-Terminal.
- **cloud-init** (`git@github.com:florianfeigl/cloud-init.git`): Neues Repo für Maschinenprovisioning mit Paketlisten (Arch + Debian), cloud-init YAMLs und einem `bootstrap.sh` Script. Lokaler Klon liegt aktuell noch unter `~/src/Grive/Repositories/cloud-init/`, soll nach `~/repos/cloud-init/` verschoben werden.
- **rclone**: `~/src/Grive` und `~/src/Proton` sind per rclone mit Cloud-Remotes `Grive:` und `Proton:` verbunden. Ich will den Sync abschalten und nur noch bei Bedarf Dateien hoch/runterladen. Davor brauche ich einen finalen bidirektionalen Abgleich.

## Offene Aufgaben

### 1. rclone bisync -- finaler Abgleich

Bevor ich den dauerhaften Sync abschalte, muss sichergestellt sein, dass lokal und remote die jeweils neueste Version jeder Datei vorliegt. Die rclone Remotes heissen `Grive:` und `Proton:` (NICHT `remote:`). Lokale Pfade: `~/src/Grive` und `~/src/Proton`.

Vorgehen:
1. Dry-Run: `rclone bisync ~/src/Grive Grive: --dry-run --verbose`
2. Bei Problemen analysieren, dann `--resync` für den ersten echten Lauf
3. Dasselbe für Proton
4. Danach den automatischen Sync deaktivieren (systemd timer/cron, was auch immer aktiv ist)

### 2. Verzeichnisstruktur aufräumen

- `~/src/Grive/Repositories/cloud-init/` nach `~/repos/cloud-init/` verschieben (git remote bleibt gleich)
- Nach dem rclone-Abgleich: `~/src/Grive/` und `~/src/Proton/` Verzeichnisse evaluieren -- was kann weg, was bleibt
- Ziel: `~/repos/` als einziges Repo-Verzeichnis

### 3. Starship updaten

Aktuelle Version ist 1.24.1, 1.24.2 behebt git_status Bugs mit gitoxide. Einfach: `sudo pacman -S starship`

### 4. Debian-Arbeitsplatz migrieren

Auf dem Debian-System in der Arbeit liegen noch Stow-Symlinks. Migration:
```sh
chezmoi init git@github.com:florianfeigl/chezmoi.git
cd $(chezmoi source-path)
./migrate.sh
chezmoi apply
swaymsg reload
```

Das `.chezmoiignore` sorgt dafür, dass Hyprland/Waybar auf Debian übersprungen und Sway deployed wird.

## Wichtige Regeln

- Führe keine destruktiven oder prozessverändernden Shell-Befehle selbst aus. Gib mir die Befehle als Text, ich führe sie aus. Das gilt für: kill, systemctl, rm auf Home-Verzeichnisse, rclone sync/bisync, chsh, etc.
- Datei-Operationen in Repos (read, edit, write, git) darfst du selbst ausführen.
- Dotfiles werden ausschliesslich über chezmoi verwaltet. Source: `~/.local/share/chezmoi/`. Workflow: edit -> commit -> push -> chezmoi update auf anderen Systemen.
- Cloud-init Repo: `~/repos/cloud-init/` (nach der Verschiebung).

---
