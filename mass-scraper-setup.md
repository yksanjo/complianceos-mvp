# Mass LinkedIn Scraper Setup Guide

## Quick Start Commands

### 1. Create Project Structure
```bash
# Create project directory
mkdir linkedin-mass-scraper
cd linkedin-mass-scraper

# Initialize npm project
npm init -y

# Install core dependencies
npm install puppeteer cheerio bullmq ioredis axios pg dotenv winston csv-writer

# Install dev dependencies
npm install -D @types/node typescript nodemon jest

# Create directory structure
mkdir -p src/{scrapers,workers,utils,db,config,scripts}
mkdir -p data/{nyc,sf,exports}
mkdir -p logs scripts
```

### 2. Create Package.json
```json
{
  "name": "linkedin-mass-scraper",
  "version": "1.0.0",
  "description": "Mass LinkedIn profile scraper for NYC and SF",
  "main": "src/index.js",
  "scripts": {
    "start": "node src/index.js",
    "dev": "nodemon src/index.js",
    "scrape:nyc": "node src/scripts/scrape-nyc.js",
    "scrape:sf": "node src/scripts/scrape-sf.js",
    "worker": "node src/workers/main.js",
    "test": "jest"
  },
  "dependencies": {
    "puppeteer": "^21.7.0",
    "cheerio": "^1.0.0-rc.12",
    "bullmq": "^5.2.0",
    "ioredis": "^5.3.2",
    "axios": "^1.6.2",
    "pg": "^8.11.3",
    "dotenv": "^16.3.1",
    "winston": "^3.11.0",
    "csv-writer": "^1.6.0"
  },
  "devDependencies": {
    "@types/node": "^20.10.0",
    "typescript": "^5.3.0",
    "nodemon": "^3.0.1",
    "jest": "^29.7.0"
  },
  "keywords": ["linkedin", "scraper", "nyc", "san-francisco"],
  "author": "Your Name",
  "license": "MIT"
}
```

### 3. Create Environment Configuration
```bash
# .env.example
DATABASE_URL=postgresql://user:password@localhost:5432/linkedin_scraper
REDIS_URL=redis://localhost:6379
LINKEDIN_EMAIL=your-email@example.com
LINKEDIN_PASSWORD=your-password
PROXY_LIST=http://proxy1:port,http://proxy2:port
REQUESTS_PER_MINUTE=20
DELAY_BETWEEN_REQUESTS=3000
TARGET_CITIES=New York City,San Francisco
DATA_DIR=./data
LOGS_DIR=./logs
```

### 4. Create City Configuration
```javascript
// src/config/cities.js
module.exports = {
  NYC: {
    name: 'New York City',
    aliases: ['NYC', 'New York', 'Manhattan', 'Brooklyn', 'Queens', 'Bronx', 'Staten Island'],
    population: 8500000,
    estimatedLinkedInUsers: 4000000,
    
    topCompanies: [
      'Goldman Sachs', 'JPMorgan Chase', 'Morgan Stanley', 'Citigroup',
      'Google NYC', 'Facebook NYC', 'Amazon NYC', 'Microsoft NYC',
      'Bloomberg', 'Verizon', 'AT&T', 'IBM', 'Accenture',
      'Deloitte', 'PwC', 'EY', 'KPMG',
      'NYU', 'Columbia University', 'CUNY', 'Fordham University'
    ],
    
    industries: [
      'Finance', 'Banking', 'Investment', 'Media', 'Advertising',
      'Marketing', 'Fashion', 'Retail', 'Real Estate', 'Law',
      'Healthcare', 'Education', 'Technology', 'Startups'
    ],
    
    jobTitles: [
      'Analyst', 'Associate', 'Vice President', 'Director',
      'Manager', 'Software Engineer', 'Data Scientist',
      'Product Manager', 'Marketing Manager', 'Sales Director'
    ]
  },
  
  SF: {
    name: 'San Francisco',
    aliases: ['SF', 'San Francisco', 'Bay Area', 'Silicon Valley', 'SF Bay Area'],
    population: 875000,
    estimatedLinkedInUsers: 500000,
    
    topCompanies: [
      'Google', 'Facebook', 'Apple', 'Twitter', 'Uber', 'Airbnb',
      'Salesforce', 'Oracle', 'Adobe', 'Intel', 'Cisco',
      'Netflix', 'Tesla', 'Slack', 'Dropbox', 'Square',
      'Stanford University', 'UC Berkeley', 'San Francisco State'
    ],
    
    industries: [
      'Technology', 'Software', 'SaaS', 'Cloud Computing',
      'Artificial Intelligence', 'Machine Learning', 'Biotech',
      'Venture Capital', 'Startups', 'Fintech', 'Clean Energy'
    ],
    
    jobTitles: [
      'Software Engineer', 'Product Manager', 'Data Scientist',
      'Machine Learning Engineer', 'DevOps Engineer', 'UX Designer',
      'Growth Hacker', 'VC Associate', 'Startup Founder', 'CTO'
    ]
  }
};
```

