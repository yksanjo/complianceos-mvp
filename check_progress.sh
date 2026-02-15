#!/bin/bash
echo "========================================"
echo "SCRAPER PROGRESS - $(date)"
echo "========================================"
tail -10 scraper_live.log 2>/dev/null | grep -E "(Processing|AGENT|Rate limit|Progress saved)"
echo ""
python3 check_scraper_status.py 2>/dev/null | grep -E "(Progress|Agent Users|time remaining)"
echo "========================================"
