# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a portfolio repository containing 6 production-ready security and AI projects, plus numerous other experimental projects. The main security projects are located in their own subdirectories:

- **topoguard/** - Topology-Inspired Anomaly Detection for FinTech (Python/FastAPI)
- **tinyguardian/** - On-Device LLM + IoT Security Agent (Python/FastAPI/Ollama)
- **captcha-fights-back/** - Adaptive Behavioral CAPTCHA with LLM (Python/Flask)
- **meshlock/** - Decentralized Secure Mesh for IoT (Rust)
- **finprompt/** - Local LLM for Secure Financial Querying (Python/Tauri)
- **hack-toolkit/** - Collection of security scripts (Python)

Each project is a standalone git repository designed to be pushed to GitHub separately.

## Common Development Commands

### Python Projects (TopoGuard, TinyGuardian, FinPrompt, CAPTCHA)

**Setup:**
```bash
cd <project-name>
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
```

**Run API server:**
```bash
# TopoGuard
cd topoguard
uvicorn api.main:app --reload --port 8000

# TinyGuardian
cd tinyguardian
python main.py  # Starts on port 8080

# CAPTCHA
cd captcha-fights-back
python app.py
```

**Testing:**
```bash
pytest tests/
pytest --cov=<project-name> tests/  # With coverage
```

**Code quality:**
```bash
black <project-name>/
isort <project-name>/
mypy <project-name>/
ruff check <project-name>/  # For TopoGuard
```

**Generate sample data:**
```bash
# TopoGuard
python scripts/generate_sample_data.py --transactions 10000 --output data/sample_transactions.json
python scripts/run_detection.py --input data/sample_transactions.json

# TinyGuardian
python scripts/simulate_iot_logs.py
```

### Rust Projects (MeshLock)

**Build:**
```bash
cd meshlock
cargo build --release
```

**Run:**
```bash
cargo run --release
```

**Test:**
```bash
cargo test
```

### TypeScript/Next.js Projects (Various)

Many projects use Next.js. Common commands:
```bash
npm install
npm run dev      # Development server (usually http://localhost:3000)
npm run build    # Production build
npm run start    # Production server
npm run lint     # ESLint
```

**Deploy to Vercel:**
```bash
# Install Vercel CLI if needed
npm i -g vercel

# Deploy to production
vercel --prod

# Or link to existing project
vercel link
vercel --prod
```

## High-Level Architecture

### Python Security Projects Structure

All Python projects follow a similar modular architecture:

```
project-name/
├── project_name/          # Main package
│   ├── __init__.py
│   └── core/             # Core logic modules
│       ├── detector.py / guardian.py / analyzer.py
│       └── [specific modules]
├── api/                  # FastAPI/Flask REST API
│   └── main.py
├── config/               # Configuration files
│   └── config.yaml
├── scripts/              # Utility scripts
│   ├── generate_sample_data.py
│   └── run_detection.py
├── data/                 # Data directory
├── docs/                 # Documentation
│   └── screenshots/      # Screenshot placeholders
├── requirements.txt
└── README.md
```

### TopoGuard Architecture

**Core Components:**
- `graph_builder.py` - Builds transaction graphs from streams
- `topology_analyzer.py` - Performs TDA using persistent homology
- `detector.py` - Main orchestrator combining graph and topology analysis

**Data Flow:**
Transaction Stream → Graph Builder → TDA Engine → Anomaly Detector → Alert Dashboard

**Key Dependencies:**
- TDA libraries: giotto-tda, gudhi, ripser, persim
- Graph analysis: networkx
- API: FastAPI

### TinyGuardian Architecture

**Core Components:**
- `guardian.py` - Main monitoring orchestrator
- `llm_client.py` - LLM integration (Ollama/LM Studio/llama.cpp)
- `threat_classifier.py` - Threat categorization logic

**Data Flow:**
IoT Devices → MQTT Broker → Log Collector → Local LLM Analyzer → Threat Classifier → Web Dashboard

**Key Dependencies:**
- LLM: ollama, llama-cpp-python
- MQTT: paho-mqtt
- API: FastAPI

### CAPTCHA Fights Back Architecture

**Core Components:**
- `captcha_generator.py` - LLM-powered challenge generation
- `behavioral_analyzer.py` - Behavioral fingerprinting
- `browser_fingerprint.py` - Browser fingerprinting
- `topology_hasher.py` - Topological hashing of user paths

**Framework:** Flask with NetworkX for graph analysis

### MeshLock Architecture

**Language:** Rust with Tokio async runtime

**Core Concepts:**
- Cryptographic identity based on network topology
- Self-organizing mesh using gossip protocols
- Noise Protocol for encryption
- Sybil resistance through topology verification

### Next.js Projects Architecture

Multiple Next.js applications use modern React patterns with the App Router (Next.js 16+). Common projects include:
- **meowscope/** - Audio analysis tool with Stripe integration
- **linkedin-face-crm/** - Face recognition CRM with Supabase
- **electrical-estimator-ai/** - AI-powered electrical estimation with OpenAI
- Plus numerous Stripe-related tools and dashboards

**Standard Tech Stack:**
- Next.js 16.1+ with App Router
- React 19+ with Server Components
- TypeScript 5+
- Tailwind CSS 4 (PostCSS-based)
- ESLint for code quality

**Project Structure:**
```
project-name/
├── app/                      # App Router (Next.js 13+ convention)
│   ├── layout.tsx           # Root layout
│   ├── page.tsx             # Home page
│   ├── globals.css          # Global styles
│   ├── api/                 # API routes (Route Handlers)
│   │   ├── webhooks/
│   │   │   └── route.ts     # Webhook endpoints
│   │   ├── checkout/
│   │   │   └── route.ts     # Checkout API
│   │   └── [other-routes]/
│   ├── auth/                # Auth routes
│   │   └── callback/        # OAuth callbacks
│   ├── dashboard/           # Protected routes
│   │   ├── page.tsx
│   │   └── [id]/            # Dynamic routes
│   └── [other-routes]/
├── components/              # React components
│   ├── ComponentName.tsx
│   └── [other-components]/
├── lib/                     # Utility libraries
│   ├── supabase/           # Supabase client & middleware
│   │   ├── client.ts       # Browser client
│   │   ├── server.ts       # Server client
│   │   └── middleware.ts   # Auth middleware
│   ├── stripe.ts           # Stripe configuration
│   ├── openai.ts           # OpenAI configuration
│   └── s3.ts               # AWS S3 configuration
├── public/                  # Static assets
├── middleware.ts            # Next.js middleware (auth, redirects)
├── .env.local              # Environment variables (not committed)
├── .env.example            # Environment variable template
├── next.config.ts          # Next.js configuration
├── tailwind.config.ts      # Tailwind configuration
├── tsconfig.json           # TypeScript configuration
└── package.json
```

**Common Integrations:**

1. **Supabase (Database & Auth)**
   - Location: `lib/supabase/`
   - Client types: Browser client, Server client, Middleware
   - Used for: Authentication, database, real-time subscriptions
   - Environment variables:
     - `NEXT_PUBLIC_SUPABASE_URL`
     - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
     - `SUPABASE_SERVICE_ROLE_KEY`

2. **Stripe (Payments)**
   - Location: `lib/stripe.ts`
   - Used for: Subscriptions, one-time payments, webhooks
   - API routes: `/api/checkout`, `/api/webhooks`, `/api/create-portal-session`
   - Environment variables:
     - `NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY`
     - `STRIPE_SECRET_KEY`
     - `STRIPE_WEBHOOK_SECRET`
     - `NEXT_PUBLIC_STRIPE_[TIER]_PRICE_ID`

3. **OpenAI (AI Features)**
   - Location: `lib/openai.ts`
   - Used for: AI-powered features, content generation, analysis
   - Environment variables:
     - `OPENAI_API_KEY`

4. **AWS S3 (File Storage)**
   - Location: `lib/s3.ts`
   - Used for: File uploads, media storage
   - Environment variables:
     - `AWS_ACCESS_KEY_ID`
     - `AWS_SECRET_ACCESS_KEY`
     - `AWS_REGION`
     - `AWS_S3_BUCKET_NAME`

**Middleware Pattern:**

Most projects use Next.js middleware for authentication:
```typescript
// middleware.ts
import { type NextRequest } from 'next/server';
import { updateSession } from '@/lib/supabase/middleware';

export async function middleware(request: NextRequest) {
  return await updateSession(request);
}

export const config = {
  matcher: [
    '/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)',
  ],
};
```

**Server Components vs Client Components:**
- Default: Server Components (for data fetching, SEO)
- Client Components: Add `'use client'` directive for:
  - Interactive UI (useState, useEffect)
  - Browser APIs (localStorage, audio/video)
  - Event handlers

**API Routes (Route Handlers):**
- Located in `app/api/*/route.ts`
- Support GET, POST, PUT, DELETE, PATCH
- Return `Response` or `NextResponse` objects
- Used for webhooks, server-side API calls, backend logic

**Environment Variables:**
- Development: `.env.local` (not committed)
- Template: `.env.example` (committed)
- Public vars: Prefix with `NEXT_PUBLIC_`
- Server-only vars: No prefix (only accessible in server components/routes)

**Deployment:**
- Platform: Vercel (primary)
- Automatic deployments from git push
- Environment variables configured in Vercel dashboard
- Production URL pattern: `https://project-name.vercel.app`

