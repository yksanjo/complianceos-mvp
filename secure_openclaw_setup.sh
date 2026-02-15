#!/bin/bash

# Secure OpenCLaw Setup Script
# This script helps migrate tokens to environment variables without disrupting service

echo "🔒 Secure OpenCLaw Setup"
echo "========================"

# Create backup of current config
BACKUP_DIR="$HOME/.openclaw/backups/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
cp ~/.openclaw/openclaw.json "$BACKUP_DIR/"
cp ~/.openclaw/clawdbot.json "$BACKUP_DIR/"
echo "✅ Backups created in: $BACKUP_DIR"

# Create environment variable template
ENV_FILE="$HOME/.openclaw/.env.template"
cat > "$ENV_FILE" << 'EOF'
# OpenCLaw Secure Environment Variables
# Copy this to ~/.openclaw/.env and fill in your tokens
# Then run: source ~/.openclaw/.env

# Telegram Bot Token
export TELEGRAM_BOT_TOKEN="YOUR_TELEGRAM_BOT_TOKEN_HERE"

# Discord Bot Token  
export DISCORD_BOT_TOKEN="YOUR_DISCORD_BOT_TOKEN_HERE"

# Talk API Key
export TALK_API_KEY="YOUR_TALK_API_KEY_HERE"

# Gateway Auth Token
export GATEWAY_AUTH_TOKEN="YOUR_GATEWAY_AUTH_TOKEN_HERE"

# DeepSeek API Key (if using)
export DEEPSEEK_API_KEY="YOUR_DEEPSEEK_API_KEY_HERE"

# Qwen Portal Auth (if using)
export QWEN_PORTAL_AUTH="YOUR_QWEN_PORTAL_AUTH_HERE"
EOF

chmod 600 "$ENV_FILE"
echo "✅ Environment template created: $ENV_FILE"

# Create a secure loader script
LOADER_SCRIPT="$HOME/.openclaw/secure_loader.sh"
cat > "$LOADER_SCRIPT" << 'EOF'
#!/bin/bash

# Secure OpenCLaw Loader
# Loads environment variables and starts OpenCLaw securely

# Load environment variables
if [ -f "$HOME/.openclaw/.env" ]; then
    source "$HOME/.openclaw/.env"
    echo "✅ Environment variables loaded"
else
    echo "⚠️  No .env file found. Using default configuration."
fi

# Start OpenCLaw with secure environment
exec openclaw "$@"
EOF

chmod 700 "$LOADER_SCRIPT"
echo "✅ Secure loader script created: $LOADER_SCRIPT"

# Create a monitoring script to check for exposed tokens
MONITOR_SCRIPT="$HOME/.openclaw/security_monitor.sh"
cat > "$MONITOR_SCRIPT" << 'EOF'
#!/bin/bash

# OpenCLaw Security Monitor
# Checks for exposed tokens and security issues

echo "🔍 OpenCLaw Security Check"
echo "=========================="

# Check file permissions
echo ""
echo "📁 File Permissions Check:"
find ~/.openclaw -name "*.json" -exec ls -la {} \; 2>/dev/null | while read line; do
    if echo "$line" | grep -q "^-rw-r--r--\|^-rw-rw-r--\|^-rwxr-xr-x"; then
        echo "⚠️  WARNING: World-readable file: $line"
    fi
done

# Check for exposed tokens in config files
echo ""
echo "🔑 Token Exposure Check:"
EXPOSED_COUNT=0
for file in ~/.openclaw/*.json; do
    if [ -f "$file" ]; then
        # Check for common token patterns
        if grep -q -E "(bot[0-9]+:[A-Za-z0-9_-]{35})|(sk_[a-zA-Z0-9]{48})|(MTQ[0-9A-Za-z._-]{59})" "$file"; then
            echo "❌ EXPOSED TOKENS FOUND in: $(basename "$file")"
            EXPOSED_COUNT=$((EXPOSED_COUNT + 1))
        fi
    fi
done

if [ $EXPOSED_COUNT -eq 0 ]; then
    echo "✅ No exposed tokens found in config files"
else
    echo "⚠️  Found $EXPOSED_COUNT files with potentially exposed tokens"
fi

# Check running processes
echo ""
echo "🔄 Process Check:"
if pgrep -f "openclaw" > /dev/null; then
    echo "✅ OpenCLaw is running"
else
    echo "⚠️  OpenCLaw is not running"
fi

# Check for .env file
echo ""
echo "🌐 Environment Configuration:"
if [ -f "$HOME/.openclaw/.env" ]; then
    echo "✅ Secure .env file exists"
    # Check if .env has real tokens (not placeholders)
    if grep -q "YOUR_.*_HERE" "$HOME/.openclaw/.env"; then
        echo "⚠️  .env file contains placeholder values"
    else
        echo "✅ .env file appears to have real tokens"
    fi
else
    echo "❌ No .env file found. Tokens may be exposed in config files."
fi

echo ""
echo "========================================"
echo "📋 Recommendations:"
echo "1. Move tokens to ~/.openclaw/.env file"
echo "2. Update config files to use environment variables"
echo "3. Restrict file permissions: chmod 600 ~/.openclaw/*.json"
echo "4. Regularly run this monitor script"
EOF

chmod 700 "$MONITOR_SCRIPT"
echo "✅ Security monitor script created: $MONITOR_SCRIPT"

echo ""
echo "========================================"
echo "📋 Next Steps (NON-DISRUPTIVE):"
echo "1. Edit ~/.openclaw/.env.template with your actual tokens"
echo "2. Rename it to ~/.openclaw/.env"
echo "3. Run the security monitor: ~/.openclaw/security_monitor.sh"
echo "4. Use the secure loader: ~/.openclaw/secure_loader.sh start"
echo ""
echo "⚠️  IMPORTANT: Do NOT delete your current config files yet."
echo "   The system will continue working with the old configs."
echo "   We'll migrate gradually to avoid disruption."
echo "========================================"