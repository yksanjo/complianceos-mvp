#!/bin/bash

# Quick Context Loader for AI Assistant Sessions
# Run this at the start of each session to load context

echo "=== AI ASSISTANT CONTEXT LOADER ==="
echo ""

# Load JSON context if exists
if [ -f ".ai_context.json" ]; then
    echo "📁 Loading saved context..."
    python3 -c "
import json
try:
    with open('.ai_context.json', 'r') as f:
        ctx = json.load(f)
    print(f\"Project: {ctx.get('project', {}).get('name', 'Unknown')}\")
    print(f\"Current Task: {ctx.get('project', {}).get('current_task', 'None')}\")
    if ctx.get('project', {}).get('next_steps'):
        print(\"Next Steps:\")
        for i, step in enumerate(ctx['project']['next_steps'], 1):
            print(f\"  {i}. {step}\")
except Exception as e:
    print(f\"Error loading context: {e}\")
"
else
    echo "No saved context found. Creating new context..."
fi

echo ""
echo "=== GIT STATUS ==="
git status --short 2>/dev/null || echo "Not a git repository or no changes"

echo ""
echo "=== RECENT COMMITS ==="
git log --oneline -3 2>/dev/null || echo "No git history available"

echo ""
echo "=== IMPORTANT FILES ==="
ls -la *.md *.py *.sh *.json 2>/dev/null | head -10

echo ""
echo "=== QUICK ACTIONS ==="
echo "To save context: python3 context_manager.py"
echo "To update task: python3 -c \"from context_manager import save_context; save_context(current_task='Your new task')\""
echo "To add change: python3 -c \"from context_manager import save_context; save_context(recent_change='What you changed')\""