**Common Patterns:**

1. **Protected Routes:**
   - Use middleware to check authentication
   - Redirect unauthenticated users to `/login`
   - Server-side session validation

2. **Database Queries:**
   - Server Components: Direct Supabase queries
   - Client Components: API routes or client-side queries
   - Use Supabase RLS (Row Level Security)

3. **Form Handling:**
   - Libraries: react-hook-form, zod for validation
   - Server Actions for mutations (Next.js 14+)
   - API routes for complex logic

4. **Stripe Webhooks:**
   - Endpoint: `/api/webhooks/route.ts`
   - Verify signature with `STRIPE_WEBHOOK_SECRET`
   - Handle events: `checkout.session.completed`, `customer.subscription.updated`
   - Update database on successful payments

## Development Workflow

### Working on Individual Projects

Each project is isolated. When working on a specific project:

1. Navigate to the project directory
2. Activate the appropriate environment (Python venv, cargo environment, etc.)
3. Make changes within that project's structure
4. Test using the project-specific test commands
5. Commit changes to that project's git repository

### Working with Next.js Projects

**Initial Setup:**
```bash
cd <project-name>
npm install
cp .env.example .env.local  # Copy and fill in environment variables
```

**Environment Variables Setup:**
1. Copy `.env.example` to `.env.local`
2. Fill in required values:
   - Supabase: Create project at supabase.com, get URL and keys
   - Stripe: Get keys from stripe.com/dashboard
   - OpenAI: Get API key from platform.openai.com
   - AWS: Configure S3 bucket and IAM credentials
