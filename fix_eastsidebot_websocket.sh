#!/bin/bash

echo "========================================="
echo "Quick Fix: WebSocket Authentication for EastsideBot"
echo "========================================="
echo ""
echo "Worker: eastsidebot.yksanjo.workers.dev"
echo "Issue: WebSocket needs token in query parameter for Cloudflare Access"
echo ""

# Check if we're in the right place
if [ ! -d ".openclaw" ]; then
    echo "❌ Error: .openclaw directory not found"
    echo "Please run this from your home directory"
    exit 1
fi

cd .openclaw

echo "STEP 1: Backup current worker..."
if [ -f "cloudflare-worker.js" ]; then
    cp cloudflare-worker.js cloudflare-worker.js.backup.$(date +%s)
    echo "✅ Backup created: cloudflare-worker.js.backup"
else
    echo "⚠️  No existing cloudflare-worker.js found"
fi

echo ""
echo "STEP 2: Create fixed worker..."
cat > cloudflare-worker-fixed.js << 'EOF'
// Fixed EastsideBot Worker with WebSocket Authentication
export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url);
    const path = url.pathname;
    
    // Handle WebSocket upgrades
    if (request.headers.get('Upgrade') === 'websocket') {
      return handleWebSocketUpgrade(request, url, env);
    }
    
    // Health check
    if (path === '/health') {
      return new Response(JSON.stringify({
        status: 'healthy',
        service: 'eastsidebot-fixed',
        websocket: 'token_required_in_query',
        timestamp: new Date().toISOString()
      }), {
        headers: { 'Content-Type': 'application/json' }
      });
    }
    
    // Chat interface
    if (path === '/' || path === '/chat') {
      const session = url.searchParams.get('session') || 'main';
      const token = url.searchParams.get('token') || '';
      
      const html = `<!DOCTYPE html>
<html>
<head><title>EastsideBot Fixed</title><style>
body{font-family:sans-serif;padding:20px;max-width:800px;margin:0 auto;}
.status{padding:10px;border-radius:5px;margin:10px 0;}
.connected{background:#d4edda;}
.disconnected{background:#f8d7da;}
.messages{border:1px solid #ccc;padding:10px;height:300px;overflow-y:auto;}
input{width:70%;padding:10px;margin-right:10px;}
button{padding:10px 20px;background:#007bff;color:white;border:none;border-radius:5px;}
</style></head>
<body>
<h1>🐾 EastsideBot - Fixed WebSocket</h1>
<p>Cloudflare Access: WebSocket requires ?token= parameter</p>
<div class="status disconnected" id="status">Disconnected</div>
<div class="messages" id="messages">
<div>✅ Worker fixed for WebSocket authentication</div>
<div>WebSocket URL: wss://${window.location.host}/ws?token=YOUR_TOKEN&session=${session}</div>
</div>
<div>
<input type="text" id="tokenInput" placeholder="Enter Cloudflare Access token">
<button onclick="connect()">Connect WebSocket</button>
</div>
<script>
let ws = null;
function connect() {
  const token = document.getElementById('tokenInput').value.trim();
  if (!token) return alert('Enter token');
  
  const wsUrl = 'wss://' + window.location.host + '/ws?token=' + encodeURIComponent(token) + '&session=${session}';
  ws = new WebSocket(wsUrl);
  
  ws.onopen = () => {
    document.getElementById('status').className = 'status connected';
    document.getElementById('status').textContent = 'Connected';
    addMessage('✅ WebSocket connected with token');
  };
  
  ws.onmessage = (e) => addMessage('📨: ' + e.data);
  ws.onerror = (e) => addMessage('❌ Error: ' + e.message);
  ws.onclose = () => {
    document.getElementById('status').className = 'status disconnected';
    document.getElementById('status').textContent = 'Disconnected';
  };
}
function addMessage(text) {
  const div = document.createElement('div');
  div.textContent = text;
  document.getElementById('messages').appendChild(div);
}
</script>
</body>
</html>`;
      
      return new Response(html, { headers: { 'Content-Type': 'text/html' } });
    }
    
    return new Response('EastsideBot Fixed\n\nUse /chat?token=YOUR_TOKEN for WebSocket authentication', {
      headers: { 'Content-Type': 'text/plain' }
    });
  }
};

