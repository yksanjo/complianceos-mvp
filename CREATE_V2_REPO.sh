#!/bin/bash
# Create and push mcp-discovery-v2 to GitHub

echo "🚀 Creating MCP Discovery V2 Repository"
echo "========================================"
echo ""

# Create directory
V2_DIR="$HOME/mcp-discovery-v2-repo"
mkdir -p "$V2_DIR"
cd "$V2_DIR" || exit 1

echo "📁 Created: $V2_DIR"
echo ""

# Copy files
cp /Users/yoshikondo/mcp-discovery-v2/README.md ./README.md
cp /Users/yoshikondo/mcp-discovery-v2/landing-page.html ./landing-page.html

echo "📄 Files copied:"
echo "   - README.md (with 14,000+ servers)"
echo "   - landing-page.html"
echo ""

# Initialize git
git init
git add .
git commit -m "🚀 Initial commit: MCP Discovery V2

The world's largest MCP server index:
- 14,000+ MCP servers indexed
- Semantic search with ~50ms response time
- Aggregated from Glama, NPM, GitHub, Awesome Lists
- LangChain & AutoGPT integrations
- Free API, no signup required

https://mcp-discovery-two.vercel.app"

echo "✅ Git repository initialized"
echo ""

echo "========================================"
echo "🎉 V2 Repo Ready at: $V2_DIR"
echo "========================================"
echo ""
echo "NEXT STEPS:"
echo ""
echo "1. Create repo on GitHub:"
echo "   → https://github.com/new"
echo "   → Name: mcp-discovery-v2"
echo "   → Description: 🔍 Semantic search for 14,000+ MCP servers"
echo "   → Public ✓"
echo "   → Click 'Create repository'"
echo ""
echo "2. Push to GitHub (run these commands):"
echo ""
echo "   cd $V2_DIR"
echo "   git remote add origin https://github.com/yksanjo/mcp-discovery-v2.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "3. Add topics on GitHub:"
echo "   mcp, model-context-protocol, ai-agents, semantic-search, langchain, autogpt"
echo ""
echo "4. Pin to your profile"
echo ""
echo "📍 Repo location: $V2_DIR"
echo ""
