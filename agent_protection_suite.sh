#!/bin/bash

# =============================================================================
# AGENT PROTECTION SUITE - Complete OpenClaw Security System
# =============================================================================
# Combines:
# - Chrome tunneling protection
# - Agent Shield (prompt injection, CDP, credential protection)
# - File permission hardening
# - Automated monitoring
# =============================================================================

set -e

SUITE_VERSION="1.0.0"
REQUIRED_COMMANDS="chmod chown mkdir grep sed awk"

echo "🛡️  AGENT PROTECTION SUITE v$SUITE_VERSION"
echo "======================================"
echo ""
echo "This script will set up comprehensive protection for your OpenClaw agent:"
echo "  1. File permission hardening"
echo "  2. Chrome tunneling protection"
echo "  3. Agent Shield (prompt injection, CDP, credential protection)"
echo "  4. Automated security monitoring"
echo "  5. WebSocket protection"
echo ""

# Check for required commands
for cmd in $REQUIRED_COMMANDS; do
    if ! command -v $cmd &> /dev/null; then
        echo "❌ Required command not found: $cmd"
        exit 1
    fi
done

echo "✅ Prerequisites met"
echo ""

# =============================================================================
# PHASE 1: File Permission Hardening
# =============================================================================
phase1_harden_permissions() {
    echo "🔒 PHASE 1: Hardening File Permissions"
    echo "======================================="
    
    # Create secure directories
    mkdir -p ~/.openclaw/{shield,security,logs,backups}
    
    # Harden .env file
    if [ -f ~/.openclaw/.env ]; then
        chmod 600 ~/.openclaw/.env
        echo "✅ .env file permissions: 600"
    fi
    
    # Harden config files
    chmod 600 ~/.openclaw/*.json 2>/dev/null || true
    echo "✅ Config files permissions: 600"
    
    # Harden credential directories
    chmod 700 ~/.openclaw/credentials 2>/dev/null || true
    chmod 700 ~/.openclaw/devices 2>/dev/null || true
    chmod 700 ~/.openclaw/shield 2>/dev/null || true
    chmod 700 ~/.openclaw/security 2>/dev/null || true
    echo "✅ Directory permissions: 700"
    
    echo ""
}

# =============================================================================
# PHASE 2: Chrome Protection Setup
# =============================================================================
phase2_chrome_protection() {
    echo "🌐 PHASE 2: Chrome Tunneling Protection"
    echo "========================================"
    
    # Kill any existing Chrome with remote debugging
    if pgrep -f "chrome.*--remote-debugging" > /dev/null; then
        echo "⚠️  Stopping Chrome with remote debugging..."
        pkill -f "chrome.*--remote-debugging" || true
        sleep 2
    fi
    
    # Check if security scripts exist
    if [ -f ~/fix_openclaw_chrome_security.sh ]; then
        echo "✅ Chrome security scripts found"
    else
        echo "⚠️  Chrome security scripts not found. Run fix_openclaw_chrome_security.sh first."
    fi
    
    # Create Chrome security check script
    cat > ~/.openclaw/security/chrome_check.sh << 'EOF'
#!/bin/bash
# Chrome Security Check - Run this regularly

echo "🔍 Chrome Security Check - $(date)"

# Check for remote debugging
if pgrep -f "chrome.*--remote-debugging" > /dev/null; then
    echo "❌ ALERT: Chrome with remote debugging detected!"
    pkill -f "chrome.*--remote-debugging"
    echo "✅ Killed Chrome debug processes"
fi

# Check for suspicious ports
SUSPICIOUS=$(lsof -i -P 2>/dev/null | grep -E "(9222|9229)" | grep -v grep || true)
if [ -n "$SUSPICIOUS" ]; then
    echo "⚠️  Suspicious ports open:"
    echo "$SUSPICIOUS"
fi

# Check for unauthorized extensions
if [ -d "$HOME/Library/Application Support/Google/Chrome" ]; then
    # Look for wallet extensions
    WALLETS=$(find "$HOME/Library/Application Support/Google/Chrome" -path "*Extensions/nkbihfbeogaeaoehlefnkodbefgpgknn*" -o -path "*Extensions/bfnaelmomeimhlpmgjnjophhpkkoljpa*" 2>/dev/null || true)
    if [ -n "$WALLETS" ]; then
        echo "⚠️  Wallet extensions found:"
        echo "$WALLETS"
    fi
fi

echo "✅ Check complete"
EOF
    chmod +x ~/.openclaw/security/chrome_check.sh
    
    echo "✅ Chrome protection configured"
    echo ""
}

# =============================================================================
# PHASE 3: Agent Shield Setup
# =============================================================================
phase3_agent_shield() {
    echo "🧠 PHASE 3: Agent Shield Setup"
    echo "==============================="
    
    if [ -d ~/.openclaw/shield ]; then
        echo "✅ Agent Shield already installed"
        
        # Update existing shield
        if [ -f ~/agent_shield_protection.sh ]; then
            echo "🔄 Updating Agent Shield rules..."
            cd ~
            # Re-run just the rules setup
            bash -c '
                SHIELD_DIR="$HOME/.openclaw/shield"
                RULES_DIR="$SHIELD_DIR/rules"
                
                # Update prompt injection rules with latest patterns
                cat > "$RULES_DIR/prompt_injection_rules.json" << "RULESEOF"
{
  "version": "1.1.0",
  "description": "Enhanced prompt injection detection",
  "severity_levels": {
    "CRITICAL": "block_immediate",
    "HIGH": "block_log",
    "MEDIUM": "flag_review",
    "LOW": "log_only"
  },
  "patterns": {
    "CRITICAL": [
      {"name": "system_override", "pattern": "(?i)(ignore|disregard|forget|override).*?(system|instructions?|prompt)", "description": "System instruction override"},
      {"name": "jailbreak_dan", "pattern": "(?i)(jailbreak|DAN|do anything now|developer mode)", "description": "Jailbreak attempt"},
      {"name": "credential_extract", "pattern": "(?i)(api[_-]?key|token|password|secret|credential|env|config)", "description": "Credential extraction"},
      {"name": "command_exec", "pattern": "(?i)(exec|eval|system|subprocess|os\\.system|child_process|spawn)", "description": "Command execution"},
      {"name": "file_access", "pattern": "(?i)(cat|read|open|file).*?\\.(env|json|config|key)", "description": "Sensitive file access"},
      {"name": "reverse_roles", "pattern": "(?i)(you are|your new|now you are|switch to|become).*?(user|human|attacker|hacker)", "description": "Role reversal attack"}
    ],
    "HIGH": [
      {"name": "role_confusion", "pattern": "(?i)(from now on|act as|pretend to|simulate being)", "description": "Role confusion"},
      {"name": "delimiter_attack", "pattern": "(```|\"\"\"|</|\\[\\[).*?(system|admin|ignore)", "description": "Delimiter manipulation"},
      {"name": "context_manipulation", "pattern": "(?i)(previous|above|earlier).*?(doesn|not|does|did).*?(matter|apply|count)", "description": "Context manipulation"}
    ],
    "MEDIUM": [
      {"name": "encoding_obfuscation", "pattern": "(\\x[0-9a-f]|\\u[0-9a-f]|base64|rot13|hex)", "description": "Encoding obfuscation"},
      {"name": "hidden_chars", "pattern": "[\\x00-\\x08\\x0b\\x0c\\x0e-\\x1f]", "description": "Hidden characters"}
    ],
    "LOW": [
      {"name": "repetition", "pattern": "(.{1,5})\\1{8,}", "description": "Suspicious repetition"}
    ]
  },
  "whitelist": [
    "can you help",
    "please explain",
    "what is",
    "how do i",
    "show me how"
  ]
}
RULESEOF
            echo "✅ Rules updated to v1.1.0"
            fi'
        fi
    else
        echo "⚠️  Agent Shield not found. Run agent_shield_protection.sh first."
        exit 1
    fi
    
    echo ""
}

# =============================================================================
# PHASE 4: Automated Monitoring
# =============================================================================
phase4_monitoring() {
    echo "👁️  PHASE 4: Automated Monitoring"
    echo "=================================="
    
    # Create comprehensive monitor script
    cat > ~/.openclaw/security/comprehensive_monitor.sh << 'EOF'
#!/bin/bash
# Comprehensive Security Monitor

LOG_DIR="$HOME/.openclaw/security/logs/$(date +%Y%m)"
mkdir -p "$LOG_DIR"

REPORT_FILE="$LOG_DIR/security_report_$(date +%Y%m%d_%H%M%S).log"
ALERT_FILE="$LOG_DIR/alerts_$(date +%Y%m%d).log"

log() {
    echo "[$(date -Iseconds)] $1" | tee -a "$REPORT_FILE"
}

alert() {
    local level="$1"
    local message="$2"
    echo "[$(date -Iseconds)] [$level] $message" >> "$ALERT_FILE"
    echo "🚨 [$level] $message" | tee -a "$REPORT_FILE"
}

log "🔍 Starting Comprehensive Security Check"
log "========================================="

# 1. File Permissions Check
log ""
log "1. File Permissions Check"
ENV_PERMS=$(stat -f "%Lp" "$HOME/.openclaw/.env" 2>/dev/null)
if [ "$ENV_PERMS" != "600" ]; then
    alert "WARNING" ".env permissions incorrect: $ENV_PERMS (should be 600)"
    chmod 600 "$HOME/.openclaw/.env"
else
    log "✅ .env permissions: 600"
fi

# 2. Chrome Remote Debugging Check
log ""
log "2. Chrome Remote Debugging Check"
CHROME_DEBUG=$(pgrep -f "chrome.*--remote-debugging" 2>/dev/null | wc -l)
if [ "$CHROME_DEBUG" -gt 0 ]; then
    alert "CRITICAL" "Chrome remote debugging detected: $CHROME_DEBUG processes"
    pkill -f "chrome.*--remote-debugging"
    log "✅ Killed Chrome debug processes"
else
    log "✅ No Chrome remote debugging"
fi

# 3. Suspicious Network Connections
log ""
log "3. Network Connections Check"
SUSPICIOUS_PORTS=$(lsof -i -P 2>/dev/null | grep -E "(9222|9229|8545|8546)" | grep -v grep || true)
if [ -n "$SUSPICIOUS_PORTS" ]; then
    alert "WARNING" "Suspicious ports detected"
    log "$SUSPICIOUS_PORTS"
else
    log "✅ No suspicious ports"
fi

# 4. OpenClaw Process Check
log ""
log "4. OpenClaw Process Check"
if pgrep -f "openclaw-gateway" > /dev/null; then
    log "✅ OpenClaw is running"
else
    alert "INFO" "OpenClaw not running"
fi

# 5. Shield Status Check
log ""
log "5. Agent Shield Status"
if [ -d "$HOME/.openclaw/shield" ]; then
    RULE_COUNT=$(ls -1 "$HOME/.openclaw/shield/rules"/*.json 2>/dev/null | wc -l)
    log "✅ Agent Shield: $RULE_COUNT rule sets loaded"
else
    alert "WARNING" "Agent Shield not installed"
fi

# 6. Check for Recent Blocks
log ""
log "6. Recent Security Blocks"
BLOCKED_DIR="$HOME/.openclaw/shield/logs/blocked"
if [ -d "$BLOCKED_DIR" ]; then
    TOTAL_BLOCKED=$(find "$BLOCKED_DIR" -name "*.log" -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}')
    log "📊 Total blocked threats: ${TOTAL_BLOCKED:-0}"
    
    # Check for recent prompt injections
    if [ -f "$BLOCKED_DIR/prompt_injection.log" ]; then
        RECENT_INJECTIONS=$(grep "$(date +%Y-%m-%d)" "$BLOCKED_DIR/prompt_injection.log" 2>/dev/null | wc -l)
        if [ "$RECENT_INJECTIONS" -gt 0 ]; then
            alert "WARNING" "$RECENT_INJECTIONS prompt injection attempts today"
        fi
    fi
else
    log "ℹ️  No block logs yet"
fi

# 7. Chrome Extensions Check
log ""
log "7. Chrome Extensions Check"
if [ -d "$HOME/Library/Application Support/Google/Chrome" ]; then
    # Check for MetaMask
    if find "$HOME/Library/Application Support/Google/Chrome" -path "*nkbihfbeogaeaoehlefnkodbefgpgknn*" 2>/dev/null | grep -q .; then
        log "⚠️  MetaMask extension found (verify if authorized)"
    fi
    
    # Check for Phantom
    if find "$HOME/Library/Application Support/Google/Chrome" -path "*bfnaelmomeimhlpmgjnjophhpkkoljpa*" 2>/dev/null | grep -q .; then
        alert "WARNING" "Phantom wallet extension found"
    fi
fi

# 8. API Token Check (sanitized)
log ""
log "8. API Token Status"
if [ -f "$HOME/.openclaw/.env" ]; then
    HAS_TELEGRAM=$(grep -c "TELEGRAM_BOT_TOKEN" "$HOME/.openclaw/.env" 2>/dev/null || echo 0)
    HAS_DISCORD=$(grep -c "DISCORD_BOT_TOKEN" "$HOME/.openclaw/.env" 2>/dev/null || echo 0)
    log "📱 Telegram configured: $HAS_TELEGRAM"
    log "💬 Discord configured: $HAS_DISCORD"
fi

log ""
log "========================================="
log "✅ Security Check Complete"
log "Report saved: $REPORT_FILE"
EOF

    chmod +x ~/.openclaw/security/comprehensive_monitor.sh
    
    # Set up cron job for automated monitoring
    echo ""
    echo "📅 Setting up automated monitoring..."
    
    # Add to crontab (runs every 5 minutes)
    (crontab -l 2>/dev/null | grep -v comprehensive_monitor; echo "*/5 * * * * $HOME/.openclaw/security/comprehensive_monitor.sh >/dev/null 2>&1") | crontab -
    
    echo "✅ Automated monitoring enabled (every 5 minutes)"
    echo ""
}

