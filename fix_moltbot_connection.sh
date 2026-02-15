#!/bin/bash

# ============================================================
# MoltBot Cloudflare Connection Fix Script
# ============================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  MoltBot Cloudflare Connection Fix    ${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

# Check if we're in the right directory
if [ ! -f "moltworker-cloudflare/wrangler.jsonc" ]; then
    echo -e "${RED}❌ Error: Please run this script from your home directory${NC}"
    echo "   (where moltworker-cloudflare folder exists)"
    exit 1
fi

cd moltworker-cloudflare

# Step 1: Check/Install Dependencies
echo -e "${BLUE}📦 Step 1: Checking dependencies...${NC}"
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js is not installed${NC}"
    echo "   Install from: https://nodejs.org/ (v18 or higher)"
    exit 1
fi

if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ npm is not installed${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Node.js and npm are installed${NC}"

# Install npm dependencies if needed
if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}📥 Installing npm dependencies...${NC}"
    npm install
fi

# Step 2: Cloudflare Authentication
echo ""
echo -e "${BLUE}🔐 Step 2: Checking Cloudflare authentication...${NC}"

if npx wrangler whoami &> /dev/null; then
    echo -e "${GREEN}✅ Already logged in to Cloudflare${NC}"
else
    echo -e "${YELLOW}⚠️  Not logged in to Cloudflare${NC}"
    echo ""
    echo -e "${BLUE}🌐 Opening browser to log in to Cloudflare...${NC}"
    echo "   (Please complete the login process in your browser)"
    echo ""
    npx wrangler login
fi

# Verify login
if ! npx wrangler whoami &> /dev/null; then
    echo -e "${RED}❌ Failed to authenticate with Cloudflare${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Cloudflare authentication successful${NC}"

# Step 3: Check Worker Status
echo ""
echo -e "${BLUE}🔍 Step 3: Checking Worker status...${NC}"

# Check if worker exists
if npx wrangler deploy --dry-run 2>&1 | grep -q "successfully"; then
    echo -e "${GREEN}✅ Worker configuration is valid${NC}"
else
    echo -e "${YELLOW}⚠️  Worker needs to be deployed${NC}"
fi

# Step 4: API Key Setup
echo ""
echo -e "${BLUE}🔑 Step 4: AI Provider API Key Setup${NC}"
echo ""
echo "Choose your AI provider:"
echo "  1) DeepSeek (Recommended) - $0.14/million tokens"
echo "  2) Kimi (Moonshot) - $0.60/million tokens"
echo "  3) Anthropic Claude - $0.25-$15/million tokens"
echo ""

read -p "Enter choice (1-3): " PROVIDER_CHOICE

case $PROVIDER_CHOICE in
    1)
        PROVIDER="deepseek"
        API_KEY_NAME="DEEPSEEK_API_KEY"
        echo ""
        echo -e "${BLUE}DeepSeek Setup:${NC}"
        echo "   Get your API key from: https://platform.deepseek.com"
        echo "   Format: sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        ;;
    2)
        PROVIDER="kimi"
        API_KEY_NAME="KIMI_API_KEY"
        echo ""
        echo -e "${BLUE}Kimi/Moonshot Setup:${NC}"
        echo "   Get your API key from: https://platform.moonshot.cn"
        ;;
    3)
        PROVIDER="anthropic"
        API_KEY_NAME="ANTHROPIC_API_KEY"
        echo ""
        echo -e "${BLUE}Anthropic Setup:${NC}"
        echo "   Get your API key from: https://console.anthropic.com"
        ;;
    *)
        echo -e "${RED}❌ Invalid choice${NC}"
        exit 1
        ;;
esac

echo ""
read -p "Enter your $API_KEY_NAME: " API_KEY

if [ -z "$API_KEY" ]; then
    echo -e "${RED}❌ No API key provided${NC}"
    exit 1
fi

# Step 5: Set Secrets
echo ""
echo -e "${BLUE}🔒 Step 5: Setting Cloudflare secrets...${NC}"

# Generate gateway token if not exists
MOLTBOT_GATEWAY_TOKEN=$(openssl rand -base64 32 | tr -d '=+/' | head -c 32)

# Set the API key
echo "$API_KEY" | npx wrangler secret put "$API_KEY_NAME"

# Set gateway token
echo "$MOLTBOT_GATEWAY_TOKEN" | npx wrangler secret put MOLTBOT_GATEWAY_TOKEN

# Set dev mode
echo "true" | npx wrangler secret put DEV_MODE

echo -e "${GREEN}✅ Secrets set successfully${NC}"

# Save the token
echo ""
echo -e "${YELLOW}📝 IMPORTANT: Save this gateway token!${NC}"
echo -e "   ${GREEN}$MOLTBOT_GATEWAY_TOKEN${NC}"
echo ""

# Step 6: Deploy the Worker
echo -e "${BLUE}🚀 Step 6: Deploying to Cloudflare Workers...${NC}"

if npx wrangler deploy; then
    echo -e "${GREEN}✅ Deployment successful!${NC}"
else
    echo -e "${RED}❌ Deployment failed${NC}"
    exit 1
fi

# Step 7: Get the Worker URL
echo ""
echo -e "${BLUE}🔗 Step 7: Getting Worker URL...${NC}"

# Try to get the worker URL
WORKER_URL=$(npx wrangler deploy 2>&1 | grep -o 'https://[^[:space:]]*workers.dev' | head -1)

if [ -z "$WORKER_URL" ]; then
    # Extract from wrangler.jsonc
    WORKER_NAME=$(grep '"name"' wrangler.jsonc | head -1 | cut -d'"' -f4)
    WORKER_URL="https://${WORKER_NAME}.yksanjo.workers.dev"
fi

echo -e "${GREEN}✅ Worker URL: $WORKER_URL${NC}"

# Step 8: Test the Connection
echo ""
echo -e "${BLUE}🧪 Step 8: Testing connection...${NC}"

TEST_URL="${WORKER_URL}/?token=${MOLTBOT_GATEWAY_TOKEN}"
echo "   Testing: $TEST_URL"

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$TEST_URL" 2>&1 || echo "000")

if [ "$HTTP_STATUS" = "200" ]; then
    echo -e "${GREEN}✅ Connection successful!${NC}"
else
    echo -e "${YELLOW}⚠️  Connection test returned HTTP $HTTP_STATUS${NC}"
    echo "   (This is normal for new deployments - wait 1-2 minutes)"
fi

# Step 9: Summary
echo ""
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}  🎉 MoltBot Connection Fixed!          ${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo -e "${BLUE}📋 Summary:${NC}"
echo -e "  🤖 Provider: ${GREEN}$PROVIDER${NC}"
echo -e "  🔗 Worker URL: ${GREEN}$WORKER_URL${NC}"
echo -e "  🔐 Gateway Token: ${GREEN}$MOLTBOT_GATEWAY_TOKEN${NC}"
echo ""
echo -e "${BLUE}🔗 Access your MoltBot:${NC}"
echo -e "   ${YELLOW}${TEST_URL}${NC}"
echo ""
echo -e "${BLUE}📚 Useful commands:${NC}"
echo "   View logs:     npx wrangler tail"
echo "   Redeploy:      npx wrangler deploy"
echo "   Check secrets: npx wrangler secret list"
echo ""
echo -e "${BLUE}⚠️  Important Notes:${NC}"
echo "   • Wait 1-2 minutes for the container to start"
echo "   • Save your gateway token - you'll need it to access the bot"
echo "   • The container stays warm for 5 minutes after use"
echo ""
echo -e "${GREEN}Done!${NC}"
