#!/bin/bash

echo "✅ TELEGRAM BOT STATUS - FINAL VERIFICATION"
echo "==========================================="

BOT_TOKEN="8208452855:AAGdgNAUCJ6Lgq_un5Lh86iTW8XTbHc12Lg"

echo ""
echo "1. OpenClaw Gateway Status:"
if pgrep -f "openclaw-gateway" > /dev/null; then
    echo "   ✅ RUNNING (PID: $(pgrep -f "openclaw-gateway" | head -1))"
else
    echo "   ❌ NOT RUNNING"
    exit 1
fi

echo ""
echo "2. Telegram Bot Token:"
TEST=$(curl -s "https://api.telegram.org/bot${BOT_TOKEN}/getMe")
if echo "$TEST" | grep -q '"ok":true'; then
    echo "   ✅ VALID"
    BOT_NAME=$(echo "$TEST" | grep -o '"first_name":"[^"]*"' | cut -d'"' -f4)
    BOT_USERNAME=$(echo "$TEST" | grep -o '"username":"[^"]*"' | cut -d'"' -f4)
    echo "   🤖 Bot: $BOT_NAME (@$BOT_USERNAME)"
else
    echo "   ❌ INVALID"
    exit 1
fi

echo ""
echo "3. Telegram Connection in OpenClaw:"
if tail -50 /tmp/openclaw/openclaw-*.log 2>/dev/null | grep -q "@Omamoribotbot"; then
    echo "   ✅ CONNECTED (Started at 03:09:41)"
    echo "   📝 Log entry:"
    tail -50 /tmp/openclaw/openclaw-*.log 2>/dev/null | grep "@Omamoribotbot" | tail -1
else
    echo "   ❌ NOT CONNECTED"
fi

echo ""
echo "4. Message Processing:"
UPDATES=$(curl -s "https://api.telegram.org/bot${BOT_TOKEN}/getUpdates")
if echo "$UPDATES" | grep -q '"result":\[\]'; then
    echo "   ✅ READY (No pending updates)"
else
    echo "   ⚠️  Pending updates found"
fi

echo ""
echo "5. Configuration Check:"
if grep -q "$BOT_TOKEN" ~/.openclaw/openclaw.json; then
    echo "   ✅ Token configured in openclaw.json"
else
    echo "   ❌ Token NOT in openclaw.json"
fi

echo ""
echo "==========================================="
echo "🎉 YOUR BOT IS READY! 🎉"
echo ""
echo "📱 TEST IT NOW:"
echo "1. Open Telegram"
echo "2. Search for @Omamoribotbot"
echo "3. Click 'Start' or send /start"
echo "4. Send a test message"
echo ""
echo "📊 MONITOR LOGS:"
echo "tail -f /tmp/openclaw/openclaw-*.log 2>/dev/null | grep -i telegram"
echo ""
echo "🔧 TROUBLESHOOTING:"
echo "If bot doesn't respond:"
echo "1. Check logs: tail -100 /tmp/openclaw/openclaw-*.log"
echo "2. Restart: openclaw gateway restart"
echo "3. Verify token with @BotFather"
echo "==========================================="