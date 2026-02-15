#!/bin/bash
# Push all projects to GitHub

set -e

PROJECTS=(
    "topoguard"
    "tinyguardian"
    "captcha-fights-back"
    "meshlock"
    "finprompt"
    "hack-toolkit"
)

GITHUB_USER="yksanjo"

echo "🚀 Pushing all projects to GitHub..."
echo ""

for project in "${PROJECTS[@]}"; do
    echo "📤 Pushing $project..."
    cd "$project"
    
    # Check if remote exists
    if ! git remote | grep -q origin; then
        echo "  Adding remote origin..."
        git remote add origin "https://github.com/$GITHUB_USER/$project.git"
    fi
    
    # Set main branch
    git branch -M main 2>/dev/null || true
    
    # Push to GitHub
    echo "  Pushing to GitHub..."
    if git push -u origin main 2>&1 | grep -q "remote: Repository not found"; then
        echo "  ⚠ Repository not found on GitHub. Create it first at:"
        echo "     https://github.com/new?name=$project"
    else
        echo "  ✓ Pushed successfully"
    fi
    
    cd ..
    echo ""
done

echo "✅ Done!"




