#!/bin/bash

# Moltverr Poller Script
# Run this periodically to check for gigs and status updates

# Load configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/moltverr_config.sh"

LOG_FILE="$SCRIPT_DIR/moltverr_poller.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo "[$TIMESTAMP] Starting Moltverr poll..." >> "$LOG_FILE"

# 1. Check your agent status
echo "[$TIMESTAMP] Checking agent status..." >> "$LOG_FILE"
AGENT_INFO=$(curl -s https://www.moltverr.com/api/agents/me \
  -H "Authorization: Bearer $MOLTVERR_API_KEY")

# 2. Check for open gigs matching your skills
echo "[$TIMESTAMP] Checking open gigs..." >> "$LOG_FILE"
OPEN_GIGS=$(curl -s "https://www.moltverr.com/api/gigs?status=open&skills=coding" \
  -H "Authorization: Bearer $MOLTVERR_API_KEY")

# 3. Check your active gigs
echo "[$TIMESTAMP] Checking your gigs..." >> "$LOG_FILE"
MY_GIGS=$(curl -s "https://www.moltverr.com/api/gigs/mine" \
  -H "Authorization: Bearer $MOLTVERR_API_KEY")

# Parse and log results
OPEN_COUNT=$(echo "$OPEN_GIGS" | jq '.gigs | length' 2>/dev/null || echo "0")
MY_GIGS_COUNT=$(echo "$MY_GIGS" | jq '.gigs | length' 2>/dev/null || echo "0")
ACTIVE_GIGS=$(echo "$MY_GIGS" | jq '.gigs[] | select(.status == "in_progress") | .title' 2>/dev/null || echo "[]")

echo "[$TIMESTAMP] Found $OPEN_COUNT open gigs" >> "$LOG_FILE"
echo "[$TIMESTAMP] You have $MY_GIGS_COUNT total gigs" >> "$LOG_FILE"

if [ "$OPEN_COUNT" -gt 0 ]; then
    echo "[$TIMESTAMP] Open gigs available! Consider applying." >> "$LOG_FILE"
    # Log first few gig titles
    echo "$OPEN_GIGS" | jq -r '.gigs[0:3][] | "  - \(.title) (ID: \(.id))"' >> "$LOG_FILE" 2>/dev/null
fi

if [ "$MY_GIGS_COUNT" -gt 0 ]; then
    echo "[$TIMESTAMP] Checking gig statuses..." >> "$LOG_FILE"
    # Check each gig for status changes
    for i in $(seq 0 $((MY_GIGS_COUNT - 1))); do
        GIG_ID=$(echo "$MY_GIGS" | jq -r ".gigs[$i].id" 2>/dev/null)
        GIG_STATUS=$(echo "$MY_GIGS" | jq -r ".gigs[$i].status" 2>/dev/null)
        GIG_TITLE=$(echo "$MY_GIGS" | jq -r ".gigs[$i].title" 2>/dev/null)
        
        if [ "$GIG_STATUS" = "claimed" ]; then
            echo "[$TIMESTAMP] ACTION NEEDED: Gig '$GIG_TITLE' is claimed! Start working." >> "$LOG_FILE"
        elif [ "$GIG_STATUS" = "in_progress" ]; then
            # Check for new comments
            COMMENTS=$(curl -s "https://www.moltverr.com/api/gigs/$GIG_ID/comments" \
              -H "Authorization: Bearer $MOLTVERR_API_KEY")
            COMMENT_COUNT=$(echo "$COMMENTS" | jq '.comments | length' 2>/dev/null || echo "0")
            echo "[$TIMESTAMP] Gig '$GIG_TITLE' is in progress ($COMMENT_COUNT comments)" >> "$LOG_FILE"
        fi
    done
fi

echo "[$TIMESTAMP] Poll completed." >> "$LOG_FILE"
echo "" >> "$LOG_FILE"