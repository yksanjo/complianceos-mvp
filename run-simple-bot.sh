#!/bin/bash

echo "🤖 SIMPLE TELEGRAM BOT - GUARANTEED TO WORK"
echo "==========================================="

# Check Python
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 is not installed. Please install Python 3.8 or higher."
    exit 1
fi

echo "1. Checking Python version..."
python3 --version

echo ""
echo "2. Installing dependencies..."
pip3 install python-telegram-bot==20.7 python-dotenv 2>/dev/null || pip install python-telegram-bot==20.7 python-dotenv

echo ""
echo "3. Testing Telegram bot token..."
BOT_TOKEN="8208452855:AAGdgNAUCJ6Lgq_un5Lh86iTW8XTbHc12Lg"
TEST=$(curl -s "https://api.telegram.org/bot${BOT_TOKEN}/getMe")
if echo "$TEST" | grep -q '"ok":true'; then
    echo "   ✅ Token is VALID"
    BOT_NAME=$(echo "$TEST" | grep -o '"first_name":"[^"]*"' | cut -d'"' -f4)
    BOT_USERNAME=$(echo "$TEST" | grep -o '"username":"[^"]*"' | cut -d'"' -f4)
    echo "   🤖 Bot: $BOT_NAME (@$BOT_USERNAME)"
else
    echo "   ❌ Token is INVALID"
    echo "   Response: $TEST"
    exit 1
fi

echo ""
echo "4. Stopping any existing OpenClaw processes..."
pkill -f "openclaw-gateway" 2>/dev/null
sleep 2

echo ""
echo "5. Starting Simple Telegram Bot..."
echo "   📱 Go to Telegram and message @Omamoribotbot"
echo "   🛑 Press Ctrl+C to stop the bot"
echo ""
echo "==========================================="

# Run the bot
python3 simple-telegram-bot.py