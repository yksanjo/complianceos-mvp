#!/bin/bash

# MCP Curator - Validate Now
# Run this RIGHT NOW to validate the idea

echo "⏱️  MCP Curator - 15-Minute Validation"
echo "======================================"
echo ""
echo "Let's validate this idea in 15 minutes."
echo ""

# Step 1: Check your own usage
echo "1. Check Your Own MCP Usage (2 minutes)"
echo "----------------------------------------"
echo ""
echo "📊 Answer these questions:"
echo ""
echo "Q1: How many MCP servers do you use regularly?"
echo "Q2: What's your estimated monthly cost for AI agents/LLMs?"
echo "Q3: Would you pay $49/month to save 30% on those costs?"
echo ""
read -p "Press Enter after answering..."

# Step 2: Quick Twitter validation
echo ""
echo "2. Quick Twitter Validation (5 minutes)"
echo "----------------------------------------"
echo ""
echo "🐦 Send this tweet (or DM to 3 AI developers):"
echo ""
echo "   'Quick validation: Would you pay $49/month for a service that saves 30% on MCP server costs by intelligently routing between 14,000+ servers?'"
echo ""
echo "💡 Better: DM people who:"
echo "   - Build with MCP"
echo "   - Tweet about AI agents"
echo "   - Complain about LLM costs"
echo ""
read -p "Press Enter after sending..."

# Step 3: Check database readiness
echo ""
echo "3. Database Readiness (3 minutes)"
echo "----------------------------------"
echo ""
echo "🗄️  Check if you can run the SQL:"
echo ""
echo "A. Go to: https://supabase.com"
echo "B. Open your MCP Discovery project"
echo "C. Go to SQL Editor"
echo "D. Check if you can run:"
echo "   mcp-discovery/src/db/mcp-curator-schema.sql"
echo ""
read -p "Press Enter after checking..."

# Step 4: Quick local test
echo ""
echo "4. Quick Local Test (5 minutes)"
echo "--------------------------------"
echo ""
echo "🧪 Let's test the API locally:"
echo ""

cd mcp-discovery

# Check if we can build
echo "📦 Checking build..."
if npm run build 2>&1 | grep -q "error"; then
    echo "❌ Build failed. Check TypeScript errors."
else
    echo "✅ Build successful!"
    
    # Start API
    echo "🚀 Starting API (will run for 30 seconds)..."
    timeout 30 npm run dev:api &
    sleep 5
    
    # Test health endpoint
    echo "🧪 Testing health endpoint..."
    curl -s http://localhost:3000/health | jq '.status' 2>/dev/null || echo "❌ API not responding"
    
    # Test demo endpoint
    echo "🧪 Testing demo endpoint..."
    curl -s -X POST http://localhost:3000/api/v1/curator/recommend \
      -H "Content-Type: application/json" \
      -d '{"task": "query postgres database"}' | jq '.recommendations[0].name' 2>/dev/null || echo "❌ Demo endpoint failed"
    
    sleep 20
fi

cd ..

echo ""
echo "======================================"
echo "🎯 Validation Complete!"
echo "======================================"
echo ""
echo "Based on your validation:"
echo ""
echo "✅ If you got positive responses:"
echo "   → Deploy NOW: ./RUN_MCP_CURATOR.sh"
echo ""
echo "⚠️  If responses were mixed:"
echo "   → Offer manual optimization first"
echo "   → Save someone $100, charge $20"
echo "   → Then build software"
echo ""
echo "❌ If no interest:"
echo "   → Pivot to another idea"
echo "   → Or validate with different messaging"
echo ""
echo "💰 Remember:"
echo "   The goal is to find ONE person who will pay."
echo "   Even $20 for manual service proves the business."
echo ""
echo "🚀 Next Step:"
echo "   Run ./RUN_MCP_CURATOR.sh to deploy"
echo "   OR"
echo "   Offer manual optimization to first potential customer"
echo ""
echo "Time spent: 15 minutes"
echo "Potential upside: $490 MRR (10 customers)"
echo ""
echo "Good luck! 🚀"