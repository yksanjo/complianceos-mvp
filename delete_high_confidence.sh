#!/bin/bash
# GitHub Repository Cleanup Script
# Generated: 2026-02-09T14:06:33.673148
#
# This script will delete the following repositories:
# Review carefully before running!

# Prerequisites:
# 1. Install GitHub CLI: https://cli.github.com/
# 2. Authenticate: gh auth login
# 3. Review the list below

echo '=== Repositories to be deleted ==='
echo '  - camera-heart-rate-monitor-web'
echo '  - camera-heart-rate-monitor'
echo '  - whisper-plus'
echo '  - all-in-rag'
echo '  - Dirt-Samples'
echo '  - cs249r_book'
echo '  - TrendRadar'
echo '  - tinytag'
echo '  - yt-dlp'
echo '  - ai-agent-waf'
echo '  - agent-hr'
echo '  - agent-finance'
echo '  - invoice-reminder-bot'
echo '  - identityvault-agents'
echo '  - InvoiceBot'
echo '  - Pixel-Perfect-Agent'
echo '  - chatbot'
echo '  - tiny-chatbot'
echo '  - pr-health-bot'
echo '  - rap-beat-callbot'

read -p 'Are you sure you want to delete these repos? (yes/no): ' confirm
if [ "\$confirm" != "yes" ]; then
    echo 'Aborting.'
    exit 1
fi

# Delete repositories
echo 'Deleting camera-heart-rate-monitor-web...'
gh repo delete yksanjo/camera-heart-rate-monitor-web --yes || echo 'Failed to delete camera-heart-rate-monitor-web'

echo 'Deleting camera-heart-rate-monitor...'
gh repo delete yksanjo/camera-heart-rate-monitor --yes || echo 'Failed to delete camera-heart-rate-monitor'

echo 'Deleting whisper-plus...'
gh repo delete yksanjo/whisper-plus --yes || echo 'Failed to delete whisper-plus'

echo 'Deleting all-in-rag...'
gh repo delete yksanjo/all-in-rag --yes || echo 'Failed to delete all-in-rag'

echo 'Deleting Dirt-Samples...'
gh repo delete yksanjo/Dirt-Samples --yes || echo 'Failed to delete Dirt-Samples'

echo 'Deleting cs249r_book...'
gh repo delete yksanjo/cs249r_book --yes || echo 'Failed to delete cs249r_book'

echo 'Deleting TrendRadar...'
gh repo delete yksanjo/TrendRadar --yes || echo 'Failed to delete TrendRadar'

echo 'Deleting tinytag...'
gh repo delete yksanjo/tinytag --yes || echo 'Failed to delete tinytag'

echo 'Deleting yt-dlp...'
gh repo delete yksanjo/yt-dlp --yes || echo 'Failed to delete yt-dlp'

echo 'Deleting ai-agent-waf...'
gh repo delete yksanjo/ai-agent-waf --yes || echo 'Failed to delete ai-agent-waf'

echo 'Deleting agent-hr...'
gh repo delete yksanjo/agent-hr --yes || echo 'Failed to delete agent-hr'

echo 'Deleting agent-finance...'
gh repo delete yksanjo/agent-finance --yes || echo 'Failed to delete agent-finance'

echo 'Deleting invoice-reminder-bot...'
gh repo delete yksanjo/invoice-reminder-bot --yes || echo 'Failed to delete invoice-reminder-bot'

echo 'Deleting identityvault-agents...'
gh repo delete yksanjo/identityvault-agents --yes || echo 'Failed to delete identityvault-agents'

echo 'Deleting InvoiceBot...'
gh repo delete yksanjo/InvoiceBot --yes || echo 'Failed to delete InvoiceBot'

echo 'Deleting Pixel-Perfect-Agent...'
gh repo delete yksanjo/Pixel-Perfect-Agent --yes || echo 'Failed to delete Pixel-Perfect-Agent'

echo 'Deleting chatbot...'
gh repo delete yksanjo/chatbot --yes || echo 'Failed to delete chatbot'

echo 'Deleting tiny-chatbot...'
gh repo delete yksanjo/tiny-chatbot --yes || echo 'Failed to delete tiny-chatbot'

echo 'Deleting pr-health-bot...'
gh repo delete yksanjo/pr-health-bot --yes || echo 'Failed to delete pr-health-bot'

echo 'Deleting rap-beat-callbot...'
gh repo delete yksanjo/rap-beat-callbot --yes || echo 'Failed to delete rap-beat-callbot'

echo 'Cleanup complete!'