### 5. Create Main Scraper Script
```javascript
// src/index.js
require('dotenv').config();
const { Queue, Worker } = require('bullmq');
const Redis = require('ioredis');
const LinkedInScraper = require('./scrapers/linkedin-scraper');
const logger = require('./utils/logger');
const cities = require('./config/cities');

class MassLinkedInScraper {
  constructor() {
    this.redis = new Redis(process.env.REDIS_URL);
    this.scrapeQueue = new Queue('linkedin-scrape', { connection: this.redis });
    this.scrapers = [];
    this.results = {
      NYC: { total: 0, companies: {} },
      SF: { total: 0, companies: {} }
    };
  }

  async initialize() {
    logger.info('Initializing Mass LinkedIn Scraper...');
    
    // Initialize scrapers for each city
    for (const [cityCode, cityConfig] of Object.entries(cities)) {
      const scraper = new LinkedInScraper(cityCode);
      await scraper.initialize();
      this.scrapers.push(scraper);
      logger.info(`Initialized scraper for ${cityConfig.name}`);
    }
  }

  async generateSearchJobs() {
    logger.info('Generating search jobs...');
    
    for (const [cityCode, cityConfig] of Object.entries(cities)) {
      // Generate search queries for each company
      for (const company of cityConfig.topCompanies.slice(0, 10)) { // Start with top 10
        const searchUrl = this.buildSearchUrl(company, cityConfig.name);
        
        await this.scrapeQueue.add('scrape-company', {
          city: cityCode,
          company: company,
          searchUrl: searchUrl,
          priority: 1
        });
        
        logger.debug(`Added job for ${company} in ${cityConfig.name}`);
      }
    }
    
    logger.info(`Generated ${await this.scrapeQueue.count()} jobs`);
  }

  buildSearchUrl(company, location) {
    // Build LinkedIn search URL
    const encodedCompany = encodeURIComponent(company);
    const encodedLocation = encodeURIComponent(location);
    
    return `https://www.linkedin.com/search/results/people/?company=${encodedCompany}&location=${encodedLocation}&origin=FACETED_SEARCH`;
  }

  async startWorkers(numWorkers = 5) {
    logger.info(`Starting ${numWorkers} workers...`);
    
    for (let i = 0; i < numWorkers; i++) {
      const worker = new Worker('linkedin-scrape', async job => {
        return await this.processJob(job);
      }, { connection: this.redis, concurrency: 1 });
      
      worker.on('completed', job => {
        logger.info(`Job ${job.id} completed for ${job.data.company}`);
        this.updateResults(job.data.city, job.data.company, job.returnvalue);
      });
      
      worker.on('failed', (job, err) => {
        logger.error(`Job ${job.id} failed: ${err.message}`);
      });
    }
  }

  async processJob(job) {
    const { city, company, searchUrl } = job.data;
    const scraper = this.scrapers.find(s => s.city === city);
    
    if (!scraper) {
      throw new Error(`No scraper found for city: ${city}`);
    }
    
    logger.info(`Processing ${company} in ${cities[city].name}`);
    
    try {
      // Scrape profiles
      const profiles = await scraper.scrapeCompany(searchUrl, company);
      logger.info(`Found ${profiles.length} profiles for ${company}`);
      
      // Save to database
      await this.saveProfiles(profiles, city);
      
      return { company, count: profiles.length };
    } catch (error) {
      logger.error(`Error scraping ${company}: ${error.message}`);
      throw error;
    }
  }

  async saveProfiles(profiles, city) {
    // Implement database saving logic
    // This would connect to PostgreSQL and insert profiles
    console.log(`Would save ${profiles.length} profiles for ${city}`);
    
    // For now, save to JSON file
    const fs = require('fs').promises;
    const filename = `./data/${city.toLowerCase()}/${Date.now()}-profiles.json`;
    await fs.writeFile(filename, JSON.stringify(profiles, null, 2));
    
    return profiles.length;
  }

  updateResults(city, company, result) {
    this.results[city].total += result.count;
    this.results[city].companies[company] = result.count;
    
    logger.info(`Results update - ${cities[city].name}: ${this.results[city].total} total profiles`);
  }

  async run() {
    try {
      await this.initialize();
      await this.generateSearchJobs();
      await this.startWorkers(3); // Start with 3 workers
      
      // Monitor progress
      setInterval(() => {
        this.logProgress();
      }, 30000); // Every 30 seconds
      
    } catch (error) {
      logger.error(`Fatal error: ${error.message}`);
      process.exit(1);
    }
  }

  logProgress() {
    console.log('\n=== Scraping Progress ===');
    for (const [city, data] of Object.entries(this.results)) {
      console.log(`${cities[city].name}: ${data.total} profiles`);
      console.log(`Top companies:`, Object.entries(data.companies)
        .sort((a, b) => b[1] - a[1])
        .slice(0, 5)
        .map(([company, count]) => `${company}: ${count}`)
        .join(', '));
    }
    console.log('========================\n');
  }
}

