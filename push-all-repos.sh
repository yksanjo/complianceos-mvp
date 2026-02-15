#!/bin/bash

# Replace with your GitHub username
GITHUB_USER="yourusername"

REPOS=(
  "stripe-integration-risk-scanner"
  "stripe-revenue-leak-detector"
  "stripe-compliance-as-code"
  "stripe-account-health-scoring"
  "stripe-reconciliation-engine"
  "stripe-webhook-chaos-tester"
  "stripe-kill-switch"
  "stripe-ai-policy-explainer"
)

echo "🚀 Pushing all Stripe products to GitHub..."
echo ""

for repo in "${REPOS[@]}"; do
  echo "📦 Processing $repo..."
  cd "$repo" || exit 1
  
  # Check if gh CLI is available
  if command -v gh &> /dev/null; then
    echo "  Creating GitHub repo..."
    gh repo create "$repo" --public --source=. --remote=origin 2>/dev/null || echo "  Repo may already exist, continuing..."
    echo "  Pushing to GitHub..."
    git push -u origin master 2>/dev/null || git push -u origin main 2>/dev/null
  else
    echo "  ⚠️  GitHub CLI not found. Please create repo manually:"
    echo "     https://github.com/new"
    echo "     Then run: git remote add origin https://github.com/$GITHUB_USER/$repo.git"
    echo "     Then run: git push -u origin master"
  fi
  
  cd ..
  echo "  ✅ $repo done"
  echo ""
done

echo "🎉 All repos processed!"
echo ""
echo "Next steps:"
echo "1. Update READMEs with correct GitHub URLs"
echo "2. Add topics to each repo on GitHub"
echo "3. Test each product"
echo "4. Share with Stripe team!"
