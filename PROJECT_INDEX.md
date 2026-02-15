# Project Index

Central reference for all active projects in this repository.

## 🏗️ Monorepos (Consolidated)

| Monorepo | Components | Status |
|----------|------------|--------|
| **mcp-platform/** | discovery, router, guard, dashboard | 🚧 In Progress |
| **agent-platform/** | auth, compliance, cost-tracker, dashboard | 🚧 In Progress |
| **stripe-devkit/** | 8 Stripe tools | ✅ Ready |
| **unified-scraper/** | scraping framework with adapters | 🚧 In Progress |

## 🤖 Key Active Projects

| Project | Description | Tech | Status |
|---------|-------------|------|--------|
| **agentchat/** | Multi-agent chat system | Node.js | ✅ Active |
| **moltworker/** | Cloudflare agent runtime | TypeScript | ✅ Active |
| **beat-sensei/** | AI music production assistant | Python | 🎵 Music |
| **linkedin-face-crm/** | LinkedIn + facial recognition CRM | Python/TS | 🔍 Research |
| **death-of-saas/** | SaaS extensibility engine | TypeScript | ✅ Active |
| **signalfox/** | Signal-based recruitment | Python | 🔍 Research |
| **llm-native-scrapers/** | AI-powered LLM scraping (ScrapeGraphAI-style) | Python | ✅ Ready |
| **meowscope/** | Medical/health AI (check) | ??? | ❓ Unknown |

## 🛠️ Tools & Utilities

| Tool | Purpose | Location |
|------|---------|----------|
| github_fork_scraper.py | GitHub fork analysis | unified-scraper/adapters/ |
| crunchbase_scraper_2025.py | Crunchbase data extraction | unified-scraper/adapters/ |
| music_hall_discord_bot.py | Discord music bot | archive/ (stale) |
| metrics_dashboard.py | Usage analytics | Root |

## 📁 Directory Structure

```
/Users/yoshikondo/
├── mcp-platform/          # MCP server management platform
├── agent-platform/        # Agent infrastructure monorepo
├── stripe-devkit/         # Stripe development toolkit
├── unified-scraper/       # Multi-source scraping framework
├── deployment-configs/    # Standardized deployment configs
├── archive/               # Archived/stale projects
│   ├── docs/             # Archived documentation
│   └── <projects>        # Individual archived projects
└── <individual projects> # Active standalone projects
```

## 🚀 Quick Commands

```bash
# Navigate to monorepo
cd mcp-platform
cd agent-platform
cd stripe-devkit

# Check archived projects
ls archive/

# Find project docs
cat PROJECT_INDEX.md
```

## 📝 Notes

- **Monorepos** contain merged projects with shared infrastructure
- **Archive/** holds stale/incomplete projects for reference
- **Root level** projects are standalone and active
- See individual READMEs for specific project details

Last updated: $(date '+%Y-%m-%d')
