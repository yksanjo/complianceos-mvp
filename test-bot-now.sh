#!/bin/bash

echo "🔍 QUICK BOT TEST - RIGHT NOW"
echo "=============================="

BOT_TOKEN="8208452855:AAGdgNAUCJ6Lgq_un5Lh86iTW8XTbHc12Lg"

echo ""
echo "1. Testing Telegram API connection..."
TEST=$(curl -s -w "%{http_code}" "https://api.telegram.org/bot${BOT_TOKEN}/getMe" -o /tmp/telegram_test.json)
if [ "$TEST" = "200" ]; then
    echo "   ✅ Telegram API is accessible"
    BOT_INFO=$(cat /tmp/telegram_test.json)
    if echo "$BOT_INFO" | grep -q '"ok":true'; then
        BOT_NAME=$(echo "$BOT_INFO" | grep -o '"first_name":"[^"]*"' | cut -d'"' -f4)
        BOT_USERNAME=$(echo "$BOT_INFO" | grep -o '"username":"[^"]*"' | cut -d'"' -f4)
        echo "   🤖 Bot: $BOT_NAME (@$BOT_USERNAME)"
    else
        echo "   ❌ Bot token is invalid"
        cat /tmp/telegram_test.json
        exit 1
    fi
else
    echo "   ❌ Cannot connect to Telegram API (HTTP $TEST)"
    echo "   Check your internet connection or firewall"
    exit 1
fi

echo ""
echo "2. Checking for pending messages..."
UPDATES=$(curl -s "https://api.telegram.org/bot${BOT_TOKEN}/getUpdates")
if echo "$UPDATES" | grep -q '"result":\[\]'; then
    echo "   ✅ No pending messages"
else
    echo "   📨 Pending messages found (bot may not be processing)"
    echo "$UPDATES" | python3 -m json.tool 2>/dev/null | head -50
fi

echo ""
echo "3. Testing if bot can send a message..."
# We can't send without a chat ID, but we can test the API
TEST_SEND=$(curl -s -w "%{http_code}" "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
  -d "chat_id=8208452855" \
  -d "text=Test message from API" \
  -o /tmp/send_test.json 2>/dev/null)

if [ "$TEST_SEND" = "200" ] || echo "$TEST_SEND" | grep -q "403"; then
    echo "   ✅ Bot can communicate with Telegram API"
    if [ "$TEST_SEND" = "403" ]; then
        echo "   ⚠️  Got 403 (bots can't message bots) - this is expected"
    fi
else
    echo "   ❌ Cannot send messages (HTTP $TEST_SEND)"
fi

echo ""
echo "4. Checking OpenClaw status..."
if pgrep -f "openclaw-gateway" > /dev/null; then
    echo "   ⚠️  OpenClaw is running (may interfere with simple bot)"
    echo "   PID: $(pgrep -f "openclaw-gateway" | head -1)"
    echo "   Consider stopping it: pkill -f openclaw-gateway"
else
    echo "   ✅ OpenClaw is not running"
fi

echo ""
echo "=============================="
echo "🎯 RECOMMENDED ACTION:"
echo ""
echo "Run the simple bot to guarantee it works:"
echo "./run-simple-bot.sh"
echo ""
echo "Or test your current setup:"
echo "1. Open Telegram"
echo "2. Message @Omamoribotbot"
echo "3. Send: /start"
echo "4. Send: Hello"
echo ""
echo "If it doesn't work, the simple bot WILL work!"
echo "=============================="