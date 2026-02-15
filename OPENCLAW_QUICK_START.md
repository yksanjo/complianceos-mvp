# OpenClaw (Moltworker) Quick Start Guide

Based on the Cloudflare blog post about Moltworker - running Moltbot (now OpenClaw) on Cloudflare Workers.

## What is OpenClaw/Moltworker?

OpenClaw (formerly Moltbot) is a self-hosted personal AI agent that runs on Cloudflare's edge infrastructure using:
- **Cloudflare Workers** - Serverless compute at the edge
- **Sandbox SDK** - Isolated container environment
- **Browser Rendering** - Headless browser automation
- **R2 Storage** - Persistent data storage
- **AI Gateway** - Unified AI provider management

## Prerequisites

1. **Cloudflare Workers Paid Plan** ($5/month) - Required for Sandbox Containers
2. **Node.js** and **npm** installed
3. **Anthropic API Key** (Claude) - Or use AI Gateway's Unified Billing

## Quick Setup

### Step 1: Login to Wrangler
```bash
cd moltworker
npx wrangler login
```

### Step 2: Run Setup Script
```bash
./setup_openclaw.sh
```

### Or Manual Setup:

```bash
# Install dependencies
npm install

# Set your Anthropic API Key
echo "your-anthropic-api-key" | npx wrangler secret put ANTHROPIC_API_KEY

# Generate and set gateway token
export TOKEN=$(openssl rand -base64 32 | tr -d '=+/' | head -c 32)
echo "Your Gateway Token: $TOKEN"
echo "$TOKEN" | npx wrangler secret put MOLTBOT_GATEWAY_TOKEN

# Deploy
npm run deploy
```

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    Cloudflare Edge                          │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐  │
│  │    Worker    │◄──►│   Sandbox    │◄──►│   Browser    │  │
│  │  (API/Auth)  │    │  (Moltbot)   │    │  (CDP/Render)│  │
│  └──────────────┘    └──────────────┘    └──────────────┘  │
│         │                   │                               │
│         ▼                   ▼                               │
│  ┌──────────────┐    ┌──────────────┐                      │
│  │Cloudflare    │    │     R2       │                      │
│  │Access (Auth) │    │  (Storage)   │                      │
│  └──────────────┘    └──────────────┘                      │
└─────────────────────────────────────────────────────────────┘
```

## Key Features

### 1. AI Gateway Integration
```bash
# Instead of direct Anthropic API
echo "your-gateway-api-key" | npx wrangler secret put AI_GATEWAY_API_KEY
echo "https://gateway.ai.cloudflare.com/v1/ACCOUNT_ID/GATEWAY_ID/anthropic" | npx wrangler secret put AI_GATEWAY_BASE_URL
```

Benefits:
- Centralized API key management
- Request caching
- Rate limiting
- Cost analytics
- Unified billing (no API keys needed!)

### 2. Browser Automation
The CDP (Chrome DevTools Protocol) shim allows Moltbot to:
- Take screenshots
- Navigate websites
- Fill forms
- Extract data
- Record videos

### 3. Persistent Storage (R2)
Mount R2 bucket for persistent data:
- Conversation history
- Paired devices
- Configuration files

### 4. Multi-Channel Support
- Telegram
- Discord
- Slack
- Web Control UI

## Access URLs

After deployment:

| URL | Purpose | Auth Required |
|-----|---------|---------------|
| `/?token=YOUR_TOKEN` | Control UI | Gateway Token |
| `/_admin/` | Admin UI | Cloudflare Access |
| `/api/*` | API endpoints | Cloudflare Access |
| `/debug/*` | Debug endpoints | Cloudflare Access |

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `ANTHROPIC_API_KEY` | Yes* | Direct API key |
| `AI_GATEWAY_API_KEY` | Yes* | AI Gateway key |
| `AI_GATEWAY_BASE_URL` | Yes* | Gateway endpoint |
| `MOLTBOT_GATEWAY_TOKEN` | Yes | Gateway auth token |
| `CF_ACCESS_TEAM_DOMAIN` | No | Access team domain |
| `CF_ACCESS_AUD` | No | Access application AUD |
| `R2_ACCESS_KEY_ID` | No | R2 access key |
| `R2_SECRET_ACCESS_KEY` | No | R2 secret key |
| `CF_ACCOUNT_ID` | No | Cloudflare account ID |
| `TELEGRAM_BOT_TOKEN` | No | Telegram integration |
| `DISCORD_BOT_TOKEN` | No | Discord integration |
| `CDP_SECRET` | No | Browser automation secret |

*Use either Anthropic direct OR AI Gateway

## Local Development

```bash
# Create .dev.vars file
cat > .dev.vars << 'EOF'
ANTHROPIC_API_KEY=sk-ant-...
DEV_MODE=true
DEBUG_ROUTES=true
MOLTBOT_GATEWAY_TOKEN=dev-token
EOF

# Run locally
npm run dev
```

## Important Notes

1. **First Request**: Cold starts take 1-2 minutes
2. **Container Sleep**: Set `SANDBOX_SLEEP_AFTER=never` to keep container warm
3. **Device Pairing**: New devices must be approved in Admin UI
4. **R2 Mounting**: Only works in production (not in `wrangler dev`)

## Troubleshooting

```bash
# View logs
npx wrangler tail

# List secrets
npx wrangler secret list

# Check deployment
npx wrangler deploy --dry-run
```

## Resources

- [OpenClaw/Moltbot](https://molt.bot/)
- [Moltworker GitHub](https://github.com/cloudflare/moltworker)
- [Cloudflare Sandbox Docs](https://developers.cloudflare.com/sandbox/)
- [AI Gateway Docs](https://developers.cloudflare.com/ai-gateway/)
- [Browser Rendering](https://developers.cloudflare.com/browser-rendering/)

## From the Blog Post

Key highlights:
- Node.js compatibility: 98.5% of top 1000 NPM packages work
- Sandboxes provide secure, isolated environments
- Browser Rendering supports Puppeteer, Playwright, Stagehand
- AI Gateway supports multiple providers with unified billing
- R2 provides S3-compatible object storage

---

**Ready to deploy?** Run `./moltworker/setup_openclaw.sh` and follow the prompts!
