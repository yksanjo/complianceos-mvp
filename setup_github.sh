#!/bin/bash
# Setup script to initialize git repositories and prepare for GitHub

set -e

PROJECTS=(
    "topoguard"
    "tinyguardian"
    "captcha-fights-back"
    "meshlock"
    "finprompt"
    "hack-toolkit"
)

echo "🚀 Setting up GitHub repositories for all projects..."
echo ""

for project in "${PROJECTS[@]}"; do
    echo "📦 Setting up $project..."
    cd "$project"
    
    # Initialize git if not already done
    if [ ! -d ".git" ]; then
        git init
        echo "  ✓ Initialized git repository"
    fi
    
    # Add all files
    git add .
    
    # Create initial commit
    if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
        git commit -m "Initial commit: $project

- Complete project setup
- Documentation with UX/UI descriptions
- Production-ready code
- MIT License"
        echo "  ✓ Created initial commit"
    else
        echo "  ℹ Repository already has commits"
    fi
    
    cd ..
    echo ""
done

echo "✅ All projects initialized!"
echo ""
echo "📝 Next steps:"
echo "1. Create repositories on GitHub (github.com/yksanjo):"
for project in "${PROJECTS[@]}"; do
    echo "   - $project"
done
echo ""
echo "2. Add remote and push (for each project):"
echo "   cd $project"
echo "   git remote add origin https://github.com/yksanjo/$project.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "Or use the push_all.sh script after creating repositories."




