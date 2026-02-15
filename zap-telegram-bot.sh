#!/bin/bash

echo "⚡ ZAPPING Telegram Bot - Complete Restart"
echo "=========================================="

BOT_TOKEN="8208452855:AAGdgNAUCJ6Lgq_un5Lh86iTW8XTbHc12Lg"

echo ""
echo "1. Killing all OpenClaw processes..."
pkill -f "openclaw-gateway" 2>/dev/null
pkill -f "openclaw gateway" 2>/dev/null
sleep 2

echo "2. Checking if processes are gone..."
if pgrep -f "openclaw" > /dev/null; then
    echo "   ⚠️  Some OpenClaw processes still running, forcing kill..."
    pkill -9 -f "openclaw" 2>/dev/null
    sleep 1
fi

echo "3. Starting fresh OpenClaw gateway..."
openclaw gateway stop 2>/dev/null
openclaw gateway install 2>/dev/null
openclaw gateway start 2>/dev/null

echo "4. Waiting for gateway to start..."
sleep 5

echo "5. Checking gateway status..."
if pgrep -f "openclaw-gateway" > /dev/null; then
    echo "   ✅ Gateway is RUNNING"
    
    # Get the PID
    PID=$(pgrep -f "openclaw-gateway")
    echo "   PID: $PID"
    
    # Check recent logs for Telegram
    echo ""
    echo "6. Checking Telegram connection..."
    sleep 3
    
    # Look for Telegram in recent logs
    if tail -50 /tmp/openclaw/openclaw-*.log 2>/dev/null | grep -q "telegram\|Telegram"; then
        echo "   ✅ Telegram activity detected in logs"
    else
        echo "   ⚠️  No recent Telegram activity in logs"
        echo "   Checking configuration..."
        
        # Verify token in config
        if grep -q "$BOT_TOKEN" ~/.openclaw/clawdbot.json; then
            echo "   ✅ Bot token found in configuration"
        else
            echo "   ❌ Bot token NOT found in configuration!"
        fi
    fi
    
else
    echo "   ❌ Gateway FAILED to start"
    echo ""
    echo "   Checking logs for errors..."
    tail -20 ~/.openclaw/logs/gateway.err.log 2>/dev/null | head -10
fi

echo ""
echo "7. Testing Telegram bot token..."
TEST_RESULT=$(curl -s "https://api.telegram.org/bot${BOT_TOKEN}/getMe")
if echo "$TEST_RESULT" | grep -q '"ok":true'; then
    echo "   ✅ Telegram bot token is VALID"
    BOT_NAME=$(echo "$TEST_RESULT" | grep -o '"first_name":"[^"]*"' | cut -d'"' -f4)
    BOT_USERNAME=$(echo "$TEST_RESULT" | grep -o '"username":"[^"]*"' | cut -d'"' -f4)
    echo "   🤖 Bot: $BOT_NAME (@$BOT_USERNAME)"
else
    echo "   ❌ Telegram bot token is INVALID"
    echo "   Response: $TEST_RESULT"
fi

echo ""
echo "8. Checking for pending Telegram updates..."
UPDATES=$(curl -s "https://api.telegram.org/bot${BOT_TOKEN}/getUpdates")
if echo "$UPDATES" | grep -q '"result":\[\]'; then
    echo "   ✅ No pending updates (bot is processing messages)"
else
    echo "   ⚠️  Pending updates found (bot may not be processing)"
fi

echo ""
echo "=========================================="
echo "📱 Test Your Bot Now:"
echo "1. Open Telegram"
echo "2. Message @Omamoribotbot"
echo "3. Send /start or any message"
echo ""
echo "📊 Monitor logs in real-time:"
echo "tail -f /tmp/openclaw/openclaw-*.log 2>/dev/null | grep -i telegram"
echo "=========================================="