// Run the scraper
if (require.main === module) {
  const scraper = new MassLinkedInScraper();
  scraper.run().catch(console.error);
}

module.exports = MassLinkedInScraper;
```

### 6. Run the Scraper
```bash
# Copy environment file
cp .env.example .env
# Edit .env with your credentials

# Start Redis (required for job queue)
docker run -d -p 6379:6379 redis

# Start PostgreSQL (optional, can use SQLite for testing)
docker run -d -p 5432:5432 -e POSTGRES_PASSWORD=password postgres

# Run the scraper
npm start

# Or run specific city
npm run scrape:nyc
npm run scrape:sf
```

## Estimated Timeline

### Day 1-2: Setup & Testing
- Set up infrastructure
- Test with 1-2 companies
- Verify data collection works
- Fix any issues

### Day 3-7: Initial Scraping (10K profiles)
- Scrape top 50 companies in each city
- Collect ~10,000 profiles
- Validate data quality
- Optimize performance

### Week 2: Scale Up (50K profiles)
- Add more companies and industries
- Implement proxy rotation
- Add error recovery
- Reach ~50,000 profiles

### Week 3-4: Full Scale (200K+ profiles)
- Expand to all target companies
- Add school-based scraping
- Implement network expansion
- Target 200,000+ profiles

## Cost Estimates

### Infrastructure (Monthly)
- **Servers**: $200-400 (2-4 VPS instances)
- **Proxies**: $300-600 (residential proxies)
- **Database**: $100-200 (managed PostgreSQL)
- **Storage**: $50-100 (cloud storage)
- **Total**: $650-1,300/month

### One-Time Setup
- **Development Time**: 40-80 hours
- **Testing & Optimization**: 20-40 hours
- **Total Development Cost**: $5,000-15,000 (if hiring)

## Success Metrics

### Week 1 Success
- [ ] Infrastructure running
- [ ] First 1,000 profiles collected
- [ ] Data validation passing
- [ ] No LinkedIn blocks detected

### Month 1 Success
- [ ] 50,000+ profiles collected
- [ ] 95% data accuracy
- [ ] Automated pipeline running
- [ ] Cost under $1,000

### Month 3 Success
- [ ] 500,000+ profiles collected
- [ ] <1% error rate
- [ ] Real-time monitoring
- [ ] Ready for production use

## Important Notes

1. **Legal Compliance**: Always respect LinkedIn's terms of service
2. **Rate Limiting**: Be conservative to avoid blocks
3. **Data Privacy**: Only collect publicly available information
4. **Ethical Use**: Use data responsibly and with consent
5. **Monitoring**: Continuously monitor for blocks and errors

This setup will give you a scalable foundation for mass LinkedIn scraping. Start small, test thoroughly, and scale up gradually.