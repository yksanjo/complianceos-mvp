# Quick Start Guide - GitHub Fork Mapper

## ⚡ 5-Minute Setup

### Step 1: Verify Python Installation
```bash
python3 --version
# Should show Python 3.7 or higher
```

### Step 2: Install Required Package
```bash
pip install requests
```

### Step 3: Test API Access
```bash
python3 test_github_scraper.py
```
✅ You should see Open Claw repository info and recent forks

### Step 4: Start Scraping
```bash
python3 github_fork_scraper.py
```

### Step 5: Enter GitHub Token (Optional)
When prompted, you can:
- Press Enter to continue without token (60 requests/hour)
- Enter your GitHub token for faster scraping (5,000 requests/hour)

## 🎯 What Happens Next

The scraper will:
1. Fetch all forks from openclaw/openclaw (27,639+ forks)
2. Analyze each user for AI/agent keywords
3. Save progress every 5 users
4. Generate final reports

## 📊 Expected Output Files

During scraping, you'll see:
```
progress_5.json      # First 5 users analyzed
progress_10.json     # First 10 users analyzed
...                  # Progress continues
github_fork_analysis_TIMESTAMP.json  # Complete results
github_fork_analysis_TIMESTAMP.csv   # CSV version
github_fork_summary_TIMESTAMP.json   # Summary report
```

## ⏱️ Time Estimates

**Without GitHub token:**
- ~1 request/second
- ~27,639 seconds = ~7.7 hours
- Progress saves every ~5 minutes

**With GitHub token:**
- ~5-10 requests/second
- ~1-2 hours total
- Much faster completion

## 🔄 Monitoring Progress

Check progress while scraping:
```bash
# Count analyzed users
tail -n 5 progress_*.json 2>/dev/null | wc -l

# Check current rate limits
curl -s https://api.github.com/rate_limit | python3 -m json.tool
```

## 🛑 Stopping and Resuming

The scraper saves progress automatically. To stop:
- Press `Ctrl+C`
- Progress is saved to the latest `progress_*.json` file

To resume (manual process for now):
1. Note the last progress file number
2. Modify the script to start from that point
3. Run again

## 📈 First Results Preview

After just 5-10 users, you'll already see:
- User profiles with AI/agent keywords
- Initial statistics
- Sample agent users

## 🚨 Common Issues

### Rate Limit Errors
If you see `403 Forbidden`:
- Wait 1 hour for limits to reset
- Consider getting a GitHub token
- Reduce request rate in code

### Connection Errors
- Check internet connection
- Verify GitHub status: https://www.githubstatus.com/

### Import Errors
```bash
# If 'requests' not found
pip install requests --user
```

## 🎮 Advanced: Run with Token Pre-set

Create a `.env` file (optional):
```bash
echo "GITHUB_TOKEN=your_token_here" > .env
```

Then modify the script to read from `.env`:
```python
import os
github_token = os.getenv('GITHUB_TOKEN')
```

## 📱 Quick Commands Cheat Sheet

```bash
# Test everything works
python3 test_github_scraper.py

# Start scraping (will prompt for token)
python3 github_fork_scraper.py

# Check generated files
ls -la *.json *.csv

# View summary of latest results
tail -n 50 github_fork_summary_*.json

# Count total users analyzed
grep -c '"login"' github_fork_analysis_*.json
```

## 🎯 Success Checklist

- [ ] `test_github_scraper.py` runs without errors
- [ ] Can see Open Claw repository info
- [ ] `github_fork_scraper.py` starts successfully
- [ ] Progress files are being created
- [ ] No rate limit errors in first 5 minutes

## 🆘 Need Help?

1. **Rate limits exhausted**: Wait 1 hour or get a token
2. **No internet**: Check connection
3. **Python errors**: Verify Python 3.7+ and `requests` installed
4. **GitHub down**: Check https://www.githubstatus.com/

## 🚀 Ready to Scale?

For full 27,639+ fork analysis:
1. Get a GitHub token (highly recommended)
2. Run overnight or during off-hours
3. Monitor progress with generated files
4. Celebrate when complete! 🎉

---

**Next Step**: Run `python3 github_fork_scraper.py` and watch the magic happen! ✨