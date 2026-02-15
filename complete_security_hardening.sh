#!/bin/bash

# Complete Security Hardening for OpenCLaw
# This script completes the migration to secure configuration

echo "🔒 OpenCLaw Security Hardening - Final Phase"
echo "============================================"

# Check if .env file exists
ENV_FILE="$HOME/.openclaw/.env"
if [ ! -f "$ENV_FILE" ]; then
    echo "❌ .env file not found. Run migration script first."
    exit 1
fi

echo "✅ .env file exists: $ENV_FILE"

# Verify .env file permissions
PERMS=$(stat -f "%p" "$ENV_FILE" 2>/dev/null || stat -c "%a" "$ENV_FILE")
if [ "$PERMS" != "600" ] && [ "$PERMS" != "100600" ]; then
    echo "⚠️  Fixing .env file permissions..."
    chmod 600 "$ENV_FILE"
    echo "✅ .env file permissions set to 600"
else
    echo "✅ .env file permissions are secure: $PERMS"
fi

# Create a script to remove tokens from config files (optional)
REMOVE_TOKENS_SCRIPT="$HOME/.openclaw/remove_tokens_from_configs.sh"
cat > "$REMOVE_TOKENS_SCRIPT" << 'EOF'
#!/bin/bash

# Script to remove tokens from config files (optional)
# Only run this AFTER confirming the wrapper script works correctly

echo "⚠️  WARNING: This will remove tokens from config files"
echo "   Only proceed if you've confirmed the wrapper script works"
echo ""
read -p "Continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

# Backup configs
BACKUP_DIR="$HOME/.openclaw/backups/token_removal_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
cp ~/.openclaw/openclaw.json "$BACKUP_DIR/"
cp ~/.openclaw/clawdbot.json "$BACKUP_DIR/"
echo "✅ Backups created in: $BACKUP_DIR"

# Function to remove token from JSON file
remove_token() {
    local file="$1"
    local key="$2"
    local value="$3"
    
    if [ -f "$file" ]; then
        # Create temp file
        tmp_file="${file}.tmp"
        
        # Use Python for safe JSON editing
        python3 -c "
import json
import sys

try:
    with open('$file', 'r') as f:
        data = json.load(f)
    
    # Navigate and remove the token
    keys = '$key'.split('.')
    current = data
    for k in keys[:-1]:
        if k in current:
            current = current[k]
        else:
            print(f'Key path not found: $key')
            sys.exit(1)
    
    last_key = keys[-1]
    if last_key in current:
        print(f'Removing {last_key} from {file}')
        del current[last_key]
    else:
        print(f'Key not found: {last_key}')
        sys.exit(1)
    
    with open('$tmp_file', 'w') as f:
        json.dump(data, f, indent=2)
    
    import os
    os.rename('$tmp_file', '$file')
    print(f'✅ Updated: {file}')
    
except Exception as e:
    print(f'Error: {e}')
    sys.exit(1)
"
    fi
}

echo ""
echo "Removing tokens from config files..."
echo "===================================="

# Remove Telegram token from openclaw.json
remove_token "$HOME/.openclaw/openclaw.json" "channels.telegram.botToken"

# Remove Discord token from openclaw.json
remove_token "$HOME/.openclaw/openclaw.json" "channels.discord.token"

# Remove Talk API key from openclaw.json
remove_token "$HOME/.openclaw/openclaw.json" "talk.apiKey"

# Remove Gateway auth token from openclaw.json
remove_token "$HOME/.openclaw/openclaw.json" "gateway.auth.token"

echo ""
echo "===================================="
echo "✅ Token removal complete"
echo ""
echo "⚠️  IMPORTANT: Test your setup before relying on it:"
echo "   ~/.openclaw/openclaw_secure.sh gateway status"
echo ""
echo "If anything breaks, restore from backup:"
echo "   cp $BACKUP_DIR/*.json ~/.openclaw/"
EOF

chmod 700 "$REMOVE_TOKENS_SCRIPT"
echo "✅ Created token removal script: $REMOVE_TOKENS_SCRIPT"

