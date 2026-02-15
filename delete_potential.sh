#!/bin/bash
# GitHub Repository Cleanup Script
# Generated: 2026-02-09T14:06:33.673551
#
# This script will delete the following repositories:
# Review carefully before running!

# Prerequisites:
# 1. Install GitHub CLI: https://cli.github.com/
# 2. Authenticate: gh auth login
# 3. Review the list below

echo '=== Repositories to be deleted ==='
echo '  - attack-surface-ai'
echo '  - ai-security-suite'
echo '  - You-Dont-Need-jQuery'
echo '  - identity-studio'
echo '  - social-media-scheduler'
echo '  - saas-churn-predictor'
echo '  - github-star-notifier'
echo '  - dead-link-checker'
echo '  - competitor-price-tracker'
echo '  - code-review-time-tracker'
echo '  - api-rate-limit-monitor'
echo '  - quick-scaffold'
echo '  - mock-api-gen'
echo '  - git-hook-setup'
echo '  - task-run'
echo '  - diff-focus-vscode'
echo '  - RateGuard'
echo '  - ReviewClock'
echo '  - ChurnGuard'
echo '  - StarAlert-'
echo '  - PriceWatch'
echo '  - SocialQueue'
echo '  - LinkCheck'
echo '  - roadmap-dashboard'
echo '  - feature-flag-auditor'
echo '  - pr-summarizer'
echo '  - repo-recommendations'
echo '  - research-project-manager-ios'
echo '  - Yoshi-s_Transcriber'
echo '  - neon-dodger'
echo '  - xy-shader-cookbook'
echo '  - strudel-music-lab'
echo '  - audio2strudel'
echo '  - 3D-Solar-System-Explorer'
echo '  - roblox-world-generator'
echo '  - cloud-finops'
echo '  - ml-systems-visualizations'
echo '  - basketball-3d-game'
echo '  - clipboard-copilot'
echo '  - repoboard'
echo '  - ml-experiment-toolkit'
echo '  - milky-way-visualization'
echo '  - pydub-plus'
echo '  - mystery-circle'
echo '  - ModelAudit'
echo '  - Cursor-creature1'
echo '  - supplyhield'
echo '  - Drum2Strudel'

read -p 'Are you sure you want to delete these repos? (yes/no): ' confirm
if [ "\$confirm" != "yes" ]; then
    echo 'Aborting.'
    exit 1
fi

# Delete repositories
echo 'Deleting attack-surface-ai...'
gh repo delete yksanjo/attack-surface-ai --yes || echo 'Failed to delete attack-surface-ai'

echo 'Deleting ai-security-suite...'
gh repo delete yksanjo/ai-security-suite --yes || echo 'Failed to delete ai-security-suite'

echo 'Deleting You-Dont-Need-jQuery...'
gh repo delete yksanjo/You-Dont-Need-jQuery --yes || echo 'Failed to delete You-Dont-Need-jQuery'

echo 'Deleting identity-studio...'
gh repo delete yksanjo/identity-studio --yes || echo 'Failed to delete identity-studio'

echo 'Deleting social-media-scheduler...'
gh repo delete yksanjo/social-media-scheduler --yes || echo 'Failed to delete social-media-scheduler'

echo 'Deleting saas-churn-predictor...'
gh repo delete yksanjo/saas-churn-predictor --yes || echo 'Failed to delete saas-churn-predictor'

echo 'Deleting github-star-notifier...'
gh repo delete yksanjo/github-star-notifier --yes || echo 'Failed to delete github-star-notifier'

echo 'Deleting dead-link-checker...'
gh repo delete yksanjo/dead-link-checker --yes || echo 'Failed to delete dead-link-checker'

echo 'Deleting competitor-price-tracker...'
gh repo delete yksanjo/competitor-price-tracker --yes || echo 'Failed to delete competitor-price-tracker'

echo 'Deleting code-review-time-tracker...'
gh repo delete yksanjo/code-review-time-tracker --yes || echo 'Failed to delete code-review-time-tracker'

echo 'Deleting api-rate-limit-monitor...'
gh repo delete yksanjo/api-rate-limit-monitor --yes || echo 'Failed to delete api-rate-limit-monitor'

echo 'Deleting quick-scaffold...'
gh repo delete yksanjo/quick-scaffold --yes || echo 'Failed to delete quick-scaffold'

echo 'Deleting mock-api-gen...'
gh repo delete yksanjo/mock-api-gen --yes || echo 'Failed to delete mock-api-gen'

echo 'Deleting git-hook-setup...'
gh repo delete yksanjo/git-hook-setup --yes || echo 'Failed to delete git-hook-setup'

echo 'Deleting task-run...'
gh repo delete yksanjo/task-run --yes || echo 'Failed to delete task-run'

echo 'Deleting diff-focus-vscode...'
gh repo delete yksanjo/diff-focus-vscode --yes || echo 'Failed to delete diff-focus-vscode'

