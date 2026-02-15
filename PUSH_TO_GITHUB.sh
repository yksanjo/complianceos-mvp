#!/bin/bash

echo "🚀 GitHub Push Helper for SaaS Suite"
echo "===================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get GitHub username
echo -n "Enter your GitHub username: "
read USERNAME

if [ -z "$USERNAME" ]; then
    echo "❌ Username is required"
    exit 1
fi

echo ""
echo -e "${BLUE}Pushing FeatureFlags.io...${NC}"
echo "================================"

cd feature-flags-platform

# Check if remote already exists
if git remote | grep -q "origin"; then
    git remote remove origin
fi

git remote add origin "https://github.com/$USERNAME/feature-flags-platform.git"
git branch -M main 2>/dev/null || true

echo ""
echo "📤 Pushing to https://github.com/$USERNAME/feature-flags-platform"
git push -u origin main

cd ..

echo ""
echo -e "${BLUE}Pushing WebhookPro...${NC}"
echo "================================"

cd webhook-management-platform

# Check if remote already exists
if git remote | grep -q "origin"; then
    git remote remove origin
fi

git remote add origin "https://github.com/$USERNAME/webhookpro.git"
git branch -M main 2>/dev/null || true

echo ""
echo "📤 Pushing to https://github.com/$USERNAME/webhookpro"
git push -u origin main

cd ..

echo ""
echo -e "${GREEN}✅ Both projects pushed to GitHub!${NC}"
echo ""
echo "Next steps:"
echo "1. Visit https://github.com/$USERNAME/feature-flags-platform"
echo "2. Visit https://github.com/$USERNAME/webhookpro"
echo "3. Add topics/tags in repository settings"
echo "4. Enable GitHub Actions"
echo "5. Deploy to Railway!"