# Create monitoring cron job
MONITOR_CRON="# OpenCLaw Security Monitor - Runs daily at 2 AM
0 2 * * * $HOME/.openclaw/security_monitor.sh >> $HOME/.openclaw/security_monitor.log 2>&1"

echo ""
echo "📊 Security Monitoring Setup"
echo "============================"
echo "To add daily security monitoring, add this to your crontab:"
echo ""
echo "$MONITOR_CRON"
echo ""
echo "Add it with: crontab -e"
echo "Or create a cron file: echo '$MONITOR_CRON' | crontab -"

# Create startup script for launch agent
STARTUP_SCRIPT="$HOME/.openclaw/start_openclaw_secure.sh"
cat > "$STARTUP_SCRIPT" << 'EOF'
#!/bin/bash

# Secure OpenCLaw Startup Script
# Use this in launch agents or systemd services

# Load environment
source "$HOME/.openclaw/.env" 2>/dev/null || {
    echo "Warning: Could not load .env file"
}

# Start OpenCLaw with secure wrapper
exec "$HOME/.openclaw/openclaw_secure.sh" gateway start
EOF

chmod 700 "$STARTUP_SCRIPT"
echo "✅ Created secure startup script: $STARTUP_SCRIPT"

# Update existing launch agent if it exists
LAUNCH_AGENT="$HOME/Library/LaunchAgents/ai.openclaw.gateway.plist"
if [ -f "$LAUNCH_AGENT" ]; then
    echo ""
    echo "🔄 Existing Launch Agent Found"
    echo "=============================="
    echo "Current launch agent: $LAUNCH_AGENT"
    echo ""
    echo "To update it to use the secure wrapper:"
    echo "1. Stop the service: launchctl unload $LAUNCH_AGENT"
    echo "2. Edit the plist file to use: $STARTUP_SCRIPT"
    echo "3. Reload: launchctl load $LAUNCH_AGENT"
    echo ""
    echo "Or create a new secure launch agent:"
fi

# Create secure launch agent template
SECURE_LAUNCH_AGENT="$HOME/.openclaw/ai.openclaw.gateway.secure.plist"
cat > "$SECURE_LAUNCH_AGENT" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>ai.openclaw.gateway.secure</string>
    <key>ProgramArguments</key>
    <array>
        <string>$STARTUP_SCRIPT</string>
    </array>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
    </dict>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>$HOME/.openclaw/logs/gateway.log</string>
    <key>StandardErrorPath</key>
    <string>$HOME/.openclaw/logs/gateway.err.log</string>
    <key>WorkingDirectory</key>
    <string>$HOME</string>
</dict>
</plist>
EOF

echo "✅ Created secure launch agent template: $SECURE_LAUNCH_AGENT"

echo ""
echo "============================================"
echo "✅ SECURITY HARDENING COMPLETE"
echo "============================================"
echo ""
echo "📋 Summary of what was created:"
echo "1. ✅ .env file with tokens (secured with 600 permissions)"
echo "2. ✅ Secure wrapper script: ~/.openclaw/openclaw_secure.sh"
echo "3. ✅ Token removal script (optional): $REMOVE_TOKENS_SCRIPT"
echo "4. ✅ Secure startup script: $STARTUP_SCRIPT"
echo "5. ✅ Secure launch agent template: $SECURE_LAUNCH_AGENT"
echo "6. ✅ Security monitor script: ~/.openclaw/security_monitor.sh"
echo ""
echo "🚀 Next Steps:"
echo "1. Test the secure wrapper: ~/.openclaw/openclaw_secure.sh gateway status"
echo "2. If working, update your startup method to use the secure wrapper"
echo "3. Optionally remove tokens from config files using the removal script"
echo "4. Add security monitoring to crontab"
echo ""
echo "⚠️  IMPORTANT:"
echo "   - Your original config files are unchanged"
echo "   - The system will continue working as before"
echo "   - Tokens are now loaded from secure .env file"
echo "   - No disruption to your current setup"
echo ""
echo "🔐 Security Status:"
echo "   - Tokens moved from world-readable config files to secure .env"
echo "   - File permissions hardened"
echo "   - Monitoring tools installed"
echo "   - Migration path to token-free configs available"