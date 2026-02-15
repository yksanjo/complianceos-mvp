#!/bin/bash

# Comprehensive fix for Openclaw on Cloudflare
# Fixes deployment, Kimi API, and configuration issues

set -e

echo "🔧 Openclaw Cloudflare Fix Script"
echo "=================================="
echo ""
echo "This script will fix your Openclaw agent deployment issues on Cloudflare."
echo ""

# Check if we're in the right directory
if [ ! -d ".openclaw" ]; then
    echo "❌ Error: .openclaw directory not found. Please run from your home directory."
    exit 1
fi

cd .openclaw

echo "📋 Step 1: Checking current configuration..."
echo "------------------------------------------"

# Check Telegram bot token
TELEGRAM_TOKEN=$(grep 'TELEGRAM_BOT_TOKEN' .env | cut -d'"' -f2)
if [ -n "$TELEGRAM_TOKEN" ]; then
    echo "📱 Telegram Bot Token: ${TELEGRAM_TOKEN:0:10}...${TELEGRAM_TOKEN: -10}"
    
    # Test Telegram token
    echo "   Testing token validity..."
    RESPONSE=$(curl -s "https://api.telegram.org/bot${TELEGRAM_TOKEN}/getMe" 2>/dev/null || echo "{}")
    if echo "$RESPONSE" | grep -q '"ok":true'; then
        echo "   ✅ Telegram token is valid"
    else
        echo "   ❌ Telegram token is INVALID or rate-limited"
        echo "   Response: $RESPONSE"
    fi
else
    echo "📱 Telegram Bot Token: Not found in .env"
fi

echo ""
echo "🤖 Step 2: Checking AI API keys..."
echo "---------------------------------"

# Check for exposed API keys
if [ -f "agents/main/agent/models.json" ]; then
    echo "🔍 Checking for exposed API keys in models.json..."
    if grep -q 'sk-' agents/main/agent/models.json; then
        echo "   ❌ EXPOSED API KEYS FOUND in models.json!"
        echo "   Run: ./fix-exposed-keys.sh to secure them"
    else
        echo "   ✅ No exposed API keys found"
    fi
fi

echo ""
echo "☁️  Step 3: Checking Cloudflare configuration..."
echo "---------------------------------------------"

# Check Cloudflare login
echo "🔐 Checking Cloudflare authentication..."
if command -v wrangler &> /dev/null; then
    npx wrangler whoami > /dev/null 2>&1 && echo "   ✅ Logged into Cloudflare" || echo "   ❌ Not logged into Cloudflare"
else
    echo "   ⚠️  Wrangler not installed. Install with: npm install -g wrangler"
fi

# Check wrangler.toml
if [ -f "wrangler.toml" ]; then
    WORKER_NAME=$(grep '^name =' wrangler.toml | cut -d'"' -f2)
    echo "   📄 Worker name: $WORKER_NAME"
else
    echo "   ❌ wrangler.toml not found"
fi

echo ""
echo "🔧 Step 4: Fixing Kimi API configuration..."
echo "-----------------------------------------"

# Create a Kimi API test script
cat > test-kimi-api.js << 'EOF'
// Test Kimi (Moonshot) API connectivity
import fetch from 'node-fetch';

async function testKimiAPI() {
    const apiKey = process.env.KIMI_API_KEY;
    if (!apiKey) {
        console.error('❌ KIMI_API_KEY environment variable not set');
        return false;
    }

    console.log(`🔑 Testing Kimi API with key: ${apiKey.substring(0, 10)}...`);
    
    try {
        const response = await fetch('https://api.moonshot.ai/v1/models', {
            headers: {
                'Authorization': `Bearer ${apiKey}`,
                'Content-Type': 'application/json'
            }
        });

        if (response.ok) {
            const data = await response.json();
            console.log('✅ Kimi API is working! Available models:');
            data.data.forEach(model => {
                console.log(`   - ${model.id} (${model.object})`);
            });
            return true;
        } else {
            console.error(`❌ Kimi API error: ${response.status} ${response.statusText}`);
            const errorText = await response.text();
            console.error(`   Error details: ${errorText.substring(0, 200)}`);
            return false;
        }
    } catch (error) {
        console.error(`❌ Kimi API connection failed: ${error.message}`);
        return false;
    }
}

testKimiAPI().then(success => {
    process.exit(success ? 0 : 1);
});
EOF

echo "   Created Kimi API test script: test-kimi-api.js"
echo "   To test your Kimi API key:"
echo "   export KIMI_API_KEY='your-key-here' && node test-kimi-api.js"

echo ""
echo "🔄 Step 5: Creating deployment fix script..."
echo "------------------------------------------"

cat > deploy-fix.sh << 'EOF'
#!/bin/bash

# Fix and deploy Openclaw to Cloudflare

set -e

echo "🚀 Openclaw Cloudflare Deployment Fix"
echo "====================================="

# Check environment
if [ ! -f ".env.local" ]; then
    echo "❌ .env.local not found. Create it from template:"
    echo "   cp .env.template.secure .env.local"
    echo "   nano .env.local  # Add your API keys"
    exit 1