3. Never commit `.env.local` (already in `.gitignore`)

**Development Workflow:**
```bash
npm run dev  # Start dev server on http://localhost:3000
# Make changes - hot reload is automatic
npm run lint  # Check for errors
npm run build  # Test production build
```

**Common Development Tasks:**

1. **Adding a new page:**
   - Create `app/new-route/page.tsx`
   - Add layout if needed: `app/new-route/layout.tsx`

2. **Adding an API endpoint:**
   - Create `app/api/endpoint-name/route.ts`
   - Export GET, POST, or other HTTP method handlers

3. **Creating a component:**
   - Add to `components/ComponentName.tsx`
   - Use `'use client'` if it needs interactivity
   - Import in pages with `@/components/ComponentName`

4. **Database queries (Supabase):**
   - Server Components: Use `lib/supabase/server.ts`
   - Client Components: Use `lib/supabase/client.ts`
   - Always check for errors in response

5. **Testing Stripe integration locally:**
   - Use Stripe CLI: `stripe listen --forward-to localhost:3000/api/webhooks`
   - Get webhook signing secret and add to `.env.local`
   - Test checkout with test card: 4242 4242 4242 4242

**Debugging:**
- Check browser console for client-side errors
- Check terminal for server-side errors
- Use `console.log()` liberally (removed automatically in production)
- Inspect Network tab for API requests
- Check Vercel logs for production issues

**Deployment to Vercel:**
```bash
# First time
vercel
# Follow prompts to link project

# Deploy to production
vercel --prod

# Check deployment
vercel ls
```

**Environment Variables in Vercel:**
1. Go to Vercel dashboard → Project → Settings → Environment Variables
2. Add all variables from `.env.local`
3. Select environments: Production, Preview, Development
4. Redeploy for changes to take effect

