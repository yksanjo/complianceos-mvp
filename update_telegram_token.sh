#!/bin/bash

echo "========================================="
echo "Telegram Bot Token Update Script"
echo "========================================="
echo ""
echo "This script will help you update your Telegram bot token."
echo ""
echo "STEP 1: Get a new Telegram bot token"
echo "----------------------------------------"
echo "1. Open Telegram and search for @BotFather"
echo "2. Send '/newbot' to create a new bot"
echo "3. Follow the instructions to get a new bot token"
echo "4. The token will look like: 1234567890:ABCdefGHIjklMNOpqrSTUvwxYZ"
echo ""
echo "STEP 2: Update the token in Cloudflare"
echo "----------------------------------------"
echo ""
read -p "Enter your new Telegram bot token: " NEW_TOKEN

if [ -z "$NEW_TOKEN" ]; then
    echo "Error: No token entered!"
    exit 1
fi

echo ""
echo "Updating token in Cloudflare worker..."
echo ""

cd telegram-bot-cloudflare

# Update the wrangler.toml file
sed -i '' "s/TELEGRAM_BOT_TOKEN = \".*\"/TELEGRAM_BOT_TOKEN = \"$NEW_TOKEN\"/" wrangler.toml

# Update the secret in Cloudflare
echo "$NEW_TOKEN" | npx wrangler secret put TELEGRAM_BOT_TOKEN

# Redeploy the worker
echo ""
echo "Redeploying worker with new token..."
npx wrangler deploy --env=""

echo ""
echo "========================================="
echo "Update Complete!"
echo "========================================="
echo ""
echo "Your worker has been updated with the new token."
echo "Worker URL: https://telegram-bot-worker.yksanjo.workers.dev/"
echo ""
echo "STEP 3: Set the webhook"
echo "----------------------------------------"
echo "Run this command to set the webhook:"
echo "curl -X POST \"https://api.telegram.org/bot${NEW_TOKEN}/setWebhook?url=https://telegram-bot-worker.yksanjo.workers.dev/\""
echo ""
echo "STEP 4: Test your bot"
echo "----------------------------------------"
echo "1. Go to Telegram and find your bot"
echo "2. Send /start or any message"
echo "3. The bot should respond!"