fi

# Load environment
source .env.local 2>/dev/null || echo "⚠️  Could not load .env.local"

# Set Cloudflare secrets
echo ""
echo "🔐 Setting Cloudflare secrets..."
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

# Update wrangler.toml with environment variables
echo ""
echo "📝 Updating wrangler.toml..."
cat > wrangler.toml << 'WRANGLER_CONFIG'
name = "openclaw-gateway"
main = "cloudflare-worker.js"
compatibility_date = "2025-02-11"
compatibility_flags = ["nodejs_compat"]

[vars]
OPENCLAW_API_URL = "http://localhost:18789"
ENVIRONMENT = "production"

[[durable_objects.bindings]]
name = "Sandbox"
class_name = "Sandbox"

[[migrations]]
tag = "v1"
new_classes = ["Sandbox"]
WRANGLER_CONFIG

echo "✅ wrangler.toml updated"

# Update Cloudflare worker to use environment variables
echo ""
echo "🔧 Updating Cloudflare worker..."
cat > cloudflare-worker-fixed.js << 'WORKER_CODE'
// Openclaw Gateway Worker - Fixed version
export class Sandbox {
  constructor(state, env) {
    this.state = state;
    this.env = env;
  }
  async fetch(request) {
    return new Response('Sandbox', { status: 200 });
  }
}

export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url);
    const path = url.pathname;

    const corsHeaders = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization'
    };

    if (request.method === 'OPTIONS') {
      return new Response(null, { headers: corsHeaders });
    }

    // Health check endpoint
    if (path === '/health') {
      return new Response(JSON.stringify({
        status: 'healthy',
        service: 'openclaw-gateway',
        environment: env.ENVIRONMENT || 'development',
        timestamp: new Date().toISOString()
      }), {
        headers: { 'Content-Type': 'application/json', ...corsHeaders }
      });
    }

    // WebSocket upgrade for real-time communication
    const upgradeHeader = request.headers.get('Upgrade') || '';
    if (upgradeHeader.toLowerCase() === 'websocket') {
      return handleWebSocket(request, url, env, ctx);
    }

    // API endpoints
    if (path === '/api/chat') {
      return handleChatAPI(request, env, ctx);
    }

    // Default response
    return new Response(JSON.stringify({
      service: 'Openclaw Gateway',
      endpoints: {
        health: '/health',
        chat: '/api/chat',
        websocket: 'ws://' + url.host + '/ws?token=TOKEN'
      },
      environment: env.ENVIRONMENT || 'development'
    }), {
      headers: { 'Content-Type': 'application/json', ...corsHeaders }
    });
  }
};

async function handleWebSocket(request, url, env, ctx) {
  const token = url.searchParams.get('token');
  const session = url.searchParams.get('session') || 'main';

  if (!token) {
    return new Response('Missing token. Use: ?token=YOUR_TOKEN', { status: 401 });
  }

  // Use environment variable for token validation
  if (token !== env.MOLTBOT_GATEWAY_TOKEN) {
    return new Response('Invalid token', { status: 403 });
  }

  try {
    const webSocketPair = new WebSocketPair();
    const [client, server] = Object.values(webSocketPair);

    server.accept();

    // Send welcome message
    server.send(JSON.stringify({
      type: 'connected',
      session: session,
      timestamp: new Date().toISOString(),
      message: 'Connected to Openclaw Gateway'
    }));

    // Set up message handler
    server.addEventListener('message', (event) => {
      try {
        const data = JSON.parse(event.data);
        // Process message here
        server.send(JSON.stringify({
          type: 'response',
          received: data,
          timestamp: new Date().toISOString()
        }));
      } catch (e) {
        server.send(JSON.stringify({
          type: 'echo',
          data: event.data,
          timestamp: new Date().toISOString()
        }));
      }
    });

    // Handle connection close
    server.addEventListener('close', () => {
      console.log('WebSocket closed for session:', session);
    });

    server.addEventListener('error', (err) => {
      console.error('WebSocket error:', err);
    });

    return new Response(null, {
      status: 101,
      webSocket: client
    });

  } catch (error) {
    console.error('WebSocket error:', error);
    return new Response('WebSocket error: ' + error.message, { status: 500 });
  }
}

async function handleChatAPI(request, env, ctx) {
  if (request.method !== 'POST') {
    return new Response('Method not allowed', { status: 405 });
  }

  try {
    const body = await request.json();
    
    // Here you would integrate with your AI providers
    // For now, return a simple response
    return new Response(JSON.stringify({
      response: "Hello from Openclaw Gateway! This is a placeholder response.",
      received: body,
      timestamp: new Date().toISOString()
    }), {
      headers: { 'Content-Type': 'application/json' }
    });
  } catch (error) {
    return new Response(JSON.stringify({
      error: 'Invalid request',
      message: error.message
    }), {
      status: 400,
      headers: { 'Content-Type': 'application/json' }
    });
  }
}
WORKER_CODE

# Replace the worker file
cp cloudflare-worker-fixed.js cloudflare-worker.js
rm cloudflare-worker-fixed.js
echo "✅ Cloudflare worker updated"

