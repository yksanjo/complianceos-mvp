# Firecrawl Scraper Project

> 🕷️ A comprehensive scraping and analysis suite for Firecrawl (firecrawl.dev)
> 
> **Target**: Mendable's Firecrawl - YC S22 company converting websites to LLM-friendly Markdown

---

## 📋 Project Overview

Firecrawl is a rapidly growing API service that converts any website into clean, LLM-friendly Markdown instantly. Positioned as infrastructure for AI agents, they're perfectly riding the LLM wave with their $16/month+ pricing model.

### Why Firecrawl is Interesting

| Aspect | Details |
|--------|---------|
| **Company** | Mendable (YC S22) |
| **Product** | Firecrawl - Website-to-Markdown API |
| **Pricing** | $16/month+ |
| **Positioning** | Infrastructure for AI agents |
| **Market** | LLM developers, AI companies |

### The Genius

1. **Perfect Timing**: Launched right when every AI company needs clean training data
2. **Infrastructure Play**: Not just a tool, but infrastructure developers build on
3. **Simple API**: One endpoint → clean Markdown
4. **YC Backing**: Instant credibility with developer community

---

## 🚀 Quick Start

### Prerequisites

```bash
pip install playwright
playwright install chromium
```

### Run the Scraper

```bash
# Run full scraping suite
python firecrawl_scraper.py

# Run analysis on collected data
python firecrawl_analyzer.py
```

---

## 📁 Project Structure

```
firecrawl_scraper.py      # Main scraper - extracts all data
firecrawl_analyzer.py     # Business analysis and insights
FIRECRAWL_README.md       # This file
```

### Output Files

| File Pattern | Description |
|--------------|-------------|
| `firecrawl_data_*.json` | Raw scraped data |
| `firecrawl_report_*.md` | Markdown report |
| `firecrawl_analysis_*.json` | Business analysis |
| `firecrawl_homepage.png` | Homepage screenshot |
| `firecrawl_pricing.png` | Pricing page screenshot |
| `firecrawl_docs.png` | Documentation screenshot |

---

## 🔍 What Gets Scraped

### 1. Homepage Data
- Company tagline and description
- Key value propositions
- Feature highlights

### 2. Pricing Information
- All pricing tiers
- Feature comparisons
- Price points ($16/month+)

### 3. Documentation
- API endpoints
- Usage examples
- Integration patterns

### 4. Use Cases
- Target audience signals
- Application scenarios
- Integration patterns

---

## 📊 Analysis Features

The analyzer provides:

### Pricing Strategy Analysis
- Pricing tier structure
- Strategy classification (land & expand, good-better-best, etc.)
- Free tier detection
- Enterprise offering detection

### Positioning Analysis
- Target audience identification
- Key benefit extraction
- Market category classification
- Infrastructure vs. tool positioning

### Feature Analysis
- Feature categorization (extraction, formatting, AI/ML, etc.)
- Core capability identification
- Feature richness scoring

### Competitive Landscape
- Direct competitor identification
- Differentiation factors
- Moat analysis

---

## 💡 Business Insights

### Why Firecrawl is Winning

1. **Riding the AI Wave** 🌊
   - Every LLM company needs clean training data
   - Markdown is the lingua franca of LLMs
   - Perfect timing with the AI boom

2. **Infrastructure Positioning** 🏗️
   - Higher perceived value than tools
   - Stickier product (developers build on it)
   - Better unit economics

3. **Developer-First** 👨‍💻
   - Simple API design
   - Clear documentation
   - YC credibility

4. **Pricing Strategy** 💰
   - Free tier for acquisition
   - Usage-based scaling
   - Enterprise tier for big customers

### Market Opportunity

```
TAM: All companies building AI agents
SAM: LLM developers needing web data
SOM: Developers who prefer APIs over DIY scraping
```

---

## 🛠️ Technical Implementation

### Scraper Architecture

```python
FirecrawlScraper
├── setup()              # Browser initialization
├── scrape_homepage()    # Main page extraction
├── scrape_pricing()     # Pricing data extraction
├── scrape_docs()        # API documentation
├── scrape_use_cases()   # Use case extraction
└── generate_report()    # Report generation
```

### Data Model

```python
FirecrawlData
├── company_name         # "Firecrawl"
├── parent_company       # "Mendable"
├── yc_batch            # "S22"
├── tagline             # Main value prop
├── description         # Detailed description
├── pricing[]           # Pricing tiers
├── features[]          # Product features
├── use_cases[]         # Application scenarios
└── api_endpoints[]     # API documentation
```

---

## 🎯 Use Cases for This Scraper

1. **Competitive Intelligence**
   - Track Firecrawl's evolution
   - Monitor pricing changes
   - Feature comparison

2. **Market Research**
   - Understand positioning
   - Analyze go-to-market strategy
   - Identify trends

3. **Investment Analysis**
   - Business model validation
   - Competitive landscape mapping
   - Growth signal detection

4. **Product Inspiration**
   - Feature ideas
   - Pricing strategies
   - Positioning tactics

---

## 🔧 Customization

### Modify Scraping Behavior

```python
# Change browser mode
scraper = FirecrawlScraper(headless=True)  # Headless mode
scraper = FirecrawlScraper(headless=False) # Visible browser

# Adjust speed
scraper = FirecrawlScraper(slow_mo=200)  # Slower, more human-like
```

### Add New Data Points

Edit `firecrawl_scraper.py` and add new extraction methods:

```python
async def scrape_new_section(self):
    # Your custom extraction logic
    pass
```

---

## 📝 Example Output

### JSON Data Structure

```json
{
  "company_name": "Firecrawl",
  "parent_company": "Mendable",
  "yc_batch": "S22",
  "tagline": "Turn any website into LLM-ready data",
  "pricing": [
    {
      "name": "Hobby",
      "price": "$16/month",
      "features": ["5,000 credits", "API access", "..."]
    }
  ],
  "features": [...],
  "use_cases": [...],
  "scraped_at": "2024-01-15T10:30:00"
}
```

### Report Preview

```markdown
# Firecrawl Analysis Report

## Company Overview
- **Company**: Firecrawl
- **Parent**: Mendable
- **YC Batch**: S22

## Pricing Tiers
### Hobby
- **Price**: $16/month
- **Features**: 5,000 credits, API access, ...

## Key Features
- **Website to Markdown**: Converts any URL to clean Markdown
- **API Access**: Simple REST API
...
```

---

## 🤝 Contributing

This is a research project for competitive intelligence. Use responsibly and in accordance with Firecrawl's Terms of Service.

---

## 📚 Resources

- [Firecrawl Website](https://www.firecrawl.dev)
- [Firecrawl Docs](https://docs.firecrawl.dev)
- [Mendable](https://mendable.ai)
- [Y Combinator](https://www.ycombinator.com/companies/mendable)

---

## 📜 License

MIT License - For educational and research purposes.

---

> 💡 **Pro Tip**: Run the scraper regularly to track how Firecrawl evolves their positioning and pricing as the AI market matures.
