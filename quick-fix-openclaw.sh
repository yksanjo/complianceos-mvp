#!/bin/bash

# Quick fix for Openclaw Cloudflare deployment
# Addresses the most critical issues

set -e

echo "⚡ Quick Fix for Openclaw on Cloudflare"
echo "======================================="
echo ""

# Step 1: Secure exposed API keys
echo "🔒 Step 1: Securing exposed API keys..."
cd .openclaw

# Create backup
BACKUP_DIR="backups/quickfix_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup current files
cp -f agents/main/agent/models.json "$BACKUP_DIR/"
cp -f agents/main/agent/auth-profiles.json "$BACKUP_DIR/"

# Remove exposed API keys from models.json
echo "   Removing exposed keys from models.json..."
sed -i '' 's/"apiKey": "sk-[^"]*"/"apiKey": "${KIMI_API_KEY}"/g' agents/main/agent/models.json 2>/dev/null || \
sed -i 's/"apiKey": "sk-[^"]*"/"apiKey": "${KIMI_API_KEY}"/g' agents/main/agent/models.json

sed -i '' 's/"apiKey": "sk-[a-zA-Z0-9]*"/"apiKey": "${DEEPSEEK_API_KEY}"/g' agents/main/agent/models.json 2>/dev/null || \
sed -i 's/"apiKey": "sk-[a-zA-Z0-9]*"/"apiKey": "${DEEPSEEK_API_KEY}"/g' agents/main/agent/models.json

# Remove exposed API keys from auth-profiles.json
echo "   Removing exposed keys from auth-profiles.json..."
sed -i '' 's/"key": "sk-[^"]*"/"key": "${KIMI_API_KEY}"/g' agents/main/agent/auth-profiles.json 2>/dev/null || \
sed -i 's/"key": "sk-[^"]*"/"key": "${KIMI_API_KEY}"/g' agents/main/agent/auth-profiles.json

sed -i '' 's/"key": "sk-[a-zA-Z0-9]*"/"key": "${DEEPSEEK_API_KEY}"/g' agents/main/agent/auth-profiles.json 2>/dev/null || \
sed -i 's/"key": "sk-[a-zA-Z0-9]*"/"key": "${DEEPSEEK_API_KEY}"/g' agents/main/agent/auth-profiles.json

echo "   ✅ API keys secured (moved to environment variables)"

# Step 2: Fix Telegram bot token in .env
echo ""
echo "🤖 Step 2: Fixing Telegram bot configuration..."
if grep -q 'TELEGRAM_BOT_TOKEN="\$' .env; then
    echo "   ✅ Telegram token already uses environment variable"
else
    # Update .env to use environment variable
    sed -i '' 's/TELEGRAM_BOT_TOKEN="[^"]*"/TELEGRAM_BOT_TOKEN="${TELEGRAM_BOT_TOKEN}"/g' .env 2>/dev/null || \
    sed -i 's/TELEGRAM_BOT_TOKEN="[^"]*"/TELEGRAM_BOT_TOKEN="${TELEGRAM_BOT_TOKEN}"/g' .env
    echo "   ✅ Updated .env to use environment variable"
fi

# Step 3: Update Cloudflare worker configuration
echo ""
echo "☁️  Step 3: Updating Cloudflare worker configuration..."

# Update wrangler.toml to include environment variables
if ! grep -q "MOLTBOT_GATEWAY_TOKEN" wrangler.toml; then
    echo "   Adding MOLTBOT_GATEWAY_TOKEN to wrangler.toml..."
    cat >> wrangler.toml << 'EOF'

# Environment variables for Openclaw
[vars.production]
MOLTBOT_GATEWAY_TOKEN = "${MOLTBOT_GATEWAY_TOKEN}"
KIMI_API_KEY = "${KIMI_API_KEY}"
DEEPSEEK_API_KEY = "${DEEPSEEK_API_KEY}"

[vars.development]
MOLTBOT_GATEWAY_TOKEN = "${MOLTBOT_GATEWAY_TOKEN_DEV}"
KIMI_API_KEY = "${KIMI_API_KEY_DEV}"
DEEPSEEK_API_KEY = "${DEEPSEEK_API_KEY_DEV}"
EOF
    echo "   ✅ Added environment variables to wrangler.toml"
fi

# Step 4: Create environment file template
echo ""
echo "📝 Step 4: Creating environment configuration..."
if [ ! -f ".env.local" ]; then
    cat > .env.local.template << 'EOF'
