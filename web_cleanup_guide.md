# GitHub Cleanup - Web Interface Guide

Since CLI lacks delete permission, here's how to clean up via GitHub web interface:

## Quick URL List

Click each link → Settings → Danger Zone → Delete this repository

### Phase 1: Forks (9 repos)
| Repo | URL |
|------|-----|
| camera-heart-rate-monitor-web | https://github.com/yksanjo/camera-heart-rate-monitor-web/settings |
| camera-heart-rate-monitor | https://github.com/yksanjo/camera-heart-rate-monitor/settings |
| whisper-plus | https://github.com/yksanjo/whisper-plus/settings |
| all-in-rag | https://github.com/yksanjo/all-in-rag/settings |
| Dirt-Samples | https://github.com/yksanjo/Dirt-Samples/settings |
| cs249r_book | https://github.com/yksanjo/cs249r_book/settings |
| TrendRadar | https://github.com/yksanjo/TrendRadar/settings |
| tinytag | https://github.com/yksanjo/tinytag/settings |
| yt-dlp | https://github.com/yksanjo/yt-dlp/settings |

### Phase 2: Bot Repos (11 repos)
| Repo | URL |
|------|-----|
| ai-agent-waf | https://github.com/yksanjo/ai-agent-waf/settings |
| agent-hr | https://github.com/yksanjo/agent-hr/settings |
| agent-finance | https://github.com/yksanjo/agent-finance/settings |
| invoice-reminder-bot | https://github.com/yksanjo/invoice-reminder-bot/settings |
| identityvault-agents | https://github.com/yksanjo/identityvault-agents/settings |
| InvoiceBot | https://github.com/yksanjo/InvoiceBot/settings |
| Pixel-Perfect-Agent | https://github.com/yksanjo/Pixel-Perfect-Agent/settings |
| chatbot | https://github.com/yksanjo/chatbot/settings |
| tiny-chatbot | https://github.com/yksanjo/tiny-chatbot/settings |
| pr-health-bot | https://github.com/yksanjo/pr-health-bot/settings |
| rap-beat-callbot | https://github.com/yksanjo/rap-beat-callbot/settings |

### Phase 3: Unused GitHub-Only (48 repos)
See full list in `cleanup_report.json` or run:
```bash
cat cleanup_report.json | jq '.categories.github_only_unused[].name'
```

---

## Alternative: Enable CLI Delete Permission

1. Go to: https://github.com/settings/tokens
2. Generate new token (classic) with `delete_repo` scope
3. Or run: `gh auth refresh -h github.com -s delete_repo`
4. Then run: `./full_cleanup.sh`

---

## Bookmarklet for Quick Deletion

Create a bookmark with this JavaScript to speed up deletions:
```javascript
javascript:(function(){window.location.href=window.location.href.replace(/\/[^\/]*$/,'')+'/settings#danger-zone';})();
```

Click it on any repo page to jump to delete settings.
