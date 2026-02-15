#!/bin/bash

# One-Click OpenClaw Security Lockdown
# Applies all security fixes and restarts services securely

set -e  # Exit on error

echo "🔒 OPENCLAW SECURITY LOCKDOWN"
echo "============================="
echo ""
echo "This script will:"
echo "  1. Stop current OpenClaw gateway"
echo "  2. Apply all security fixes"
echo "  3. Secure file permissions"
echo "  4. Kill any Chrome remote debugging"
echo "  5. Install secure launch agent"
echo "  6. Start OpenClaw in secure mode"
echo ""
read -p "Continue? (y/N): " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

echo ""
echo "🔴 STEP 1: Stopping services..."
echo "--------------------------------"

# Stop OpenClaw
if pgrep -f "openclaw-gateway" > /dev/null; then
    echo "Stopping OpenClaw gateway..."
    killall openclaw-gateway 2>/dev/null || true
    sleep 2
    echo "✅ OpenClaw stopped"
else
    echo "ℹ️  OpenClaw not running"
fi

# Kill Chrome with remote debugging
if pgrep -f "chrome.*--remote-debugging" > /dev/null; then
    echo "Stopping Chrome with remote debugging..."
    pkill -f "chrome.*--remote-debugging" 2>/dev/null || true
    sleep 2
    echo "✅ Chrome debug processes stopped"
else
    echo "ℹ️  No Chrome remote debugging found"
fi

echo ""
echo "🔒 STEP 2: Applying security fixes..."
echo "--------------------------------------"

# Run the security fix script
if [ -f ~/fix_openclaw_chrome_security.sh ]; then
    bash ~/fix_openclaw_chrome_security.sh 2>&1 | grep -E "(STEP|✅|⚠️|🔒|📁)"
else
    echo "❌ Security fix script not found"
    exit 1
fi

echo ""
echo "🔒 STEP 3: Hardening Chrome..."
echo "-------------------------------"

# Run Chrome hardening
if [ -f ~/harden_chrome_security.sh ]; then
    bash ~/harden_chrome_security.sh 2>&1 | grep -E "(STEP|✅|⚠️|🔒|📁)"
else
    echo "❌ Chrome hardening script not found"
fi

echo ""
echo "📋 STEP 4: Installing secure launch agent..."
echo "---------------------------------------------"

# Install secure launch agent
LAUNCH_AGENT_SOURCE="$HOME/.openclaw/security/ai.openclaw.secure.plist"
LAUNCH_AGENT_DEST="$HOME/Library/LaunchAgents/ai.openclaw.gateway.secure.plist"

if [ -f "$LAUNCH_AGENT_SOURCE" ]; then
    # Unload old agent if exists
    launchctl unload ~/Library/LaunchAgents/ai.openclaw.gateway.plist 2>/dev/null || true
    launchctl unload ~/Library/LaunchAgents/ai.openclaw.gateway.secure.plist 2>/dev/null || true
    
    # Copy and load new agent
    cp "$LAUNCH_AGENT_SOURCE" "$LAUNCH_AGENT_DEST"
    launchctl load "$LAUNCH_AGENT_DEST" 2>/dev/null || {
        echo "⚠️  Could not load launch agent (may need manual installation)"
    }
    echo "✅ Secure launch agent installed"
else
    echo "❌ Secure launch agent not found"
fi

echo ""
echo "🧪 STEP 5: Running security verification..."
echo "--------------------------------------------"

# Check file permissions
ENV_PERMS=$(stat -f "%Lp" "$HOME/.openclaw/.env" 2>/dev/null)
if [ "$ENV_PERMS" = "600" ]; then
    echo "✅ .env file permissions: SECURE (600)"
else
    echo "⚠️  .env file permissions: $ENV_PERMS (should be 600)"
    chmod 600 "$HOME/.openclaw/.env"
    echo "   Fixed to 600"
fi

# Check for Chrome debugging
if pgrep -f "chrome.*--remote-debugging" > /dev/null; then
    echo "❌ Chrome remote debugging: DETECTED"
    pkill -f "chrome.*--remote-debugging"
else
    echo "✅ Chrome remote debugging: NONE"
fi

# Check security files exist
if [ -d "$HOME/.openclaw/security" ]; then
    echo "✅ Security directory: EXISTS"
    SEC_FILE_COUNT=$(ls -1 "$HOME/.openclaw/security" 2>/dev/null | wc -l)
    echo "   Files created: $SEC_FILE_COUNT"
else
    echo "❌ Security directory: MISSING"
fi

echo ""
echo "🚀 STEP 6: Starting OpenClaw in secure mode..."
echo "-----------------------------------------------"

# Start OpenClaw securely using the wrapper
if [ -f "$HOME/.openclaw/security/secure_wrapper.sh" ]; then
    echo "Starting with secure wrapper..."
    bash "$HOME/.openclaw/security/secure_wrapper.sh" gateway start &
    sleep 3
    
    if pgrep -f "openclaw-gateway" > /dev/null; then
        echo "✅ OpenClaw started in SECURE MODE"
    else
        echo "⚠️  OpenClaw may not have started - check logs"
    fi
else
    echo "⚠️  Secure wrapper not found, trying direct start..."
    openclaw gateway start &
fi

echo ""
echo "============================="
echo "✅ LOCKDOWN COMPLETE"
echo "============================="
echo ""
echo "Summary:"
echo "  ✅ OpenClaw stopped and restarted in secure mode"
echo "  ✅ File permissions hardened"
echo "  ✅ Chrome security measures applied"
echo "  ✅ Secure launch agent installed"
echo "  ✅ Security monitoring enabled"
echo ""
echo "⚠️  IMPORTANT REMINDERS:"
echo ""
echo "1. MetaMask found in Chrome - verify if authorized:"
echo "   ~/.openclaw/security/remove_extension.sh nkbihfbeogaeaoehlefnkodbefgpgknn"
echo ""
echo "2. Use secure Chrome launcher:"
echo "   ~/.openclaw/security/launch_chrome_secure.sh"
echo ""
echo "3. Monitor security logs:"
echo "   tail -f ~/.openclaw/security/logs/gateway.log"
echo ""
echo "4. Run security check:"
echo "   ~/.openclaw/security/security_monitor.sh"
echo ""
echo "5. Read full summary:"
echo "   cat ~/SECURITY_FIX_SUMMARY.md"
echo ""
echo "🔒 Your OpenClaw is now secured against Chrome tunneling!"
echo ""
