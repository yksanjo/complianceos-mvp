#!/bin/bash

echo "Telegram Bot Token Test Script"
echo "=============================="

# Check if curl is available
if ! command -v curl &> /dev/null; then
    echo "curl is not installed. Please install curl first."
    exit 1
fi

# Ask for bot token
read -p "Enter your Telegram bot token: " BOT_TOKEN

if [ -z "$BOT_TOKEN" ]; then
    echo "Error: No token provided."
    exit 1
fi

echo ""
echo "Testing bot token..."

# Test the token by calling getMe API
RESPONSE=$(curl -s "https://api.telegram.org/bot${BOT_TOKEN}/getMe")

# Check if response contains "ok": true
if echo "$RESPONSE" | grep -q '"ok":true'; then
    echo "✅ Token is VALID!"
    echo ""
    echo "Bot information:"
    echo "$RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$RESPONSE"
    
    # Test webhook
    echo ""
    echo "Checking webhook status..."
    WEBHOOK_INFO=$(curl -s "https://api.telegram.org/bot${BOT_TOKEN}/getWebhookInfo")
    echo "Webhook info:"
    echo "$WEBHOOK_INFO" | python3 -m json.tool 2>/dev/null || echo "$WEBHOOK_INFO"
    
else
    echo "❌ Token is INVALID!"
    echo ""
    echo "Error response:"
    echo "$RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$RESPONSE"
    echo ""
    echo "Possible reasons:"
    echo "1. Token is incorrect"
    echo "2. Token has been revoked"
    echo "3. Bot has been deleted"
    echo ""
    echo "Solution: Get a new token from @BotFather on Telegram"
fi