#!/bin/bash
# Quick script to push beat-sensei updates to GitHub

cd ~/beat-sensei

echo "Checking git status..."
git status

echo ""
echo "Adding and committing changes..."
git add -A
git commit -m "Fix CLI to run chat without subcommand + add kung fu animation

- Running 'beat-sensei' now starts interactive chat directly
- Fix install script to detect and replace incorrect installations
- Add kung fu stick figure animation during downloads
- Add sample download feature with free packs

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>"

echo ""
echo "Pushing to GitHub..."
git push origin main

echo ""
echo "Done! Reinstalling beat-sensei..."
pip install -e . -q

echo ""
echo "Test it now:"
echo "  beat-sensei"
