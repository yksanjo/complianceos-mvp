# Adding Real Screenshots Guide

## Current Status

✅ **Placeholder images have been created** for all projects
✅ **README files already reference screenshots** with proper markdown syntax
✅ **Screenshot directories are set up** in `docs/screenshots/`

## What You'll See Now

The README files will display placeholder images that show:
- Project name
- Screenshot description
- "Screenshot Placeholder" text
- Colored borders matching each project's theme

## Replacing with Real Screenshots

### Step 1: Generate Screenshots

Follow the instructions in `SCREENSHOT_GUIDE.md` or use the automated scripts:

**TopoGuard:**
```bash
cd topoguard
# Start server first: uvicorn api.main:app --reload --port 8000
python scripts/capture_screenshots.py
```

**TinyGuardian:**
```bash
cd tinyguardian
# Start agent first: python main.py
python scripts/capture_screenshots.py
```

**CAPTCHA:**
```bash
cd captcha-fights-back
# Start server first: python app.py
python scripts/capture_screenshots.py
```

### Step 2: Replace Placeholder Images

Simply replace the placeholder PNG files in `docs/screenshots/` with your real screenshots, keeping the same filenames:

- `dashboard.png`
- `dashboard-overview.png`
- etc.

### Step 3: Commit Changes

```bash
cd topoguard  # (or other project)
git add docs/screenshots/*.png
git commit -m "Add real screenshots"
git push
```

## Screenshot Requirements

- **Format**: PNG
- **Resolution**: Minimum 1920x1080 for desktop, 1280x720 for mobile
- **File Size**: Optimize to <500KB if possible
- **Naming**: Keep exact filenames as placeholders
- **Privacy**: Redact any sensitive data

## Image Optimization

Before committing, optimize images:

```bash
# Using pngquant (install: brew install pngquant)
pngquant --quality=65-80 docs/screenshots/*.png

# Or use online tools like TinyPNG
```

## Current Placeholder Images

The placeholder images are:
- ✅ Already in git
- ✅ Already referenced in READMEs
- ✅ Ready to be replaced with real screenshots

When you add real screenshots, they'll automatically appear in the README files since the image paths are already set up!

## Quick Checklist

- [ ] Generate screenshots using capture scripts or manual methods
- [ ] Replace placeholder PNG files with real screenshots
- [ ] Optimize image file sizes
- [ ] Verify images display correctly in README
- [ ] Commit and push to GitHub

## Notes

- The placeholder images are intentionally simple so you can easily see what needs to be replaced
- All image references in README files use relative paths: `docs/screenshots/filename.png`
- GitHub will automatically display the images once real screenshots are added




