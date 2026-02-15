#!/bin/bash
# Comprehensive GitHub Cleanup Script
# Handles all categories: forks, bots, unused, and needs-review repos

echo "=========================================="
echo "FULL GITHUB CLEANUP - ALL CATEGORIES"
echo "=========================================="
echo ""
echo "⚠️  WARNING: This will delete repositories PERMANENTLY!"
echo ""

# Check for delete permission
if ! gh auth status 2>&1 | grep -q "delete_repo"; then
    echo "❌ GitHub CLI needs delete_repo permission!"
    echo "Run: gh auth refresh -h github.com -s delete_repo"
    exit 1
fi

# Track stats
DELETED=0
FAILED=0
SKIPPED=0

delete_repo() {
    local repo=$1
    if gh repo delete "yksanjo/$repo" --yes 2>/dev/null; then
        echo "  ✅ Deleted: $repo"
        ((DELETED++))
        return 0
    else
        echo "  ❌ Failed/Not Found: $repo"
        ((FAILED++))
        return 1
    fi
}

# ==================== PHASE 1: FORKS ====================
echo ""
echo "📦 PHASE 1: Delete Forks (9 repos)"
echo "----------------------------------------"
echo "These are forks you don't have locally:"
echo "  - camera-heart-rate-monitor-web"
echo "  - camera-heart-rate-monitor"
echo "  - whisper-plus"
echo "  - all-in-rag"
echo "  - Dirt-Samples"
echo "  - cs249r_book"
echo "  - TrendRadar"
echo "  - tinytag"
echo "  - yt-dlp"
echo ""
read -p "Delete ALL forks? (yes/no/skip): " phase1
if [ "$phase1" == "yes" ]; then
    delete_repo "camera-heart-rate-monitor-web"
    delete_repo "camera-heart-rate-monitor"
    delete_repo "whisper-plus"
    delete_repo "all-in-rag"
    delete_repo "Dirt-Samples"
    delete_repo "cs249r_book"
    delete_repo "TrendRadar"
    delete_repo "tinytag"
    delete_repo "yt-dlp"
elif [ "$phase1" == "skip" ]; then
    echo "Skipped Phase 1"
    ((SKIPPED+=9))
else
    echo "Aborted Phase 1"
fi

# ==================== PHASE 2: BOT REPOS ====================
echo ""
echo "🤖 PHASE 2: Delete Bot Repos (11 repos)"
echo "----------------------------------------"
echo "These bot projects aren't your active OpenClaw:"
echo "  - ai-agent-waf"
echo "  - agent-hr"
echo "  - agent-finance"
echo "  - invoice-reminder-bot"
echo "  - identityvault-agents"
echo "  - InvoiceBot"
echo "  - Pixel-Perfect-Agent"
echo "  - chatbot"
echo "  - tiny-chatbot"
echo "  - pr-health-bot"
echo "  - rap-beat-callbot"
echo ""
read -p "Delete ALL bot repos? (yes/no/skip): " phase2
if [ "$phase2" == "yes" ]; then
    delete_repo "ai-agent-waf"
    delete_repo "agent-hr"
    delete_repo "agent-finance"
    delete_repo "invoice-reminder-bot"
    delete_repo "identityvault-agents"
    delete_repo "InvoiceBot"
    delete_repo "Pixel-Perfect-Agent"
    delete_repo "chatbot"
    delete_repo "tiny-chatbot"
    delete_repo "pr-health-bot"
    delete_repo "rap-beat-callbot"
elif [ "$phase2" == "skip" ]; then
    echo "Skipped Phase 2"
    ((SKIPPED+=11))
else
    echo "Aborted Phase 2"
fi

