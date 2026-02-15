#!/bin/bash
# Chrome Password Backup Script
# Run this BEFORE removing Chrome

BACKUP_DIR="$HOME/Desktop/chrome_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "🔐 Backing up Chrome data..."
echo "Destination: $BACKUP_DIR"
echo ""

# 1. Export passwords via Chrome (manual step)
echo "📋 STEP 1: Manual Password Export Required"
echo "=========================================="
echo "1. Open Chrome"
echo "2. Go to: chrome://settings/passwords"
echo "3. Click the 3 dots menu → 'Export passwords'"
echo "4. Save to: $BACKUP_DIR/chrome_passwords.csv"
echo ""

# 2. Copy Login Data files (encrypted, but backup just in case)
echo "📁 STEP 2: Copying Login Data files..."
find "$HOME/Library/Application Support/Google/Chrome" -maxdepth 1 -type d -name "Profile*" -o -name "Default" 2>/dev/null | while read -r profile; do
    if [ -d "$profile" ]; then
        profile_name=$(basename "$profile")
        if [ -f "$profile/Login Data" ]; then
            mkdir -p "$BACKUP_DIR/$profile_name"
            cp "$profile/Login Data" "$BACKUP_DIR/$profile_name/" && echo "  ✓ Backed up $profile_name"
        fi
    fi
done
echo ""

# 3. Copy entire Chrome profile directory (optional but safe)
echo "📦 STEP 3: Creating full profile archive..."
tar -czf "$BACKUP_DIR/chrome_profiles_backup.tar.gz" \
    -C "$HOME/Library/Application Support" \
    "Google/Chrome" 2>/dev/null && echo "  ✓ Full backup created"
echo ""

# 4. List saved passwords count
echo "📊 STEP 4: Password Summary"
echo "=========================="
find "$HOME/Library/Application Support/Google/Chrome" -maxdepth 1 -type d \( -name "Profile*" -o -name "Default" \) 2>/dev/null | while read -r profile; do
    if [ -f "$profile/Login Data" ]; then
        profile_name=$(basename "$profile")
        size=$(ls -lh "$profile/Login Data" 2>/dev/null | awk '{print $5}')
        echo "  $profile_name: $size"
    fi
done
echo ""

echo "✅ Backup complete!"
echo "Location: $BACKUP_DIR"
echo ""
echo "⚠️  IMPORTANT: Manually export passwords from Chrome before uninstalling!"
echo "   chrome://settings/passwords → Export passwords"
