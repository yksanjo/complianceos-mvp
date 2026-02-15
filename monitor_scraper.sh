#!/bin/bash
# Monitor scraper progress

LOG_FILE="/Users/yoshikondo/scraper_live.log"
PID_FILE="/Users/yoshikondo/scraper.pid"

echo "=========================================="
echo "📊 SCRAPER MONITOR - $(date '+%H:%M:%S')"
echo "=========================================="

# Check if running
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        echo "✅ Status: RUNNING (PID: $PID)"
    else
        echo "❌ Status: STOPPED"
    fi
else
    echo "❌ Status: NO PID FILE"
fi

# Show recent progress
echo ""
echo "📈 Recent Progress:"
tail -20 "$LOG_FILE" | grep -E "Processing:|AGENT USER|Progress saved|Complete" | tail -10

# Show stats
echo ""
echo "📊 Quick Stats:"
python3 /Users/yoshikondo/check_scraper_status.py 2>/dev/null | grep -E "Progress:|Complete:|Agent Users|Remaining:"

echo ""
echo "⏱️  Last 5 log entries:"
tail -5 "$LOG_FILE"
