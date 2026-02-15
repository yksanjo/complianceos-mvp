#!/bin/bash

# Script to completely reset Claude Code authentication
echo "Resetting Claude Code authentication..."

# Remove configuration files
echo "Removing configuration files..."
rm -rf ~/.claude ~/.claude.json ~/.claude.json.backup* 2>/dev/null

# Remove desktop app preferences (if exists)
echo "Removing desktop app preferences..."
rm -f ~/Library/Preferences/com.anthropic.claudefordesktop.plist 2>/dev/null

# Clear any environment variables (informational)
echo ""
echo "To clear environment variables, check your shell configuration files:"
echo "  ~/.bashrc, ~/.zshrc, ~/.bash_profile, ~/.profile, ~/.zshenv"
echo ""
echo "Look for lines containing:"
echo "  ANTHROPIC_API_KEY"
echo "  CLAUDE_API_KEY"
echo "  export ANTHROPIC"
echo ""
echo "Claude Code has been reset. When you run 'claude' again, it will prompt"
echo "you to log in fresh or enter an API key."
echo ""
echo "If you want to switch to using an API key instead of OAuth login,"
echo "you can set it as an environment variable:"
echo ""
echo "  export ANTHROPIC_API_KEY='your-api-key-here'"
echo ""
echo "Or you can enter it when Claude Code prompts you for it."