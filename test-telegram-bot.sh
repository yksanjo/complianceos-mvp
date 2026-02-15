#!/bin/bash

echo "=== Telegram Bot Test Script ==="
echo ""

# Test 1: Bot token validity
echo "1. Testing bot token validity..."
TOKEN="8208452855:AAGdgNAUCJ6Lgq_un5Lh86iTW8XTbHc12Lg"
RESPONSE=$(curl -s "https://api.telegram.org/bot${TOKEN}/getMe")
if echo "$RESPONSE" | grep -q '"ok":true'; then
    BOT_NAME=$(echo "$RESPONSE" | python3 -c "import sys, json; data=json.load(sys.stdin); print(data['result']['first_name'])")
    BOT_USERNAME=$(echo "$RESPONSE" | python3 -c "import sys, json; data=json.load(sys.stdin); print(data['result']['username'])")
    echo "   ✅ Token valid - Bot: $BOT_NAME (@$BOT_USERNAME)"
else
    echo "   ❌ Token invalid"
    exit 1
fi

echo ""

# Test 2: Check pending updates
echo "2. Checking for pending updates..."
UPDATES=$(curl -s "https://api.telegram.org/bot${TOKEN}/getUpdates")
UPDATE_COUNT=$(echo "$UPDATES" | python3 -c "import sys, json; data=json.load(sys.stdin); print(len(data['result']))")
if [ "$UPDATE_COUNT" -eq 0 ]; then
    echo "   ✅ No pending updates (bot is processing messages)"
else
    echo "   ⚠️  $UPDATE_COUNT pending updates (bot might not be receiving messages)"
fi

echo ""

# Test 3: Check OpenClaw gateway
echo "3. Checking OpenClaw gateway..."
if ps aux | grep -q "[o]penclaw-gateway"; then
    echo "   ✅ OpenClaw gateway is running"
else
    echo "   ❌ OpenClaw gateway is not running"
    echo "   Run: openclaw gateway start"
fi

echo ""

# Test 4: Check Telegram in logs
echo "4. Checking Telegram channel in logs..."
if tail -20 ~/.openclaw/logs/gateway.log 2>/dev/null | grep -q "telegram.*starting provider"; then
    echo "   ✅ Telegram channel started in logs"
else
    echo "   ⚠️  Telegram channel not found in recent logs"
    echo "   Check: tail -f ~/.openclaw/logs/gateway.log"
fi

echo ""

# Test 5: Check for errors
echo "5. Checking for errors..."
ERROR_COUNT=$(tail -50 ~/.openclaw/logs/gateway.err.log 2>/dev/null | grep -c "telegram")
if [ "$ERROR_COUNT" -eq 0 ]; then
    echo "   ✅ No Telegram errors in error logs"
else
    echo "   ⚠️  Found $ERROR_COUNT Telegram errors in logs"
    echo "   Check: tail -20 ~/.openclaw/logs/gateway.err.log"
fi

echo ""
echo "=== Summary ==="
echo "Your Telegram bot @Omamoribotbot should be working!"
echo ""
echo "To test:"
echo "1. Open Telegram and message @Omamoribotbot"
echo "2. Send '/start' or any message"
echo "3. Check logs: tail -f ~/.openclaw/logs/gateway.log"
echo ""
echo "If messages aren't received:"
echo "1. Restart gateway: openclaw gateway restart"
echo "2. Check token: curl 'https://api.telegram.org/bot${TOKEN}/getMe'"
echo "3. Verify config: cat ~/.openclaw/openclaw.json | grep telegram"