#!/bin/bash

echo "☢️  NUCLEAR RESTART - Complete Telegram Bot Reset"
echo "================================================="

# Backup current config
echo "1. Backing up current configuration..."
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup.$(date +%s)
cp ~/.openclaw/clawdbot.json ~/.openclaw/clawdbot.json.backup.$(date +%s)

# Kill everything
echo "2. Stopping all OpenClaw processes..."
pkill -9 -f "openclaw" 2>/dev/null
sleep 2

# Remove launch agent
echo "3. Removing launch agent..."
launchctl bootout gui/$UID/ai.openclaw.gateway 2>/dev/null
rm -f ~/Library/LaunchAgents/ai.openclaw.gateway.plist 2>/dev/null

# Create clean config
echo "4. Creating clean configuration..."
cat > ~/.openclaw/openclaw.json << 'EOF'
{
  "meta": {
    "lastTouchedVersion": "2026.1.29",
    "lastTouchedAt": "2026-02-01T03:05:00.000Z"
  },
  "gateway": {
    "mode": "local"
  },
  "channels": {
    "telegram": {
      "enabled": true,
      "dmPolicy": "pairing",
      "botToken": "8208452855:AAGdgNAUCJ6Lgq_un5Lh86iTW8XTbHc12Lg",
      "groups": {
        "*": {
          "requireMention": true
        }
      },
      "groupPolicy": "allowlist",
      "streamMode": "partial"
    }
  },
  "plugins": {
    "entries": {
      "telegram": {
        "enabled": true
      }
    }
  }
}
EOF

# Start fresh
echo "5. Starting fresh gateway..."
openclaw gateway install 2>&1 | grep -v "already loaded"
openclaw gateway start 2>&1

echo "6. Waiting for startup..."
sleep 5

echo ""
echo "7. Checking status..."
if pgrep -f "openclaw-gateway" > /dev/null; then
    echo "   ✅ Gateway is RUNNING"
    
    # Check Telegram specifically
    echo ""
    echo "8. Testing Telegram connection..."
    
    # Test bot token
    BOT_TOKEN="8208452855:AAGdgNAUCJ6Lgq_un5Lh86iTW8XTbHc12Lg"
    TEST=$(curl -s "https://api.telegram.org/bot${BOT_TOKEN}/getMe")
    if echo "$TEST" | grep -q '"ok":true'; then
        echo "   ✅ Telegram bot token is VALID"
        
        # Check if bot is receiving messages
        UPDATES=$(curl -s "https://api.telegram.org/bot${BOT_TOKEN}/getUpdates")
        if echo "$UPDATES" | grep -q '"result":\[\]'; then
            echo "   ✅ Bot is ready to receive messages"
        else
            echo "   ⚠️  Bot has pending updates"
        fi
    else
        echo "   ❌ Telegram bot token is INVALID"
    fi
    
    echo ""
    echo "📱 TEST YOUR BOT NOW:"
    echo "1. Open Telegram"
    echo "2. Message @Omamoribotbot"
    echo "3. Send: /start"
    echo ""
    echo "If it doesn't work, check logs:"
    echo "tail -f /tmp/openclaw/openclaw-*.log 2>/dev/null"
    
else
    echo "   ❌ Gateway FAILED to start"
    echo ""
    echo "Check error logs:"
    tail -20 ~/.openclaw/logs/gateway.err.log 2>/dev/null
fi

echo ""
echo "================================================="
echo "Backup files created:"
echo "- ~/.openclaw/openclaw.json.backup.*"
echo "- ~/.openclaw/clawdbot.json.backup.*"
echo "================================================="