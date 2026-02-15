#!/bin/bash

# Fix Openclaw service not starting

echo "🔧 Fixing Openclaw Service"
echo "=========================="

# Stop the broken service
echo "🛑 Stopping broken Openclaw service..."
launchctl unload ~/Library/LaunchAgents/ai.openclaw.gateway.secure.plist 2>/dev/null
sleep 2

# Check if openclaw command exists
echo "🔍 Checking Openclaw installation..."
if ! command -v openclaw &> /dev/null; then
    echo "❌ Openclaw command not found in PATH"
    echo "   Current PATH: $PATH"
    echo "   Trying to find openclaw..."
    find /opt -name "openclaw" 2>/dev/null | head -5
    find /usr/local -name "openclaw" 2>/dev/null | head -5
    echo ""
    echo "📦 You may need to install Openclaw:"
    echo "   brew install openclaw/tap/openclaw"
    exit 1
else
    echo "✅ Openclaw found at: $(which openclaw)"
fi

# Create a fixed launch agent
echo ""
echo "📝 Creating fixed launch agent..."
cat > ~/Library/LaunchAgents/ai.openclaw.gateway.fixed.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>ai.openclaw.gateway.fixed</string>
    <key>ProgramArguments</key>
    <array>
        <string>/opt/homebrew/bin/openclaw</string>
        <string>gateway</string>
        <string>start</string>
        <string>--port</string>
        <string>18789</string>
    </array>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
        <key>HOME</key>
        <string>/Users/yoshikondo</string>
    </dict>
    <key>WorkingDirectory</key>
    <string>/Users/yoshikondo/.openclaw</string>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/Users/yoshikondo/.openclaw/logs/gateway.out.log</string>
    <key>StandardErrorPath</key>
    <string>/Users/yoshikondo/.openclaw/logs/gateway.err.log</string>
</dict>
</plist>
EOF

echo "✅ Fixed launch agent created"

# Create logs directory
mkdir -p ~/.openclaw/logs

# Start the fixed service
echo ""
echo "🚀 Starting fixed Openclaw service..."
launchctl load ~/Library/LaunchAgents/ai.openclaw.gateway.fixed.plist
sleep 3

# Check if it's running
echo ""
echo "🔍 Checking service status..."
if launchctl list | grep -q "ai.openclaw.gateway.fixed"; then
    echo "✅ Service is running!"
    
    # Wait a bit and check if gateway is accessible
    echo "🌐 Testing gateway on port 18789..."
    sleep 2
    if curl -s "http://localhost:18789" > /dev/null 2>&1; then
        echo "✅ Gateway is accessible at http://localhost:18789"
    else
        echo "⚠️  Gateway not responding yet, checking logs..."
        tail -10 ~/.openclaw/logs/gateway.err.log 2>/dev/null || echo "No error log yet"
    fi
else
    echo "❌ Service failed to start"
    echo "Check logs: tail -f ~/.openclaw/logs/gateway.err.log"
fi

echo ""
echo "📋 Summary:"
echo "----------"
echo "1. Stopped broken service"
echo "2. Created fixed launch agent: ~/Library/LaunchAgents/ai.openclaw.gateway.fixed.plist"
echo "3. Started new service"
echo "4. Logs available at: ~/.openclaw/logs/"
echo ""
echo "🔗 Your Cloudflare worker URL: https://yksanjo-bot.yksanjo.workers.dev/"
echo "🔗 Health check: https://yksanjo-bot.yksanjo.workers.dev/health"
echo ""
echo "💡 To test Openclaw manually:"
echo "   openclaw gateway start --port 18789"
echo ""
echo "✅ Fix completed!"