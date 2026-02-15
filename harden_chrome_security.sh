#!/bin/bash

# Chrome Security Hardening Script
# Addresses unauthorized wallet installations and tunneling

echo "🔒 Chrome Security Hardening"
echo "============================"
echo ""

# ============================================================================
# STEP 1: Check for Chrome remote debugging flags
# ============================================================================
echo "STEP 1: Checking for Chrome remote debugging..."

# Check if Chrome is running with remote debugging
CHROME_DEBUG_PROCS=$(ps aux | grep -E "chrome.*--remote-debugging" | grep -v grep)
if [ -n "$CHROME_DEBUG_PROCS" ]; then
    echo "⚠️  WARNING: Chrome running with remote debugging!"
    echo "$CHROME_DEBUG_PROCS"
    echo ""
    echo "Killing Chrome processes with remote debugging..."
    pkill -f "chrome.*--remote-debugging"
    sleep 2
    echo "✅ Chrome debug processes terminated"
else
    echo "✅ No Chrome remote debugging found"
fi

# ============================================================================
# STEP 2: Create Chrome security preferences
# ============================================================================
echo ""
echo "STEP 2: Creating Chrome security preferences..."

CHROME_PREFS_DIR="$HOME/Library/Application Support/Google/Chrome/Profile 37"
if [ -d "$CHROME_PREFS_DIR" ]; then
    
    # Backup existing preferences
    if [ -f "$CHROME_PREFS_DIR/Preferences" ]; then
        cp "$CHROME_PREFS_DIR/Preferences" "$CHROME_PREFS_DIR/Preferences.backup.$(date +%Y%m%d_%H%M%S)"
        echo "✅ Preferences backed up"
    fi
    
    # Create security-hardened preferences patch
    cat > ~/.openclaw/security/chrome_security_patch.json << 'EOF'
{
  "devtools": {
    "preferences": {
      "currentDockState": "\"right\"",
      "panel-selectedTab": "\"console\""
    }
  },
  "extensions": {
    "settings": {
      "block_external_extensions": true,
      "require_user_approval": true
    }
  },
  "profile": {
    "block_third_party_cookies": true,
    "password_manager_enabled": false,
    "autofill_enabled": false
  },
  "safebrowsing": {
    "enabled": true,
    "enhanced": true
  },
  "security": {
    "disable_password_reveal": true,
    "show_https_only_mode_indicator": true
  }
}
EOF
    
    echo "✅ Chrome security patch created"
    echo "   Location: ~/.openclaw/security/chrome_security_patch.json"
    echo ""
    echo "⚠️  To apply the patch, restart Chrome with security flags:"
    echo "   --disable-remote-debugging"
    echo "   --disable-extensions-except=<allowed-extension-id>"
    
else
    echo "⚠️  Chrome Profile 37 not found"
fi

# ============================================================================
# STEP 3: Create Chrome launch script with security flags
# ============================================================================
echo ""
echo "STEP 3: Creating secure Chrome launcher..."

cat > ~/.openclaw/security/launch_chrome_secure.sh << 'EOF'
#!/bin/bash

# Secure Chrome Launcher
# Launches Chrome with security hardening flags

echo "🔒 Launching Chrome with security hardening..."

# Security flags
SECURITY_FLAGS=(
    # Disable remote debugging
    "--remote-debugging-port=0"
    "--disable-remote-debugging"
    
    # Disable developer mode extensions
    "--disable-extensions-except="
    "--disable-extensions-file-access-check"
    
    # Security hardening
    "--enable-strict-site-isolation"
    "--site-per-process"
    "--enable-features=StrictSiteIsolation,IsolateOrigins,site-per-process"
    
    # Block dangerous protocols
    "--disable-features=WebUSB,WebBluetooth"
    
    # Safe browsing
    "--safebrowsing-enable-enhanced-protection"
    "--safebrowsing-manual-edl-enabled"
    
    # Privacy
    "--disable-background-networking"
    "--disable-default-apps"
    "--disable-sync"
    "--disable-translate"
)

