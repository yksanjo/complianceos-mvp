#!/bin/bash

echo "========================================="
echo "Update ALL Telegram Bot Tokens"
echo "========================================="
echo ""
echo "This script will update ALL files with your new Telegram bot token."
echo ""
echo "STEP 1: Get a NEW Telegram bot token"
echo "----------------------------------------"
echo "1. Open Telegram, search for @BotFather"
echo "2. Send '/newbot' to create a new bot"
echo "3. Follow instructions to get a new token"
echo "4. The token looks like: 1234567890:ABCdefGHIjklMNOpqrSTUvwxYZ"
echo ""
read -p "Enter your NEW Telegram bot token: " NEW_TOKEN

if [ -z "$NEW_TOKEN" ]; then
    echo "❌ Error: No token entered!"
    exit 1
fi

echo ""
echo "STEP 2: Updating files..."
echo "----------------------------------------"

# Update telegram-bot-cloudflare/wrangler.toml
if [ -f "telegram-bot-cloudflare/wrangler.toml" ]; then
    if sed -i '' "s/TELEGRAM_BOT_TOKEN = \".*\"/TELEGRAM_BOT_TOKEN = \"$NEW_TOKEN\"/" telegram-bot-cloudflare/wrangler.toml; then
        echo "✅ Updated telegram-bot-cloudflare/wrangler.toml"
    else
        echo "❌ Failed to update wrangler.toml"
    fi
else
    echo "⚠️  telegram-bot-cloudflare/wrangler.toml not found"
fi

# Update Python files
for file in working-bot.py instant-bot.py test-connection.py; do
    if [ -f "$file" ]; then
        if sed -i '' "s/BOT_TOKEN = \".*\"/BOT_TOKEN = \"$NEW_TOKEN\"/" "$file"; then
            echo "✅ Updated $file"
        else
            echo "❌ Failed to update $file"
        fi
    else
        echo "⚠️  $file not found"
    fi
done

# Update shell script files
for file in verify-bot-pairing.sh direct-test.sh; do
    if [ -f "$file" ]; then
        if sed -i '' "s/BOT_TOKEN=\".*\"/BOT_TOKEN=\"$NEW_TOKEN\"/" "$file"; then
            echo "✅ Updated $file"
        else
            echo "❌ Failed to update $file"
        fi
    else
        echo "⚠️  $file not found"
    fi
done

echo ""
echo "STEP 3: Update Cloudflare secret (requires wrangler login)"
echo "----------------------------------------"
read -p "Do you want to update Cloudflare secret now? (y/n): " UPDATE_SECRET

if [ "$UPDATE_SECRET" = "y" ] || [ "$UPDATE_SECRET" = "Y" ]; then
    echo "Updating Cloudflare secret..."
    cd telegram-bot-cloudflare
    echo "$NEW_TOKEN" | npx wrangler secret put TELEGRAM_BOT_TOKEN
    if [ $? -eq 0 ]; then
        echo "✅ Cloudflare secret updated"
        
        echo ""
        echo "Redeploying worker..."
        npx wrangler deploy --env=""
        
        echo ""
        echo "STEP 4: Set webhook"
        echo "----------------------------------------"
        echo "Run this command to set the webhook:"
        echo "curl -X POST \"https://api.telegram.org/bot${NEW_TOKEN}/setWebhook?url=https://telegram-bot-worker.yksanjo.workers.dev/\""
        echo ""
        read -p "Do you want to set the webhook now? (y/n): " SET_WEBHOOK
        if [ "$SET_WEBHOOK" = "y" ] || [ "$SET_WEBHOOK" = "Y" ]; then
            curl -X POST "https://api.telegram.org/bot${NEW_TOKEN}/setWebhook?url=https://telegram-bot-worker.yksanjo.workers.dev/"
            echo ""
            echo "✅ Webhook set!"
        fi
    else
        echo "❌ Failed to update Cloudflare secret"
        echo "Make sure you're logged in: npx wrangler login"
    fi
    cd ..
else
    echo "Skipping Cloudflare secret update"
fi

echo ""
echo "========================================="
echo "Update Complete!"
echo "========================================="
echo ""
echo "Summary:"
echo "- Updated all local files with new token"
if [ "$UPDATE_SECRET" = "y" ] || [ "$UPDATE_SECRET" = "Y" ]; then
    echo "- Updated Cloudflare secret"
    echo "- Redeployed worker"
    if [ "$SET_WEBHOOK" = "y" ] || [ "$SET_WEBHOOK" = "Y" ]; then
        echo "- Webhook set"
    else
        echo "- Remember to set webhook:"
        echo "  curl -X POST \"https://api.telegram.org/bot${NEW_TOKEN}/setWebhook?url=https://telegram-bot-worker.yksanjo.workers.dev/\""
    fi
else
    echo "- Cloudflare secret NOT updated (run manually)"
    echo "- Worker NOT redeployed"
    echo "- Webhook NOT set"
fi
echo ""
echo "Next steps:"
echo "1. Test your token: curl -s \"https://api.telegram.org/bot${NEW_TOKEN}/getMe\""
echo "2. Go to Telegram and message your bot"
echo "3. Send /start to test"