### LLM Integration (TinyGuardian, FinPrompt)

Projects using local LLMs require Ollama or similar to be running:

```bash
# Install Ollama first (see ollama.ai)
ollama pull phi3:mini  # or tinyllama, mistral:7b-instruct-q4_K_M
```

Configuration is in `config/config.yaml`:
```yaml
llm:
  provider: "ollama"
  model: "phi3:mini"
  base_url: "http://localhost:11434"
```

### TDA Projects (TopoGuard, CAPTCHA)

Projects using Topological Data Analysis:
- Persistent homology computed via ripser/gudhi
- Features extracted: total persistence, number of features, max persistence
- Topology complexity scores used for anomaly detection
- Visualization via persistence diagrams (plotly/matplotlib)

## GitHub Workflow

Projects are designed to be pushed to GitHub as separate repositories.

**Setup remotes:**
```bash
cd <project-name>
git remote add origin https://github.com/yksanjo/<project-name>.git
git branch -M main
git push -u origin main
```

See GITHUB_SETUP.md for detailed instructions.

## Configuration Files

**Python Projects:**
- `config/config.yaml` - Main configuration
- `.env` files for secrets (not committed)

**Next.js Projects:**
- `.env.local` - Local environment variables (not committed)
- `.env.example` - Template for required variables (committed)
- `next.config.ts` - Next.js configuration
- `tailwind.config.ts` - Tailwind CSS configuration
- `tsconfig.json` - TypeScript compiler options
- `eslint.config.mjs` - ESLint rules

## Privacy & Security Philosophy

These projects emphasize:
- **Local-first processing** - No cloud dependencies where possible
- **Privacy-preserving** - Data stays on-device
- **Mathematically grounded** - Uses topology, graph theory
- **CISO-friendly** - Transparent, auditable, explainable
- **Production-ready** - Comprehensive error handling and logging

## Important Notes

- Each project has its own git repository (`.git` directory)
- Projects are independent - changes in one don't affect others
- Screenshots are placeholders in `docs/screenshots/` - need to be captured
- All projects use MIT License
- Configuration should never contain hardcoded secrets
- LLM projects require local model installation (Ollama recommended)
- Next.js projects require environment variables to be set before running
- Never commit `.env.local` files - they contain sensitive credentials
- Use `.env.example` as a template for required environment variables
- Most Next.js projects are deployed on Vercel with automatic deployments

## Repository Organization

The root directory contains many projects. Key organizational files:
- **README.md** - Portfolio overview with all 6 main projects
- **GITHUB_SETUP.md** - Instructions for pushing to GitHub
- **LICENSE** - MIT License for the cursor-auto-approve-agent code
- Individual project directories are self-contained

## Dependencies

Projects may share similar dependencies but maintain separate `requirements.txt`, `Cargo.toml`, or `package.json` files. Always install dependencies within each project's directory.

**Python Projects:**
- Install with: `pip install -r requirements.txt`
- Use virtual environments: `python -m venv venv`

**Rust Projects:**
- Dependencies in `Cargo.toml`
- Install automatically with: `cargo build`

**Next.js Projects:**
- Dependencies in `package.json`
- Install with: `npm install`
- Common dependencies:
  - Core: next, react, react-dom, typescript
  - Styling: tailwindcss
  - Integrations: @supabase/supabase-js, stripe, openai
  - Forms: react-hook-form, zod
  - UI: lucide-react (icons)

## API Documentation

Python projects using FastAPI include interactive API docs:
- Navigate to `http://localhost:<port>/docs` for Swagger UI
- Navigate to `http://localhost:<port>/redoc` for ReDoc

## Performance Considerations

**Python Projects:**
- **TopoGuard**: <100ms latency, 10K transactions/second
- **TinyGuardian**: <2s per log analysis on Raspberry Pi 4
- Projects are designed for resource-constrained environments where applicable

**Next.js Projects:**
- Server Components used by default for optimal performance
- Image optimization with Next.js Image component
- Automatic code splitting and lazy loading
- Edge runtime for API routes when appropriate
- Vercel Edge Network for global CDN
- Build-time optimizations with `npm run build`
- Lighthouse scores typically 90+ for performance
