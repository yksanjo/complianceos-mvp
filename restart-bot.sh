#!/bin/bash

echo "Restarting Telegram Bot..."
echo "========================="

# Check if OpenClaw is running
if pgrep -f "openclaw-gateway" > /dev/null; then
    echo "Stopping OpenClaw gateway..."
    openclaw gateway stop
    sleep 2
fi

# Update token if provided
if [ ! -z "$1" ]; then
    echo "Updating bot token to: $1"
    
    # Update clawdbot.json
    sed -i '' "s/YOUR_NEW_BOT_TOKEN_HERE/$1/g" ~/.openclaw/clawdbot.json 2>/dev/null
    sed -i '' "s/8517283723:AAElM9LwR-JFKoCKZAclXekegQs6gITBBqE/$1/g" ~/.openclaw/clawdbot.json 2>/dev/null
    
    # Update openclaw.json
    sed -i '' "s/YOUR_NEW_BOT_TOKEN_HERE/$1/g" ~/.openclaw/openclaw.json 2>/dev/null
    sed -i '' "s/8517283723:AAElM9LwR-JFKoCKZAclXekegQs6gITBBqE/$1/g" ~/.openclaw/openclaw.json 2>/dev/null
    
    echo "Token updated in configuration files."
fi

# Start OpenClaw gateway
echo "Starting OpenClaw gateway..."
openclaw gateway start

echo ""
echo "Bot should be restarting..."
echo "Check logs: tail -f ~/.openclaw/logs/gateway.log"
echo ""

# Wait a bit and check status
sleep 3
if pgrep -f "openclaw-gateway" > /dev/null; then
    echo "✅ OpenClaw gateway is running."
else
    echo "❌ OpenClaw gateway failed to start."
    echo "Check for errors: tail -50 ~/.openclaw/logs/gateway.err.log"
fi