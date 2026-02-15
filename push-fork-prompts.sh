#!/bin/bash

# Script to push fork prompts to respective repositories
# Usage: ./push-fork-prompts.sh

BASE_DIR="/Users/yoshikondo"
FORK_PROMPTS_DIR="$BASE_DIR/docs/fork-prompts"
ORG_DIR="$BASE_DIR/fork-prompts-org"

# Repository mappings (update these with actual repo paths)
declare -A REPOS=(
    ["music-ai-lab"]="Strudel-music-pattern-memory-bank"  # Update with actual Music AI Lab repo
    ["chatbot-repo"]=""  # Update with actual chatbot repo name
    ["automation-repo"]=""  # Update with actual automation repo name  
    ["finance-coach"]="ai-finance-coach-mvp"
)

push_to_repo() {
    local category=$1
    local repo_name=$2
    
    if [ -z "$repo_name" ]; then
        echo "⚠️  Skipping $category - repo name not set"
        return
    fi
    
    local repo_path="$BASE_DIR/$repo_name"
    local source_dir="$ORG_DIR/$category"
    
    if [ ! -d "$repo_path" ]; then
        echo "❌ Repository not found: $repo_path"
        echo "   Please clone it first or update the repo name"
        return
    fi
    
    if [ ! -d "$repo_path/.git" ]; then
        echo "❌ Not a git repository: $repo_path"
        return
    fi
    
    echo "📦 Pushing to $repo_name ($category)..."
    
    # Create docs/fork-prompts directory in repo if it doesn't exist
    mkdir -p "$repo_path/docs/fork-prompts"
    
    # Copy files
    cp -r "$source_dir"/* "$repo_path/docs/fork-prompts/"
    
    # Navigate to repo and commit
    cd "$repo_path"
    
    # Check if there are changes
    if git diff --quiet && git diff --cached --quiet; then
        echo "   No changes to commit"
    else
        git add docs/fork-prompts/
        git commit -m "docs: Add fork prompts for $category repositories
        
        - Added detailed fork prompts for relevant repositories
        - Includes README and forking checklist
        - Organized by repository category"
        
        echo "✅ Committed changes to $repo_name"
        echo "   Run 'git push' to push to remote"
    fi
    
    cd "$BASE_DIR"
    echo ""
}

# Push to each repository
echo "🚀 Starting fork prompts push process..."
echo ""

for category in "${!REPOS[@]}"; do
    push_to_repo "$category" "${REPOS[$category]}"
done

echo "✨ Done! Review the commits and push with 'git push' in each repo"