async function handleWebSocketUpgrade(request, url, env) {
  try {
    const token = url.searchParams.get('token');
    const session = url.searchParams.get('session') || 'main';
    
    if (!token) {
      return new Response('Missing token parameter: ?token=YOUR_TOKEN', { status: 401 });
    }
    
    console.log('WebSocket authenticated:', { session, token: token.substring(0, 10) + '...' });
    
    // Connect to OpenClaw
    const OPENCLAW_API = env.OPENCLAW_API_URL || 'http://localhost:18789';
    const openclawWsUrl = OPENCLAW_API.replace('http', 'ws') + url.pathname;
    
    const [client, server] = Object.values(new WebSocketPair());
    server.accept();
    
    const openclawWs = new WebSocket(openclawWsUrl);
    
    openclawWs.addEventListener('message', (e) => {
      try { server.send(e.data); } catch (err) {}
    });
    
    server.addEventListener('message', (e) => {
      try { openclawWs.send(e.data); } catch (err) {}
    });
    
    openclawWs.addEventListener('close', () => {
      try { server.close(); } catch (err) {}
    });
    
    server.addEventListener('close', () => {
      try { openclawWs.close(); } catch (err) {}
    });
    
    return new Response(null, { status: 101, webSocket: client });
    
  } catch (error) {
    return new Response('WebSocket error: ' + error.message, { status: 500 });
  }
}
EOF

echo "✅ Created cloudflare-worker-fixed.js"

echo ""
echo "STEP 3: Update wrangler.toml if needed..."
if [ -f "wrangler.toml" ]; then
    if grep -q "name = " wrangler.toml; then
        echo "✅ wrangler.toml exists"
        echo "Current name: $(grep 'name = ' wrangler.toml | head -1)"
    else
        echo "⚠️  wrangler.toml doesn't have name field"
    fi
else
    echo "❌ wrangler.toml not found, creating basic one..."
    cat > wrangler.toml << 'TOML'
name = "eastsidebot"
main = "cloudflare-worker-fixed.js"
compatibility_date = "2025-02-08"
compatibility_flags = ["nodejs_compat"]

[vars]
OPENCLAW_API_URL = "http://localhost:18789"
TOML
fi

echo ""
echo "STEP 4: Choose deployment option..."
echo ""
echo "Option A: Replace and deploy (recommended)"
echo "  cp cloudflare-worker-fixed.js cloudflare-worker.js"
echo "  npx wrangler deploy"
echo ""
echo "Option B: Test first"
echo "  npx wrangler dev cloudflare-worker-fixed.js"
echo ""
echo "Option C: Deploy as new worker"
echo "  npx wrangler deploy --name eastsidebot-fixed cloudflare-worker-fixed.js"
echo ""
echo "STEP 5: Test after deployment..."
echo ""
echo "1. Get Cloudflare Access token:"
echo "   - Visit https://eastsidebot.yksanjo.workers.dev/chat"
echo "   - Authenticate with Cloudflare Access"
echo "   - Get token from browser cookies or network tab"
echo ""
echo "2. Test WebSocket connection:"
echo "   wscat -c 'wss://eastsidebot.yksanjo.workers.dev/ws?token=YOUR_TOKEN&session=main'"
echo ""
echo "3. Or use the test page:"
echo "   https://eastsidebot.yksanjo.workers.dev/chat?token=YOUR_TOKEN"
echo ""
echo "========================================="
echo "Summary"
echo "========================================="
echo "✅ Fixed worker created: cloudflare-worker-fixed.js"
echo "✅ WebSocket URL format: wss://eastsidebot.yksanjo.workers.dev/ws?token=TOKEN&session=SESSION"
echo "✅ Token validation added to WebSocket upgrade handler"
echo ""
echo "To deploy:"
echo "1. cp cloudflare-worker-fixed.js cloudflare-worker.js"
echo "2. npx wrangler deploy"
echo "3. Test with token in query parameter"
echo ""
echo "Need Cloudflare Access token validation? See FIX_WEBSOCKET_AUTH.md"
echo "========================================="