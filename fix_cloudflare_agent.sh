#!/bin/bash

echo "========================================="
echo "Cloudflare Agent Fix Script"
echo "========================================="
echo ""
echo "This script will help fix your Cloudflare agent issues."
echo ""

# Check if we're in the right directory
if [ ! -f "telegram-bot-cloudflare/wrangler.toml" ]; then
    echo "Error: Please run this script from your home directory where telegram-bot-cloudflare exists."
    exit 1
fi

echo "STEP 1: Checking Cloudflare authentication..."
echo "----------------------------------------"
npx wrangler whoami

echo ""
echo "STEP 2: Checking current Telegram bot token..."
echo "----------------------------------------"
CURRENT_TOKEN=$(grep 'TELEGRAM_BOT_TOKEN =' telegram-bot-cloudflare/wrangler.toml | cut -d'"' -f2)
if [ -n "$CURRENT_TOKEN" ]; then
    echo "Current token: ${CURRENT_TOKEN:0:10}...${CURRENT_TOKEN: -10}"
    echo "Testing token validity..."
    RESPONSE=$(curl -s "https://api.telegram.org/bot${CURRENT_TOKEN}/getMe")
    if echo "$RESPONSE" | grep -q '"ok":true'; then
        echo "✅ Token is valid!"
    else
        echo "❌ Token is INVALID!"
        echo "Response: $RESPONSE"
    fi
else
    echo "No token found in wrangler.toml"
fi

echo ""
echo "STEP 3: Checking worker deployment..."
echo "----------------------------------------"
echo "Worker URL: https://telegram-bot-worker.yksanjo.workers.dev/"
echo "Testing worker..."
WORKER_RESPONSE=$(curl -s "https://telegram-bot-worker.yksanjo.workers.dev/" | head -5)
if echo "$WORKER_RESPONSE" | grep -q "Telegram Bot"; then
    echo "✅ Worker is running!"
else
    echo "❌ Worker may not be accessible"
fi

echo ""
echo "STEP 4: Fixing token issues..."
echo "----------------------------------------"
echo ""
echo "If your Telegram bot token is invalid, you need to:"
echo ""
echo "1. Get a NEW Telegram bot token from @BotFather:"
echo "   - Open Telegram, search for @BotFather"
echo "   - Send '/newbot'"
echo "   - Follow instructions to create a new bot"
echo "   - Copy the new token (looks like: 1234567890:ABCdefGHIjklMNOpqrSTUvwxYZ)"
echo ""
echo "2. Update ALL files with the new token:"
echo "   - telegram-bot-cloudflare/wrangler.toml"
echo "   - working-bot.py"
echo "   - instant-bot.py"
echo "   - verify-bot-pairing.sh"
echo "   - direct-test.sh"
echo "   - test-connection.py"
echo ""
echo "3. Update Cloudflare secret:"
echo "   cd telegram-bot-cloudflare"
echo "   echo 'YOUR_NEW_TOKEN' | npx wrangler secret put TELEGRAM_BOT_TOKEN"
echo ""
echo "4. Redeploy worker:"
echo "   npx wrangler deploy --env=''"
echo ""
echo "5. Set webhook:"
echo "   curl -X POST 'https://api.telegram.org/botYOUR_NEW_TOKEN/setWebhook?url=https://telegram-bot-worker.yksanjo.workers.dev/'"
echo ""
echo "STEP 5: If Cloudflare authentication is failing..."
echo "----------------------------------------"
echo "If you can't connect to the Cloudflare dashboard, try:"
echo ""
echo "1. Log out and log back in:"
echo "   npx wrangler logout"
echo "   npx wrangler login"
echo ""
echo "2. Check your API token (if using one):"
echo "   - Go to Cloudflare Dashboard → My Profile → API Tokens"
echo "   - Ensure you have a valid token with Workers permissions"
echo "   - Set environment variable: export CLOUDFLARE_API_TOKEN='your-token'"
echo ""
echo "STEP 6: Complete fix checklist..."
echo "----------------------------------------"
echo ""
echo "✅ Cloudflare account logged in"
echo "✅ Worker deployed and accessible"
echo "✅ Valid Telegram bot token configured"
echo "✅ Webhook set correctly"
echo "✅ All configuration files updated with correct token"
echo ""
echo "After completing these steps, your Cloudflare agent should work!"
echo ""
echo "Need more help? Run: ./update_telegram_token.sh"
echo "========================================="