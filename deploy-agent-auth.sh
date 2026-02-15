#!/bin/bash

# Direct deployment of AgentAuth MVP to Vercel

echo "🚀 DEPLOYING AGENTAUTH MVP TO VERCEL..."
echo "========================================"

# Create a clean deployment directory
DEPLOY_DIR="/tmp/agent-auth-vercel-deploy-$(date +%s)"
echo "Creating deployment directory: $DEPLOY_DIR"
mkdir -p "$DEPLOY_DIR"

# Copy all frontend files
echo "Copying frontend files..."
cp -r /Users/yoshikondo/agent-auth-mvp/frontend/* "$DEPLOY_DIR/"
cp /Users/yoshikondo/agent-auth-mvp/frontend/.gitignore "$DEPLOY_DIR/" 2>/dev/null || true

# Create vercel.json
echo "Creating Vercel configuration..."
cat > "$DEPLOY_DIR/vercel.json" << 'EOF'
{
  "version": 2,
  "builds": [
    {
      "src": "package.json",
      "use": "@vercel/next"
    }
  ]
}
EOF

# Test build
echo "Testing build..."
cd "$DEPLOY_DIR"
if npm run build > /tmp/build.log 2>&1; then
  echo "✅ Build successful!"
  echo "Build log saved to: /tmp/build.log"
else
  echo "❌ Build failed. Check /tmp/build.log for details"
  cat /tmp/build.log | tail -20
  exit 1
fi

echo ""
echo "🎯 DEPLOYMENT PACKAGE READY!"
echo "============================="
echo ""
echo "To deploy:"
echo ""
echo "1. OPEN IN BROWSER:"
echo "   https://vercel.com/new"
echo ""
echo "2. DRAG AND DROP:"
echo "   Drag the folder '$DEPLOY_DIR' into the Vercel upload area"
echo ""
echo "3. OR USE GIT:"
echo "   - Select 'Import Git Repository'"
echo "   - Choose: yksanjo/agent-auth-mvp"
echo "   - Set 'Root Directory' to 'frontend'"
echo ""
echo "4. CLICK 'DEPLOY'"
echo ""
echo "🌐 Your site will be live at: https://agent-auth-mvp.vercel.app"
echo ""
echo "📁 Deployment files are in: $DEPLOY_DIR"
echo "   You can also run: cd $DEPLOY_DIR && vercel --prod"
echo ""
echo "✅ Ready for deployment!"