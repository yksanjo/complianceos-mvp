#!/bin/bash
# Watch scraper progress

echo "=========================================="
echo "GITHUB FORK SCRAPER - LIVE MONITOR"
echo "=========================================="
echo ""

while true; do
    clear
    echo "=========================================="
    echo "GITHUB FORK SCRAPER - LIVE MONITOR"
    echo "=========================================="
    echo ""
    
    python3 check_scraper_status.py
    
    echo ""
    echo "=========================================="
    echo "Refreshing in 30 seconds..."
    echo "Press Ctrl+C to stop monitoring"
    echo "=========================================="
    
    sleep 30
done
