#!/bin/bash
# Quick script to push all projects to GitHub (after repos are created)

set -e

GITHUB_USER="yksanjo"
PROJECTS=(
    "topoguard"
    "tinyguardian"
    "captcha-fights-back"
    "meshlock"
    "finprompt"
    "hack-toolkit"
)

echo "🚀 Quick Push to GitHub"
echo "======================"
echo ""

for project in "${PROJECTS[@]}"; do
    echo "📦 Processing $project..."
    cd "$project"
    
    # Check if already has remote
    if git remote | grep -q origin; then
        echo "  Remote already exists, updating..."
        git remote set-url origin "https://github.com/$GITHUB_USER/$project.git"
    else
        echo "  Adding remote..."
        git remote add origin "https://github.com/$GITHUB_USER/$project.git"
    fi
    
    # Ensure branch is main
    git branch -M main 2>/dev/null || true
    
    # Push
    echo "  Pushing to GitHub..."
    if git push -u origin main 2>&1; then
        echo "  ✅ Successfully pushed $project"
    else
        echo "  ⚠️  Failed to push $project (repository may not exist yet)"
        echo "     Create it at: https://github.com/new?name=$project"
    fi
    
    cd ..
    echo ""
done

echo "✅ Done! Check your repositories at:"
echo "   https://github.com/$GITHUB_USER"