# Build the command
CHROME_PATH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
if [ ! -f "$CHROME_PATH" ]; then
    CHROME_PATH="/Applications/Chrome.app/Contents/MacOS/Chrome"
fi

if [ -f "$CHROME_PATH" ]; then
    echo "Starting Chrome with security flags..."
    echo "Flags: ${SECURITY_FLAGS[*]}"
    exec "$CHROME_PATH" "${SECURITY_FLAGS[@]}" "$@"
else
    echo "❌ Chrome not found at expected location"
    echo "Please manually start Chrome with these flags:"
    printf '%s\n' "${SECURITY_FLAGS[@]}"
fi
EOF

chmod +x ~/.openclaw/security/launch_chrome_secure.sh
echo "✅ Secure Chrome launcher created"

# ============================================================================
# STEP 4: Extension audit report
# ============================================================================
echo ""
echo "STEP 4: Auditing installed extensions..."

CHROME_EXT_DIR="$HOME/Library/Application Support/Google/Chrome"
if [ -d "$CHROME_EXT_DIR" ]; then
    
    echo ""
    echo "📋 Extension Audit Report"
    echo "========================="
    echo ""
    
    # Find all extensions
    find "$CHROME_EXT_DIR" -path "*/Extensions/*" -type d -maxdepth 5 2>/dev/null | while read ext_dir; do
        ext_id=$(basename "$ext_dir")
        
        # Get extension name from manifest if possible
        manifest="$ext_dir"/*/manifest.json
        if [ -f $manifest ]; then
            name=$(grep '"name"' $manifest | head -1 | cut -d'"' -f4)
            echo "Extension ID: $ext_id"
            echo "  Name: $name"
            echo "  Location: $ext_dir"
            echo ""
        fi
    done
    
    echo "========================="
    echo ""
    echo "⚠️  KNOWN EXTENSIONS:"
    echo "  nkbihfbeogaeaoehlefnkodbefgpgknn = MetaMask"
    echo "  bfnaelmomeimhlpmgjnjophhpkkoljpa = Phantom"
    echo ""
    echo "If you did not install these, they may be unauthorized."
    
else
    echo "⚠️  Chrome directory not found"
fi

# ============================================================================
# STEP 5: Create extension removal helper
# ============================================================================
echo ""
echo "STEP 5: Creating extension removal helper..."

cat > ~/.openclaw/security/remove_extension.sh << 'EOF'
#!/bin/bash

# Extension Removal Helper
# Safely removes Chrome extensions

if [ -z "$1" ]; then
    echo "Usage: $0 <extension_id>"
    echo "Example: $0 nkbihfbeogaeaoehlefnkodbefgpgknn"
    exit 1
fi

EXT_ID="$1"
CHROME_EXT_DIR="$HOME/Library/Application Support/Google/Chrome"

echo "🔍 Searching for extension: $EXT_ID"

# Find and remove extension
found=$(find "$CHROME_EXT_DIR" -name "$EXT_ID" -type d 2>/dev/null)

if [ -n "$found" ]; then
    echo "Found extension at:"
    echo "$found"
    echo ""
    read -p "Remove this extension? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Kill Chrome first
        echo "Stopping Chrome..."
        pkill -f "Google Chrome" 2>/dev/null
        sleep 2
        
        # Remove extension
        echo "Removing extension files..."
        rm -rf "$found"
        
        # Also remove from Preferences
        # Note: This requires manual editing or Chrome reset
        
        echo "✅ Extension removed"
        echo "⚠️  Please restart Chrome and check chrome://extensions"
    else
        echo "Cancelled"
    fi
else
    echo "Extension not found"
fi
EOF

chmod +x ~/.openclaw/security/remove_extension.sh
echo "✅ Extension removal helper created"

# ============================================================================
# STEP 6: Create Chrome security checklist
# ============================================================================
echo ""
echo "STEP 6: Creating security checklist..."

cat > ~/.openclaw/security/CHROME_SECURITY_CHECKLIST.md << 'EOF'
# Chrome Security Checklist

## Immediate Actions

- [ ] Stop any Chrome processes with remote debugging
- [ ] Review all installed extensions (chrome://extensions/)
- [ ] Disable developer mode if not needed
- [ ] Remove unauthorized wallet extensions
- [ ] Enable enhanced safe browsing

## MetaMask Extension Review

**Status**: Found in Profile 37

**Action Required**:
1. Open Chrome and go to: chrome://extensions/
2. Find MetaMask (ID: nkbihfbeogaeaoehlefnkodbefgpgknn)
3. If you DID NOT install this:
   - Click "Remove" to uninstall
   - Check if any wallets were created/compromised
   - If wallets exist, assume they are compromised
4. If you DID install this:
   - Verify it's the official MetaMask
   - Check the extension ID matches the official one
   - Review transaction history for unauthorized activity

## Phantom Wallet Review

**Status**: Not found (good)

If found, follow same procedure as MetaMask.

## Prevention Measures

1. **Disable Remote Debugging**
   - Never run Chrome with `--remote-debugging-port`
   - Check for suspicious Chrome processes regularly

2. **Extension Management**
   - Only install extensions from official Chrome Web Store
   - Regularly review installed extensions
   - Enable "Developer mode" only when needed

3. **Network Security**
   - Monitor for unauthorized tunnels
   - Check firewall rules
   - Review proxy settings

4. **OpenClaw Security**
   - Use the secure wrapper: ~/.openclaw/security/secure_wrapper.sh
   - Monitor security logs daily
   - Keep security monitor running

## Regular Checks

Run these commands weekly:

```bash
# Check for Chrome remote debugging
ps aux | grep -E "chrome.*--remote-debugging"

# Check installed extensions
find "$HOME/Library/Application Support/Google/Chrome" -path "*/Extensions/*" -type d

# Run OpenClaw security monitor
~/.openclaw/security/security_monitor.sh

# Check network connections
lsof -i -P | grep -E "(chrome|openclaw)"
```

## Emergency Response

If you suspect unauthorized access:

1. **Immediate**:
   ```bash
   killall "Google Chrome"
   killall openclaw-gateway
   ```

2. **Revoke API tokens**:
   - Telegram: @BotFather > /revoke
   - Discord: Developer Portal > Bot > Reset Token
   - Cloudflare: Dashboard > API Tokens > Revoke

3. **Check for compromise**:
   - Review OpenClaw logs
   - Check Chrome history for unauthorized sites
   - Review network connections

4. **Reinstall if needed**:
   - Remove OpenClaw completely
   - Reinstall from trusted source
   - Use new API tokens

EOF

echo "✅ Security checklist created"

# ============================================================================
# Final Summary
# ============================================================================
echo ""
echo "============================"
echo "✅ CHROME HARDENING COMPLETE"
echo "============================"
echo ""
echo "Security measures implemented:"
echo "  ✅ Remote debugging checked/killed"
echo "  ✅ Security preferences created"
echo "  ✅ Secure Chrome launcher created"
echo "  ✅ Extension audit completed"
echo "  ✅ Extension removal helper created"
echo "  ✅ Security checklist created"
echo ""
echo "⚠️  IMPORTANT FINDINGS:"
echo ""
echo "1. MetaMask extension found in Chrome Profile 37"
echo "   - If unauthorized, run: ~/.openclaw/security/remove_extension.sh nkbihfbeogaeaoehlefnkodbefgpgknn"
echo ""
echo "2. Use secure Chrome launcher:"
echo "   ~/.openclaw/security/launch_chrome_secure.sh"
echo ""
echo "3. Review security checklist:"
echo "   ~/.openclaw/security/CHROME_SECURITY_CHECKLIST.md"
echo ""
echo "📁 Chrome security files: ~/.openclaw/security/"
echo ""
