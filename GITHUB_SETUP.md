# GitHub Setup Guide

This guide will help you push all 6 projects to GitHub as separate repositories.

## Prerequisites

1. **GitHub Account**: Make sure you have a GitHub account (github.com/yksanjo)
2. **Git Configured**: Your git should be configured with your name and email
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

3. **GitHub CLI (Optional but Recommended)**:
   ```bash
   # Install GitHub CLI
   brew install gh  # macOS
   # or download from https://cli.github.com/
   
   # Authenticate
   gh auth login
   ```

## Method 1: Using GitHub CLI (Easiest)

If you have GitHub CLI installed:

```bash
# Navigate to project directory
cd /Users/yoshikondo

# For each project, create repo and push
for project in topoguard tinyguardian captcha-fights-back meshlock finprompt hack-toolkit; do
    cd $project
    gh repo create yksanjo/$project --public --source=. --remote=origin --push
    cd ..
done
```

## Method 2: Manual Setup (Step by Step)

### Step 1: Create Repositories on GitHub

Go to https://github.com/new and create these 6 repositories:

1. **topoguard** - Public
2. **tinyguardian** - Public
3. **captcha-fights-back** - Public
4. **meshlock** - Public
5. **finprompt** - Public
6. **hack-toolkit** - Public

**Important**: 
- Do NOT initialize with README, .gitignore, or license (we already have these)
- Make them all Public repositories
- Repository names must match exactly (case-sensitive)

### Step 2: Add Remotes and Push

Run these commands for each project:

#### TopoGuard
```bash
cd /Users/yoshikondo/topoguard
git remote add origin https://github.com/yksanjo/topoguard.git
git branch -M main
git push -u origin main
```

#### TinyGuardian
```bash
cd /Users/yoshikondo/tinyguardian
git remote add origin https://github.com/yksanjo/tinyguardian.git
git branch -M main
git push -u origin main
```

#### CAPTCHA That Fights Back
```bash
cd /Users/yoshikondo/captcha-fights-back
git remote add origin https://github.com/yksanjo/captcha-fights-back.git
git branch -M main
git push -u origin main
```

#### MeshLock
```bash
cd /Users/yoshikondo/meshlock
git remote add origin https://github.com/yksanjo/meshlock.git
git branch -M main
git push -u origin main
```

#### FinPrompt
```bash
cd /Users/yoshikondo/finprompt
git remote add origin https://github.com/yksanjo/finprompt.git
git branch -M main
git push -u origin main
```

#### Hack Toolkit
```bash
cd /Users/yoshikondo/hack-toolkit
git remote add origin https://github.com/yksanjo/hack-toolkit.git
git branch -M main
git push -u origin main
```

## Method 3: Automated Script

After creating repositories on GitHub, you can use the provided script:

```bash
cd /Users/yoshikondo
./push_all.sh
```

This script will:
- Add remote origin to each project
- Rename branch to main
- Push to GitHub

## Verification

After pushing, verify each repository:

1. Visit: https://github.com/yksanjo/topoguard
2. Visit: https://github.com/yksanjo/tinyguardian
3. Visit: https://github.com/yksanjo/captcha-fights-back
4. Visit: https://github.com/yksanjo/meshlock
5. Visit: https://github.com/yksanjo/finprompt
6. Visit: https://github.com/yksanjo/hack-toolkit

Each should show:
- ✅ README with detailed UX/UI descriptions
- ✅ All source code files
- ✅ LICENSE file
- ✅ Proper project structure

## Setting Up Repository Topics

After pushing, add topics to each repository for better discoverability:

### TopoGuard
Topics: `topology`, `fraud-detection`, `fintech`, `tda`, `persistent-homology`, `anomaly-detection`, `python`, `fastapi`

### TinyGuardian
Topics: `iot-security`, `llm`, `edge-computing`, `privacy`, `mqtt`, `raspberry-pi`, `ollama`, `python`

### CAPTCHA That Fights Back
Topics: `captcha`, `bot-detection`, `llm`, `behavioral-analysis`, `security`, `python`, `flask`

### MeshLock
Topics: `mesh-networking`, `iot`, `rust`, `cryptography`, `topology`, `zero-trust`, `offline-first`

### FinPrompt
Topics: `financial-assistant`, `llm`, `privacy`, `local-ai`, `tauri`, `python`, `financial-analysis`

### Hack Toolkit
Topics: `security-tools`, `ciso`, `file-integrity`, `iot-monitoring`, `captcha-testing`, `python`, `security`

## Setting Up Repository Descriptions

Add these descriptions on GitHub:

- **TopoGuard**: "Topology-Inspired Anomaly Detection for FinTech Transactions - Where algebraic topology meets anti-fraud"
- **TinyGuardian**: "On-Device LLM + IoT Security Agent - Privacy-preserving AI security monitoring for edge devices"
- **CAPTCHA That Fights Back**: "Adaptive Behavioral CAPTCHA with LLM-Powered Challenge Generation - Defeats AI scrapers by evolving faster than bots can adapt"
- **MeshLock**: "Decentralized, Topology-Aware Secure Mesh for IoT - Zero-trust for resource-constrained devices"
- **FinPrompt**: "Local LLM for Secure Financial Querying - No cloud = no breach risk. Privacy-first financial assistant"
- **Hack Toolkit**: "CISO in a Box - A collection of small, auditable security scripts for CISOs"

## Creating a Portfolio Organization (Optional)

Consider creating a GitHub organization to group these projects:

1. Go to https://github.com/organizations/new
2. Create organization: "yksanjo-portfolio" or similar
3. Transfer repositories to the organization
4. Add a README to the organization profile

## Next Steps

1. ✅ All repositories pushed to GitHub
2. 📸 Add screenshots to `docs/screenshots/` directories
3. 🔖 Add topics and descriptions
4. ⭐ Pin 3 main repositories on your GitHub profile
5. 📝 Update portfolio README with links to all projects
6. 🚀 Share on social media/LinkedIn

## Troubleshooting

### Authentication Issues

If you get authentication errors:

```bash
# Use personal access token
git remote set-url origin https://YOUR_TOKEN@github.com/yksanjo/PROJECT_NAME.git

# Or use SSH
git remote set-url origin git@github.com:yksanjo/PROJECT_NAME.git
```

### Repository Already Exists

If repository already exists on GitHub:

```bash
git remote add origin https://github.com/yksanjo/PROJECT_NAME.git
git pull origin main --allow-unrelated-histories
git push -u origin main
```

### Branch Name Issues

If you need to rename branch:

```bash
git branch -M main
git push -u origin main
```

## Quick Reference

All repository URLs:
- https://github.com/yksanjo/topoguard
- https://github.com/yksanjo/tinyguardian
- https://github.com/yksanjo/captcha-fights-back
- https://github.com/yksanjo/meshlock
- https://github.com/yksanjo/finprompt
- https://github.com/yksanjo/hack-toolkit




