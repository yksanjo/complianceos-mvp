#!/bin/bash

echo "=================================================================="
echo "CRUNCHBASE DISCOVERY SCRAPER - READY TO RUN"
echo "=================================================================="
echo ""
echo "STEP 1: CHECK CREDENTIALS"
echo "-------------------------"
echo "Current credentials file (.crunchbase_credentials.json):"
echo ""
cat .crunchbase_credentials.json 2>/dev/null || echo "File not found or empty"
echo ""
echo "If the email/password are empty, you need to update them."
echo ""
echo "STEP 2: UPDATE CREDENTIALS (if needed)"
echo "--------------------------------------"
echo "Run this command to update:"
echo "  python3 update_credentials.py"
echo ""
echo "Or manually edit the file:"
echo '  {"email": "YOUR_ACTUAL_EMAIL", "password": "YOUR_ACTUAL_PASSWORD"}'
echo ""
echo "STEP 3: RUN THE SCRAPER"
echo "----------------------"
echo "Once credentials are set, run:"
echo "  python3 crunchbase_discovery_scraper.py"
echo ""
echo "This will:"
echo "  • Open a browser window"
echo "  • Login to Crunchbase automatically"
echo "  • Navigate to: https://www.crunchbase.com/discover/organization.companies"
echo "  • Extract company listings"
echo "  • Save results to JSON and CSV files"
echo ""
echo "=================================================================="
echo "QUICK START:"
echo "=================================================================="
echo ""
echo "1. First, update credentials:"
echo "   python3 update_credentials.py"
echo ""
echo "2. Then run the scraper:"
echo "   python3 crunchbase_discovery_scraper.py"
echo ""
echo "=================================================================="
echo "TROUBLESHOOTING:"
echo "=================================================================="
echo ""
echo "If you get errors:"
echo "1. Make sure you have a paid Crunchbase account"
echo "2. Check your credentials are correct"
echo "3. The browser window will show what's happening"
echo "4. Screenshots will be saved for debugging"
echo ""
echo "=================================================================="
echo "READY? LET'S GO!"
echo "=================================================================="
echo ""
echo "Press Enter to continue and run the scraper setup..."
read

# Check if credentials exist
if [ ! -f ".crunchbase_credentials.json" ]; then
    echo "❌ Credentials file not found!"
    echo "Running update_credentials.py..."
    python3 update_credentials.py
fi

# Check if credentials are empty
if [ -f ".crunchbase_credentials.json" ]; then
    if grep -q '"email": ""' .crunchbase_credentials.json || grep -q '"password": ""' .crunchbase_credentials.json; then
        echo "❌ Credentials file has empty email/password!"
        echo "Running update_credentials.py..."
        python3 update_credentials.py
    fi
fi

echo ""
echo "=================================================================="
echo "STARTING CRUNCHBASE DISCOVERY SCRAPER..."
echo "=================================================================="
echo ""
echo "A browser window will open. You'll see it:"
echo "1. Navigate to Crunchbase login"
echo "2. Enter your credentials automatically"
echo "3. Go to the discovery page"
echo "4. Extract company data"
echo ""
echo "This may take 2-5 minutes..."
echo ""
echo "Press Ctrl+C to cancel, or wait 5 seconds to continue..."
sleep 5

python3 crunchbase_discovery_scraper.py