# Openclaw Environment Configuration
# Copy this to .env.local and fill in your values

# Telegram Bot (get from @BotFather)
TELEGRAM_BOT_TOKEN="YOUR_TELEGRAM_BOT_TOKEN_HERE"

# AI Provider API Keys
KIMI_API_KEY="YOUR_KIMI_API_KEY_HERE"
DEEPSEEK_API_KEY="YOUR_DEEPSEEK_API_KEY_HERE"

# Cloudflare Gateway Token (generate a secure random string)
MOLTBOT_GATEWAY_TOKEN="$(openssl rand -hex 32)"

# Development environment (optional)
TELEGRAM_BOT_TOKEN_DEV="YOUR_DEV_TELEGRAM_BOT_TOKEN"
KIMI_API_KEY_DEV="YOUR_DEV_KIMI_API_KEY"
DEEPSEEK_API_KEY_DEV="YOUR_DEV_DEEPSEEK_API_KEY"
MOLTBOT_GATEWAY_TOKEN_DEV="$(openssl rand -hex 32)"
EOF
    echo "   Created .env.local.template"
    echo "   ⚠️  IMPORTANT: Create .env.local with your actual values:"
    echo "   cp .env.local.template .env.local"
    echo "   nano .env.local"
fi

# Step 5: Create setup script for Cloudflare secrets
echo ""
echo "🔐 Step 5: Creating Cloudflare secrets setup script..."
cat > setup-cloudflare-secrets.sh << 'EOF'
#!/bin/bash

# Setup Cloudflare secrets from .env.local

if [ ! -f ".env.local" ]; then
    echo "❌ .env.local not found. Create it first."
    echo "   cp .env.local.template .env.local"
    echo "   nano .env.local"
    exit 1
fi

# Load environment variables
source .env.local

echo "🔐 Setting Cloudflare secrets..."
echo ""

if [ -n "$KIMI_API_KEY" ]; then
    echo "$KIMI_API_KEY" | npx wrangler secret put KIMI_API_KEY
    echo "✅ KIMI_API_KEY set"
fi

if [ -n "$DEEPSEEK_API_KEY" ]; then
    echo "$DEEPSEEK_API_KEY" | npx wrangler secret put DEEPSEEK_API_KEY
    echo "✅ DEEPSEEK_API_KEY set"
fi

if [ -n "$MOLTBOT_GATEWAY_TOKEN" ]; then
    echo "$MOLTBOT_GATEWAY_TOKEN" | npx wrangler secret put MOLTBOT_GATEWAY_TOKEN
    echo "✅ MOLTBOT_GATEWAY_TOKEN set"
fi

echo ""
echo "🎉 Secrets configured! Now deploy your worker:"
echo "npx wrangler deploy"
EOF

chmod +x setup-cloudflare-secrets.sh
echo "   Created setup-cloudflare-secrets.sh"

# Step 6: Summary
echo ""
echo "✅ Quick fix completed!"
echo "======================"
echo ""
echo "📋 What was fixed:"
echo "1. Secured exposed API keys in models.json and auth-profiles.json"
echo "2. Updated .env to use environment variables"
echo "3. Enhanced wrangler.toml with environment configuration"
echo "4. Created .env.local.template for secure configuration"
echo "5. Created Cloudflare secrets setup script"
echo ""
echo "🚀 Next steps:"
echo "1. Create your .env.local file:"
echo "   cp .env.local.template .env.local"
echo "   nano .env.local  # Add your actual API keys"
echo ""
echo "2. Set up Cloudflare secrets:"
echo "   ./setup-cloudflare-secrets.sh"
echo ""
echo "3. Deploy to Cloudflare:"
echo "   npx wrangler deploy"
echo ""
echo "4. Test your deployment:"
echo "   curl https://yksanjo-bot.YOUR_SUBDOMAIN.workers.dev/health"
echo ""
echo "5. Fix Telegram webhook (after deployment):"
echo "   curl -X POST 'https://api.telegram.org/botYOUR_TOKEN/setWebhook?url=https://yksanjo-bot.YOUR_SUBDOMAIN.workers.dev/telegram'"
echo ""
echo "💡 Important:"
echo "• Your Kimi API key was exposed and should be rotated"
echo "• Generate new Telegram bot token if current one is compromised"
echo "• Monitor your Cloudflare worker logs for errors"
echo ""
echo "Backup of original files saved to: $BACKUP_DIR"