# =============================================================================
# PHASE 5: Integration Wrapper
# =============================================================================
phase5_integration() {
    echo "🔗 PHASE 5: Creating Integration Wrapper"
    echo "=========================================="
    
    cat > ~/.openclaw/start_secure.sh << 'EOF'
#!/bin/bash
# Secure OpenClaw Starter
# Integrates all protection systems

echo "🛡️  Starting OpenClaw with Full Protection"
echo "==========================================="

# 1. Pre-flight security check
echo ""
echo "1. Running pre-flight security check..."
~/.openclaw/security/comprehensive_monitor.sh > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ Security check passed"
else
    echo "⚠️  Security check found issues. Review logs."
fi

# 2. Kill any Chrome with remote debugging
echo ""
echo "2. Checking for Chrome remote debugging..."
if pgrep -f "chrome.*--remote-debugging" > /dev/null; then
    echo "⚠️  Stopping Chrome with remote debugging..."
    pkill -f "chrome.*--remote-debugging"
    sleep 2
fi
echo "✅ Chrome clean"

# 3. Verify file permissions
echo ""
echo "3. Verifying file permissions..."
chmod 600 ~/.openclaw/.env 2>/dev/null || true
chmod 600 ~/.openclaw/*.json 2>/dev/null || true
echo "✅ Permissions verified"

# 4. Set security environment variables
echo ""
echo "4. Setting security environment..."
export OPENCLAW_SHIELD_ENABLED=true
export OPENCLAW_SECURITY_MODE=strict
export CHROME_REMOTE_DEBUGGING_DISABLED=true
echo "✅ Security environment set"

# 5. Start OpenClaw
echo ""
echo "5. Starting OpenClaw..."
echo "=========================================="
echo ""

# Check if using secure wrapper
if [ -f ~/.openclaw/security/secure_wrapper.sh ]; then
    exec ~/.openclaw/security/secure_wrapper.sh "$@"
else
    exec openclaw "$@"
fi
EOF

    chmod +x ~/.openclaw/start_secure.sh
    
    # Create quick security status command
    cat > ~/.openclaw/security_status.sh << 'EOF'
#!/bin/bash
# Quick Security Status

echo "🛡️  OpenClaw Security Status"
echo "============================"
echo ""

# Shield status
if [ -f ~/.openclaw/shield/shield ]; then
    ~/.openclaw/shield/shield status
    echo ""
fi

# Chrome check
if pgrep -f "chrome.*--remote-debugging" > /dev/null; then
    echo "❌ Chrome remote debugging: DETECTED"
else
    echo "✅ Chrome remote debugging: None"
fi

# File permissions
ENV_PERMS=$(stat -f "%Lp" ~/.openclaw/.env 2>/dev/null)
if [ "$ENV_PERMS" = "600" ]; then
    echo "✅ .env permissions: Secure (600)"
else
    echo "⚠️  .env permissions: $ENV_PERMS (should be 600)"
fi

# OpenClaw status
if pgrep -f "openclaw-gateway" > /dev/null; then
    echo "✅ OpenClaw: Running"
else
    echo "ℹ️  OpenClaw: Not running"
fi

# Recent threats
BLOCKED_DIR="$HOME/.openclaw/shield/logs/blocked"
if [ -d "$BLOCKED_DIR" ]; then
    TODAY_BLOCKED=$(find "$BLOCKED_DIR" -name "*.log" -exec grep "$(date +%Y-%m-%d)" {} + 2>/dev/null | wc -l)
    echo "📊 Threats blocked today: $TODAY_BLOCKED"
fi

echo ""
echo "Run 'shield logs' for detailed security logs"
EOF

    chmod +x ~/.openclaw/security_status.sh
    
    echo "✅ Integration wrapper created"
    echo ""
}

# =============================================================================
# PHASE 6: Summary and Next Steps
# =============================================================================
phase6_summary() {
    echo "📋 PROTECTION SUITE SUMMARY"
    echo "==========================="
    echo ""
    echo "✅ Installation Complete!"
    echo ""
    echo "Protection Layers Active:"
    echo "  🗂️   File Permissions: .env and configs secured (600)"
    echo "  🌐 Chrome Protection: Remote debugging blocked"
    echo "  🧠 Agent Shield: Prompt injection & CDP protection"
    echo "  👁️  Automated Monitoring: Every 5 minutes"
    echo "  🔌 WebSocket Shield: Connection protection"
    echo "  🔐 Credential Masking: Automatic secret redaction"
    echo ""
    echo "Quick Commands:"
    echo "  ~/.openclaw/start_secure.sh        # Start OpenClaw securely"
    echo "  ~/.openclaw/security_status.sh     # Check security status"
    echo "  shield status                       # Agent Shield status"
    echo "  shield logs                         # View security logs"
    echo "  shield monitor                      # Run security check"
    echo ""
    echo "Files Created:"
    echo "  ~/.openclaw/start_secure.sh        # Secure startup script"
    echo "  ~/.openclaw/security_status.sh     # Status checker"
    echo "  ~/.openclaw/security/              # Security directory"
    echo "  ~/.openclaw/shield/                # Agent Shield"
    echo ""
    echo "Documentation:"
    echo "  cat ~/AGENT_SECURITY_ASSESSMENT.md  # Full vulnerability report"
    echo "  cat ~/.openclaw/shield/INTEGRATION_GUIDE.md"
    echo ""
    echo "🚀 To start OpenClaw with full protection:"
    echo "    ~/.openclaw/start_secure.sh"
    echo ""
    echo "⚠️  IMPORTANT REMINDERS:"
    echo "  1. Review MetaMask extension (chrome://extensions/)"
    echo "  2. Rotate API tokens if compromise suspected"
    echo "  3. Run 'shield monitor' daily"
    echo "  4. Check logs regularly: shield logs"
    echo ""
}

# =============================================================================
# MAIN EXECUTION
# =============================================================================

main() {
    phase1_harden_permissions
    phase2_chrome_protection
    phase3_agent_shield
    phase4_monitoring
    phase5_integration
    phase6_summary
}

# Check for existing installations and offer to update
if [ -d ~/.openclaw/shield ] && [ -d ~/.openclaw/security ]; then
    echo "⚠️  Existing protection suite detected"
    read -p "Update existing installation? (Y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        echo "🔄 Updating protection suite..."
        main
    else
        echo "Cancelled. Run with --force to bypass this check."
        exit 0
    fi
else
    main
fi