# ==================== PHASE 3: UNUSED GITHUB-ONLY ====================
echo ""
echo "🗑️  PHASE 3: Unused GitHub-Only Repos (48 repos)"
echo "----------------------------------------"
echo "These exist only on GitHub (not locally)"
read -p "Show all 48 repos? (yes/no): " showall
if [ "$showall" == "yes" ]; then
    cat << 'EOF'
  - attack-surface-ai
  - ai-security-suite
  - You-Dont-Need-jQuery
  - identity-studio
  - social-media-scheduler
  - saas-churn-predictor
  - github-star-notifier
  - dead-link-checker
  - competitor-price-tracker
  - code-review-time-tracker
  - api-rate-limit-monitor
  - quick-scaffold
  - mock-api-gen
  - git-hook-setup
  - task-run
  - diff-focus-vscode
  - RateGuard
  - ReviewClock
  - ChurnGuard
  - StarAlert-
  - PriceWatch
  - SocialQueue
  - LinkCheck
  - roadmap-dashboard
  - feature-flag-auditor
  - pr-summarizer
  - repo-recommendations
  - research-project-manager-ios
  - Yoshi-s_Transcriber
  - neon-dodger
  - xy-shader-cookbook
  - strudel-music-lab
  - audio2strudel
  - 3D-Solar-System-Explorer
  - roblox-world-generator
  - cloud-finops
  - ml-systems-visualizations
  - basketball-3d-game
  - clipboard-copilot
  - repoboard
  - ml-experiment-toolkit
  - milky-way-visualization
  - pydub-plus
  - mystery-circle
  - ModelAudit
  - Cursor-creature1
  - supplyhield
  - Drum2Strudel
EOF
fi

echo ""
read -p "Delete ALL 48 unused repos? (yes/no/one-by-one/skip): " phase3
if [ "$phase3" == "yes" ]; then
    delete_repo "attack-surface-ai"
    delete_repo "ai-security-suite"
    delete_repo "You-Dont-Need-jQuery"
    delete_repo "identity-studio"
    delete_repo "social-media-scheduler"
    delete_repo "saas-churn-predictor"
    delete_repo "github-star-notifier"
    delete_repo "dead-link-checker"
    delete_repo "competitor-price-tracker"
    delete_repo "code-review-time-tracker"
    delete_repo "api-rate-limit-monitor"
    delete_repo "quick-scaffold"
    delete_repo "mock-api-gen"
    delete_repo "git-hook-setup"
    delete_repo "task-run"
    delete_repo "diff-focus-vscode"
    delete_repo "RateGuard"
    delete_repo "ReviewClock"
    delete_repo "ChurnGuard"
    delete_repo "StarAlert-"
    delete_repo "PriceWatch"
    delete_repo "SocialQueue"
    delete_repo "LinkCheck"
    delete_repo "roadmap-dashboard"
    delete_repo "feature-flag-auditor"
    delete_repo "pr-summarizer"
    delete_repo "repo-recommendations"
    delete_repo "research-project-manager-ios"
    delete_repo "Yoshi-s_Transcriber"
    delete_repo "neon-dodger"
    delete_repo "xy-shader-cookbook"
    delete_repo "strudel-music-lab"
    delete_repo "audio2strudel"
    delete_repo "3D-Solar-System-Explorer"
    delete_repo "roblox-world-generator"
    delete_repo "cloud-finops"
    delete_repo "ml-systems-visualizations"
    delete_repo "basketball-3d-game"
    delete_repo "clipboard-copilot"
    delete_repo "repoboard"
    delete_repo "ml-experiment-toolkit"
    delete_repo "milky-way-visualization"
    delete_repo "pydub-plus"
    delete_repo "mystery-circle"
    delete_repo "ModelAudit"
    delete_repo "Cursor-creature1"
    delete_repo "supplyhield"
    delete_repo "Drum2Strudel"