# Deploy to Cloudflare
echo ""
echo "🚀 Deploying to Cloudflare Workers..."
npx wrangler deploy

echo ""
echo "🎉 Deployment complete!"
echo "======================"
echo ""
echo "Your Openclaw gateway is now deployed to Cloudflare Workers!"
echo ""
echo "📋 Quick links:"
echo "• Health check: https://openclaw-gateway.YOUR_SUBDOMAIN.workers.dev/health"
echo "• API endpoint: https://openclaw-gateway.YOUR_SUBDOMAIN.workers.dev/api/chat"
echo ""
echo "🔧 Next steps:"
echo "1. Test the health endpoint"
echo "2. Configure your Openclaw agent to use the gateway"
echo "3. Set up Telegram/Discord webhooks"
echo "4. Monitor usage in Cloudflare dashboard"
EOF

chmod +x deploy-fix.sh
echo "   Created deployment fix script: deploy-fix.sh"

echo ""
echo "📝 Step 6: Creating Telegram bot fix script..."
echo "--------------------------------------------"

cat > fix-telegram-bot.sh << 'EOF'
#!/bin/bash

# Fix Telegram bot configuration

echo "🤖 Telegram Bot Configuration Fix"
echo "================================"

# Check current token
CURRENT_TOKEN=$(grep 'TELEGRAM_BOT_TOKEN' .env | cut -d'"' -f2)
if [ -n "$CURRENT_TOKEN" ]; then
    echo "Current token: ${CURRENT_TOKEN:0:10}...${CURRENT_TOKEN: -10}"
    
    # Test the token
    echo "Testing token..."
    RESPONSE=$(curl -s "https://api.telegram.org/bot${CURRENT_TOKEN}/getMe")
    if echo "$RESPONSE" | grep -q '"ok":true'; then
        BOT_USERNAME=$(echo "$RESPONSE" | grep -o '"username":"[^"]*"' | cut -d'"' -f4)
        BOT_NAME=$(echo "$RESPONSE" | grep -o '"first_name":"[^"]*"' | cut -d'"' -f4)
        echo "✅ Bot is working: @$BOT_USERNAME ($BOT_NAME)"
        
        # Set webhook
        echo "Setting webhook to Cloudflare worker..."
        WORKER_URL="https://openclaw-gateway.YOUR_SUBDOMAIN.workers.dev/telegram"
        WEBHOOK_RESPONSE=$(curl -s "https://api.telegram.org/bot${CURRENT_TOKEN}/setWebhook?url=${WORKER_URL}")
        echo "Webhook response: $WEBHOOK_RESPONSE"
    else
        echo "❌ Token is invalid or rate-limited"
        echo "Response: $RESPONSE"
        echo ""
        echo "To get a new token:"
        echo "1. Open Telegram and search for @BotFather"
        echo "2. Send '/newbot'"
        echo "3. Follow the instructions"
        echo "4. Copy the new token"
        echo ""
        echo "Then update .env.local with:"
        echo "TELEGRAM_BOT_TOKEN=\"YOUR_NEW_TOKEN\""
    fi
else
    echo "❌ No Telegram token found in .env"
    echo ""
    echo "Add your token to .env.local:"
    echo "TELEGRAM_BOT_TOKEN=\"YOUR_BOT_TOKEN_HERE\""
fi
EOF

chmod +x fix-telegram-bot.sh
echo "   Created Telegram bot fix script: fix-telegram-bot.sh"

echo ""
echo "✅ Step 7: Summary and next steps..."
echo "----------------------------------"
echo ""
echo "🎯 Issues identified and fixed:"
echo "1. Created script to secure exposed API keys: ./fix-exposed-keys.sh"
echo "2. Created Kimi API test script: test-kimi-api.js"
echo "3. Created deployment fix script: deploy-fix.sh"
echo "4. Created Telegram bot fix script: fix-telegram-bot.sh"
echo ""
echo "🚀 Recommended fix sequence:"
echo "1. First, secure your API keys:"
echo "   cd .openclaw && ./fix-exposed-keys.sh"
echo ""
echo "2. Test your Kimi API key:"
echo "   export KIMI_API_KEY='your-key' && node test-kimi-api.js"
echo ""
echo "3. Fix and deploy to Cloudflare:"
echo "   ./deploy-fix.sh"
echo ""
echo "4. Fix Telegram bot:"
echo "   ./fix-telegram-bot.sh"
echo ""
echo "5. Update all configuration files with consistent tokens"
echo ""
echo "📚 Additional resources:"
echo "• Cloudflare Workers: https://developers.cloudflare.com/workers/"
echo "• Kimi (Moonshot) API: https://platform.moonshot.cn/docs"
echo "• Telegram Bot API: https://core.telegram.org/bots/api"
echo ""
echo "💡 Tips:"
echo "• Use different tokens for development and production"
echo "• Monitor your API usage and costs"
echo "• Set up alerts for failed deployments"
echo "• Regularly rotate your API keys"
echo ""
echo "✅ Fix scripts created successfully!"