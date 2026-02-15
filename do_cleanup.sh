#!/bin/bash
# Auto-cleanup script - deletes repos without interactive confirmation
# Generated: 2026-02-09

echo "=========================================="
echo "GITHUB CLEANUP - AUTO DELETE MODE"
echo "=========================================="
echo ""
echo "Deleting 9 forks + 11 bot repos..."
echo ""

# FORKS TO DELETE
echo "🗑️  Deleting forks..."
gh repo delete yksanjo/camera-heart-rate-monitor-web --yes 2>/dev/null && echo "✅ camera-heart-rate-monitor-web deleted" || echo "❌ camera-heart-rate-monitor-web failed/already deleted"
gh repo delete yksanjo/camera-heart-rate-monitor --yes 2>/dev/null && echo "✅ camera-heart-rate-monitor deleted" || echo "❌ camera-heart-rate-monitor failed/already deleted"
gh repo delete yksanjo/whisper-plus --yes 2>/dev/null && echo "✅ whisper-plus deleted" || echo "❌ whisper-plus failed/already deleted"
gh repo delete yksanjo/all-in-rag --yes 2>/dev/null && echo "✅ all-in-rag deleted" || echo "❌ all-in-rag failed/already deleted"
gh repo delete yksanjo/Dirt-Samples --yes 2>/dev/null && echo "✅ Dirt-Samples deleted" || echo "❌ Dirt-Samples failed/already deleted"
gh repo delete yksanjo/cs249r_book --yes 2>/dev/null && echo "✅ cs249r_book deleted" || echo "❌ cs249r_book failed/already deleted"
gh repo delete yksanjo/TrendRadar --yes 2>/dev/null && echo "✅ TrendRadar deleted" || echo "❌ TrendRadar failed/already deleted"
gh repo delete yksanjo/tinytag --yes 2>/dev/null && echo "✅ tinytag deleted" || echo "❌ tinytag failed/already deleted"
gh repo delete yksanjo/yt-dlp --yes 2>/dev/null && echo "✅ yt-dlp deleted" || echo "❌ yt-dlp failed/already deleted"

echo ""
echo "🤖 Deleting bot repos..."
gh repo delete yksanjo/ai-agent-waf --yes 2>/dev/null && echo "✅ ai-agent-waf deleted" || echo "❌ ai-agent-waf failed/already deleted"
gh repo delete yksanjo/agent-hr --yes 2>/dev/null && echo "✅ agent-hr deleted" || echo "❌ agent-hr failed/already deleted"
gh repo delete yksanjo/agent-finance --yes 2>/dev/null && echo "✅ agent-finance deleted" || echo "❌ agent-finance failed/already deleted"
gh repo delete yksanjo/invoice-reminder-bot --yes 2>/dev/null && echo "✅ invoice-reminder-bot deleted" || echo "❌ invoice-reminder-bot failed/already deleted"
gh repo delete yksanjo/identityvault-agents --yes 2>/dev/null && echo "✅ identityvault-agents deleted" || echo "❌ identityvault-agents failed/already deleted"
gh repo delete yksanjo/InvoiceBot --yes 2>/dev/null && echo "✅ InvoiceBot deleted" || echo "❌ InvoiceBot failed/already deleted"
gh repo delete yksanjo/Pixel-Perfect-Agent --yes 2>/dev/null && echo "✅ Pixel-Perfect-Agent deleted" || echo "❌ Pixel-Perfect-Agent failed/already deleted"
gh repo delete yksanjo/chatbot --yes 2>/dev/null && echo "✅ chatbot deleted" || echo "❌ chatbot failed/already deleted"
gh repo delete yksanjo/tiny-chatbot --yes 2>/dev/null && echo "✅ tiny-chatbot deleted" || echo "❌ tiny-chatbot failed/already deleted"
gh repo delete yksanjo/pr-health-bot --yes 2>/dev/null && echo "✅ pr-health-bot deleted" || echo "❌ pr-health-bot failed/already deleted"
gh repo delete yksanjo/rap-beat-callbot --yes 2>/dev/null && echo "✅ rap-beat-callbot deleted" || echo "❌ rap-beat-callbot failed/already deleted"

echo ""
echo "=========================================="
echo "CLEANUP COMPLETE!"
echo "=========================================="