elif [ "$phase3" == "one-by-one" ]; then
    for repo in attack-surface-ai ai-security-suite You-Dont-Need-jQuery identity-studio social-media-scheduler saas-churn-predictor github-star-notifier dead-link-checker competitor-price-tracker code-review-time-tracker api-rate-limit-monitor quick-scaffold mock-api-gen git-hook-setup task-run diff-focus-vscode RateGuard ReviewClock ChurnGuard StarAlert- PriceWatch SocialQueue LinkCheck roadmap-dashboard feature-flag-auditor pr-summarizer repo-recommendations research-project-manager-ios Yoshi-s_Transcriber neon-dodger xy-shader-cookbook strudel-music-lab audio2strudel 3D-Solar-System-Explorer roblox-world-generator cloud-finops ml-systems-visualizations basketball-3d-game clipboard-copilot repoboard ml-experiment-toolkit milky-way-visualization pydub-plus mystery-circle ModelAudit Cursor-creature1 supplyhield Drum2Strudel; do
        read -p "  Delete $repo? (y/n/q): " choice
        if [ "$choice" == "q" ]; then
            break
        elif [ "$choice" == "y" ]; then
            delete_repo "$repo"
        else
            echo "    Skipped: $repo"
            ((SKIPPED++))
        fi
    done
elif [ "$phase3" == "skip" ]; then
    echo "Skipped Phase 3"
    ((SKIPPED+=48))
else
    echo "Aborted Phase 3"
fi

# ==================== PHASE 4: NEEDS REVIEW ====================
echo ""
echo "🔍 PHASE 4: Repos Needing Manual Review (71 repos)"
echo "----------------------------------------"
echo "These have stars or interesting descriptions - review before deleting"
read -p "Review these repos? (yes/no): " review
if [ "$review" == "yes" ]; then
    cat << 'EOF'
Repos with 1 star (potential value):
  - ai-token-spending-products, smb-security-suite, pentestgpt
  - vpc-guardian, logcopilot, surfaceai
  - zero-trust-ai-access, cross-cloud-policy-manager
  - ai-agent-waf (deleted if Phase 2 ran)
  - autonomous-threat-hunter, github-jira-sync
  - All SAP repos (10): sap-report-generator, sap-user-activity-monitor, etc.
  - Oracle repos (5): oracle-cloud-cost-optimizer, oracle-performance-analyzer, etc.
  - Quantum demos (7): quantum-art-generator, quantum-noise-demo, etc.
  - Agent/AI projects: agentguard, codeshield-ai, fleetcommand, modelwatch
  - Security: identityvault-agents (deleted if Phase 2 ran), promptshield
  - diff-focus-chrome (has 1 star)
  - github-repo-automation (has 1 star)

Repos with 0 stars to consider:
  - workos, flowboard, ai-tools-builder
  - Various WIP projects: strategyforge-ai, complianceiq, supplychainguard
  - Dev tools: env-manager, email-warmup-service, domain-expiration-monitor
  - Productivity: postmortem-generator, meeting-action-extractor
  - Music/Audio: er-triage-management-system, musiclab
  - Dashboards: sprint-sync-dashboard, personal-ai-command-center
  - Games/Demos: Dev_defender_3D, fridge-tetris-ai, AI-Fortune-Cookie
  - AI projects: pair-programming-ai, news-trend-ai, truthlens-ai
  - Cursor/IDE: micro-traversal-Cursor, micro-traversal-TREA
EOF
    echo ""
    echo "To delete specific repos from this list, use:"
    echo "  gh repo delete yksanjo/REPO_NAME --yes"
fi

# ==================== SUMMARY ====================
echo ""
echo "=========================================="
echo "CLEANUP SUMMARY"
echo "=========================================="
echo "Deleted:  $DELETED repos"
echo "Failed:   $FAILED repos"
echo "Skipped:  $SKIPPED repos"
echo ""
echo "Remaining repos to review: 71"
echo ""
echo "Your active local projects are SAFE:"
echo "  - clawd, clawdbot-deepseek, clawdbot-launchpad"
echo "  - openclawsandbox, moltworker*"
echo "=========================================="