echo 'Deleting RateGuard...'
gh repo delete yksanjo/RateGuard --yes || echo 'Failed to delete RateGuard'

echo 'Deleting ReviewClock...'
gh repo delete yksanjo/ReviewClock --yes || echo 'Failed to delete ReviewClock'

echo 'Deleting ChurnGuard...'
gh repo delete yksanjo/ChurnGuard --yes || echo 'Failed to delete ChurnGuard'

echo 'Deleting StarAlert-...'
gh repo delete yksanjo/StarAlert- --yes || echo 'Failed to delete StarAlert-'

echo 'Deleting PriceWatch...'
gh repo delete yksanjo/PriceWatch --yes || echo 'Failed to delete PriceWatch'

echo 'Deleting SocialQueue...'
gh repo delete yksanjo/SocialQueue --yes || echo 'Failed to delete SocialQueue'

echo 'Deleting LinkCheck...'
gh repo delete yksanjo/LinkCheck --yes || echo 'Failed to delete LinkCheck'

echo 'Deleting roadmap-dashboard...'
gh repo delete yksanjo/roadmap-dashboard --yes || echo 'Failed to delete roadmap-dashboard'

echo 'Deleting feature-flag-auditor...'
gh repo delete yksanjo/feature-flag-auditor --yes || echo 'Failed to delete feature-flag-auditor'

echo 'Deleting pr-summarizer...'
gh repo delete yksanjo/pr-summarizer --yes || echo 'Failed to delete pr-summarizer'

echo 'Deleting repo-recommendations...'
gh repo delete yksanjo/repo-recommendations --yes || echo 'Failed to delete repo-recommendations'

echo 'Deleting research-project-manager-ios...'
gh repo delete yksanjo/research-project-manager-ios --yes || echo 'Failed to delete research-project-manager-ios'

echo 'Deleting Yoshi-s_Transcriber...'
gh repo delete yksanjo/Yoshi-s_Transcriber --yes || echo 'Failed to delete Yoshi-s_Transcriber'

echo 'Deleting neon-dodger...'
gh repo delete yksanjo/neon-dodger --yes || echo 'Failed to delete neon-dodger'

echo 'Deleting xy-shader-cookbook...'
gh repo delete yksanjo/xy-shader-cookbook --yes || echo 'Failed to delete xy-shader-cookbook'

echo 'Deleting strudel-music-lab...'
gh repo delete yksanjo/strudel-music-lab --yes || echo 'Failed to delete strudel-music-lab'

echo 'Deleting audio2strudel...'
gh repo delete yksanjo/audio2strudel --yes || echo 'Failed to delete audio2strudel'

echo 'Deleting 3D-Solar-System-Explorer...'
gh repo delete yksanjo/3D-Solar-System-Explorer --yes || echo 'Failed to delete 3D-Solar-System-Explorer'

echo 'Deleting roblox-world-generator...'
gh repo delete yksanjo/roblox-world-generator --yes || echo 'Failed to delete roblox-world-generator'

echo 'Deleting cloud-finops...'
gh repo delete yksanjo/cloud-finops --yes || echo 'Failed to delete cloud-finops'

echo 'Deleting ml-systems-visualizations...'
gh repo delete yksanjo/ml-systems-visualizations --yes || echo 'Failed to delete ml-systems-visualizations'

echo 'Deleting basketball-3d-game...'
gh repo delete yksanjo/basketball-3d-game --yes || echo 'Failed to delete basketball-3d-game'

echo 'Deleting clipboard-copilot...'
gh repo delete yksanjo/clipboard-copilot --yes || echo 'Failed to delete clipboard-copilot'

echo 'Deleting repoboard...'
gh repo delete yksanjo/repoboard --yes || echo 'Failed to delete repoboard'

echo 'Deleting ml-experiment-toolkit...'
gh repo delete yksanjo/ml-experiment-toolkit --yes || echo 'Failed to delete ml-experiment-toolkit'

echo 'Deleting milky-way-visualization...'
gh repo delete yksanjo/milky-way-visualization --yes || echo 'Failed to delete milky-way-visualization'

echo 'Deleting pydub-plus...'
gh repo delete yksanjo/pydub-plus --yes || echo 'Failed to delete pydub-plus'

echo 'Deleting mystery-circle...'
gh repo delete yksanjo/mystery-circle --yes || echo 'Failed to delete mystery-circle'

echo 'Deleting ModelAudit...'
gh repo delete yksanjo/ModelAudit --yes || echo 'Failed to delete ModelAudit'

echo 'Deleting Cursor-creature1...'
gh repo delete yksanjo/Cursor-creature1 --yes || echo 'Failed to delete Cursor-creature1'

echo 'Deleting supplyhield...'
gh repo delete yksanjo/supplyhield --yes || echo 'Failed to delete supplyhield'

echo 'Deleting Drum2Strudel...'
gh repo delete yksanjo/Drum2Strudel --yes || echo 'Failed to delete Drum2Strudel'

echo 'Cleanup complete!'
