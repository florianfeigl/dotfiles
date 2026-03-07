# OpenCode Agent Configuration

This document describes the configuration and usage of AI agents (opencode) in this dotfiles repository.

## Project Structure

```
chezmoi/
├── dot_config/          # System configuration files
├── ai-statistics/       # AI assistance metrics and session logs
├── docs/               # Documentation
├── sessions/           # Session transcripts
└── AGENTS.md          # This file
```

## AI Assistance Documentation System

### Automatic Documentation
- **Git Hooks**: Pre-commit hooks automatically document AI-assisted changes
- **Session Logs**: Each AI session creates a markdown file in `ai-statistics/sessions/`
- **Metrics**: Monthly performance metrics are tracked in `ai-statistics/metrics/`

### Git Hook
The `.git/hooks/pre-commit` hook:
1. Detects changes to Waybar configuration files
2. Creates automatic documentation in `ai-statistics/sessions/YYYY-MM-DD-description.md`
3. Adds documentation to the commit automatically

### Manual Documentation
For significant AI-assisted work, create a session summary in `sessions/YYYY-MM-DD-session-summary.md`

## Agent Instructions

### When Working with This Repository

1. **Always check existing patterns**:
   - Review similar files for coding conventions
   - Follow existing directory structure
   - Use consistent naming patterns

2. **Documentation requirements**:
   - Document AI-assisted changes automatically via git hooks
   - Update `docs/ai-assistance.md` for significant work
   - Create session summaries for complex tasks

3. **Testing requirements**:
   - Test configuration changes (e.g., restart Waybar for icon changes)
   - Verify font availability for icon changes: `fc-match "MesloLGS Nerd Font Mono"`
   - Check system logs for errors

4. **Commit conventions**:
   - Use conventional commit messages
   - Group related changes together
   - Include clear descriptions of what changed and why

### Common Tasks

#### Waybar Configuration
- Icons use Nerd Font symbols (Material Design Icons)
- Font verification: `fc-match "MesloLGS Nerd Font Mono"`
- Restart Waybar after changes: `systemctl --user restart waybar`
- Check logs: `journalctl --user -u waybar -n 20`

#### Neovim Configuration
- Uses lazy.nvim plugin manager
- Plugin specifications in `dot_config/nvim/lua/plugins/*.lua`
- Aggregate all plugins in `dot_config/nvim/lua/plugins/init.lua`

#### Dotfiles Management
- Managed with chezmoi
- Apply changes: `chezmoi apply`
- Tracked files in repository root under `dot_*` directories

## Best Practices

1. **Configuration consistency**: Always verify configuration files match between chezmoi templates and actual config
2. **Font dependencies**: Check font availability before using special icons
3. **System integration**: Test changes in actual environment, not just repository
4. **Error handling**: Check system logs for errors after applying changes
5. **Documentation**: Always document AI assistance for reproducibility

## Session Guidelines

When starting a new AI-assisted session:
1. Identify the specific task or problem
2. Check existing documentation for similar work
3. Follow the established patterns and conventions
4. Document the process and results
5. Verify the solution works in the actual environment

## Useful Commands

```bash
# Waybar
systemctl --user restart waybar
journalctl --user -u waybar -n 20
fc-match "MesloLGS Nerd Font Mono"

# Neovim
nvim +Lazy sync

# Chezmoi
chezmoi apply
chezmoi diff

# Git
git status
git diff
git add -p
```

## Troubleshooting

### Icons Not Displaying
1. Verify Nerd Font is installed: `fc-match "MesloLGS Nerd Font Mono"`
2. Check Waybar logs for errors
3. Ensure correct icon codes (use Nerd Font cheat sheet)
4. Restart Waybar after configuration changes

### Configuration Not Applying
1. Check if chezmoi needs to apply changes
2. Verify file paths match between repository and home directory
3. Look for syntax errors in configuration files
4. Check system logs for specific error messages

### Plugin Issues
1. Check nvim logs: `nvim +messages`
2. Verify lazy.nvim can access plugins
3. Check network connectivity for plugin downloads
4. Review plugin specifications for correct syntax