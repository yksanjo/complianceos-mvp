#!/bin/bash

echo "🔍 Verifying Telegram Bot Pairing Status"
echo "========================================"

BOT_TOKEN="8208452855:AAGdgNAUCJ6Lgq_un5Lh86iTW8XTbHc12Lg"

echo ""
echo "1. Testing Bot Token..."
BOT_INFO=$(curl -s "https://api.telegram.org/bot${BOT_TOKEN}/getMe")
if echo "$BOT_INFO" | grep -q '"ok":true'; then
    echo "   ✅ Token is VALID"
    BOT_NAME=$(echo "$BOT_INFO" | grep -o '"first_name":"[^"]*"' | cut -d'"' -f4)
    BOT_USERNAME=$(echo "$BOT_INFO" | grep -o '"username":"[^"]*"' | cut -d'"' -f4)
    echo "   🤖 Bot: $BOT_NAME (@$BOT_USERNAME)"
else
    echo "   ❌ Token is INVALID"
    exit 1
fi

echo ""
echo "2. Checking Webhook Status..."
WEBHOOK_INFO=$(curl -s "https://api.telegram.org/bot${BOT_TOKEN}/getWebhookInfo")
WEBHOOK_URL=$(echo "$WEBHOOK_INFO" | grep -o '"url":"[^"]*"' | cut -d'"' -f4)
if [ -z "$WEBHOOK_URL" ] || [ "$WEBHOOK_URL" = "" ]; then
    echo "   ✅ Using polling mode (good for local development)"
else
    echo "   ⚠️  Webhook is set to: $WEBHOOK_URL"
    echo "   Note: Webhook mode may conflict with local polling"
fi

echo ""
echo "3. Checking OpenClaw Status..."
if pgrep -f "openclaw-gateway" > /dev/null; then
    echo "   ✅ OpenClaw gateway is RUNNING"
    
    # Check recent Telegram logs
    echo ""
    echo "4. Checking Recent Telegram Activity..."
    RECENT_TELEGRAM=$(tail -20 ~/.openclaw/logs/gateway.log | grep -i telegram | tail -5)
    if [ -n "$RECENT_TELEGRAM" ]; then
        echo "   Recent Telegram logs:"
        echo "$RECENT_TELEGRAM" | while read line; do
            echo "   📝 $line"
        done
    else
        echo "   ℹ️  No recent Telegram activity in logs"
    fi
    
    # Check for errors
    RECENT_ERRORS=$(tail -20 ~/.openclaw/logs/gateway.err.log | grep -i telegram | tail -5)
    if [ -n "$RECENT_ERRORS" ]; then
        echo ""
        echo "   ⚠️  Recent Telegram errors:"
        echo "$RECENT_ERRORS" | while read line; do
            echo "   ❌ $line"
        done
    else
        echo "   ✅ No recent Telegram errors"
    fi
    
else
    echo "   ❌ OpenClaw gateway is NOT RUNNING"
    echo ""
    echo "   To start OpenClaw:"
    echo "   openclaw gateway start"
fi

echo ""
echo "5. Checking Configuration Files..."
if grep -q "8208452855:AAGdgNAUCJ6Lgq_un5Lh86iTW8XTbHc12Lg" ~/.openclaw/clawdbot.json; then
    echo "   ✅ Token found in clawdbot.json"
else
    echo "   ❌ Token NOT found in clawdbot.json"
fi

if grep -q "8208452855:AAGdgNAUCJ6Lgq_un5Lh86iTW8XTbHc12Lg" ~/.openclaw/openclaw.json; then
    echo "   ✅ Token found in openclaw.json"
else
    echo "   ❌ Token NOT found in openclaw.json"
fi

echo ""
echo "========================================"
echo "📱 How to Test Your Bot:"
echo "1. Open Telegram"
echo "2. Search for @Omamoribotbot"
echo "3. Click 'Start' or send /start"
echo "4. Send a test message"
echo ""
echo "📊 Monitor logs: tail -f ~/.openclaw/logs/gateway.log | grep -i telegram"
echo "========================================"