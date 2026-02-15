# MCP Curator - Deployment Guide

## Overview

MCP Curator is an intelligent routing service that helps AI developers save 30% on MCP server costs by recommending the optimal server for each task.

## Architecture

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Frontend      │────▶│   API Gateway   │────▶│   Database      │
│   (Next.js)     │     │   (Express)     │     │   (Supabase)    │
│   Vercel        │     │   Vercel/Heroku │     │                 │
└─────────────────┘     └─────────────────┘     └─────────────────┘
         │                        │                        │
         │                        │                        │
         ▼                        ▼                        ▼
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Users         │     │   MCP Discovery │     │   Cost Tracking │
│   Dashboard     │     │   Integration   │     │   & Analytics   │
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

## Deployment Steps

### Step 1: Database Setup (Supabase)

1. **Create a new Supabase project** or use existing MCP Discovery project
2. **Run the schema migrations**:
   ```bash
   # Connect to Supabase SQL Editor
   # Run mcp-discovery/src/db/schema.sql (if not already done)
   # Run mcp-discovery/src/db/auth-schema.sql (if not already done)
   # Run mcp-discovery/src/db/mcp-curator-schema.sql (new)
   ```

3. **Add cost data to existing MCP servers**:
   ```sql
   -- Update some servers with sample cost data
   UPDATE mcp_servers SET 
     cost_per_call = CASE 
       WHEN name ILIKE '%github%' THEN 0.0000
       WHEN name ILIKE '%postgres%' THEN 0.0025
       WHEN name ILIKE '%openai%' THEN 0.0150
       WHEN name ILIKE '%stripe%' THEN 0.0300
       ELSE 0.0010
     END,
     avg_latency_ms = CASE 
       WHEN name ILIKE '%filesystem%' THEN 50
       WHEN name ILIKE '%postgres%' THEN 150
       WHEN name ILIKE '%github%' THEN 300
       WHEN name ILIKE '%openai%' THEN 800
       ELSE 500
     END,
     reliability_score = 0.95 + (RANDOM() * 0.04),
     tags = ARRAY[
       CASE WHEN name ILIKE '%github%' THEN 'github' END,
       CASE WHEN name ILIKE '%postgres%' THEN 'database' END,
       CASE WHEN name ILIKE '%openai%' THEN 'ai' END,
       CASE WHEN name ILIKE '%stripe%' THEN 'payment' END,
       CASE WHEN name ILIKE '%filesystem%' THEN 'filesystem' END
     ]
   WHERE cost_per_call IS NULL;
   ```

### Step 2: Backend API Deployment

#### Option A: Deploy with existing MCP Discovery (Recommended)
1. **Add the new API route to existing MCP Discovery**:
   ```bash
   cd mcp-discovery
   # Copy the mcp-curator.ts file to src/api/
   # Update server.ts to include the new router
   ```

2. **Update server.ts**:
   ```typescript
   // Add this import
   import mcpCuratorRouter from './api/mcp-curator.js';
   
   // Add this route
   app.use('/api/v1/curator', mcpCuratorRouter);
   ```

3. **Deploy to Vercel**:
   ```bash
   vercel --prod
   ```

#### Option B: Deploy as standalone service
1. **Create new project**:
   ```bash
   mkdir mcp-curator-api
   cd mcp-curator-api
   npm init -y
   npm install express cors dotenv
   # Copy the mcp-curator.ts file
   # Create server.ts with Express setup
   ```

2. **Deploy to Vercel/Heroku**:
   ```bash
   # Vercel
   vercel
   
   # Heroku
   heroku create mcp-curator-api
   git push heroku main
   ```

### Step 3: Frontend Dashboard Deployment

1. **Set up the Next.js dashboard**:
   ```bash
   cd mcp-curator-dashboard
   npm install
   ```

2. **Configure environment variables**:
   ```bash
   # Create .env.local
   MCP_CURATOR_API=https://your-api-url.com
   NEXT_PUBLIC_APP_URL=https://mcp-curator.vercel.app
   ```

3. **Deploy to Vercel**:
   ```bash
   vercel --prod
   ```

### Step 4: Configure API Gateway (Optional)

If deploying separately, set up CORS and rate limiting:

```typescript
// In your API server
import cors from 'cors';
import rateLimit from 'express-rate-limit';

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limit each IP to 100 requests per windowMs
});

app.use(cors());
app.use('/api/', limiter);
```

## Environment Variables

### Backend API (.env)
```bash
# Supabase
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key

# API Configuration
PORT=3001
NODE_ENV=production
API_BASE_URL=https://mcp-curator-api.vercel.app

# Rate limiting
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100
```

### Frontend Dashboard (.env.local)
```bash
# API Configuration
NEXT_PUBLIC_API_URL=https://mcp-curator-api.vercel.app
NEXT_PUBLIC_APP_URL=https://mcp-curator.vercel.app

# Feature flags
NEXT_PUBLIC_ENABLE_PAYMENTS=false
NEXT_PUBLIC_ENABLE_TEAMS=false
```

## Testing the Deployment

### 1. Test Database Connection
```bash
curl "https://your-project.supabase.co/rest/v1/mcp_servers?limit=1" \
  -H "apikey: your-anon-key"
```

### 2. Test API Endpoints
```bash
# Health check
curl https://mcp-curator-api.vercel.app/api/v1/curator/health

# Route a task (public endpoint)
curl -X POST https://mcp-curator-api.vercel.app/api/v1/curator/recommend \
  -H "Content-Type: application/json" \
  -d '{"task": "query postgres database"}'

# Get API key (through dashboard or direct)
curl -X POST https://mcp-curator-api.vercel.app/api/v1/auth/key \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "name": "Test User"}'
```

### 3. Test Frontend
1. Visit your deployed dashboard URL
2. Try the demo task router
3. Sign up for an API key
4. Test the full flow with your API key

## Monitoring & Maintenance

### 1. Database Maintenance
```sql
-- Daily: Update costs from actual usage
SELECT update_server_costs_from_usage();

-- Monthly: Clean up old data
DELETE FROM usage_logs WHERE timestamp < NOW() - INTERVAL '90 days';
DELETE FROM routing_decisions WHERE created_at < NOW() - INTERVAL '90 days';
```

### 2. Logging Setup
```typescript
// Add logging middleware
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} ${req.method} ${req.url}`);
  next();
});
```

### 3. Error Tracking
- **Sentry** for error monitoring
- **Logtail** or **Papertrail** for logs
- **UptimeRobot** for uptime monitoring

## Scaling Considerations

### Small Scale (< 1000 users)
- Single Vercel deployment
- Supabase free tier
- Basic monitoring

### Medium Scale (1000-10,000 users)
- Separate API and frontend deployments
- Supabase Pro tier
- Redis caching for routing decisions
- CDN for static assets

### Large Scale (> 10,000 users)
- Microservices architecture
- Database read replicas
- Load balancing
- Advanced caching strategy
- Dedicated monitoring stack

## Security Considerations

### 1. API Key Security
- Store API keys hashed in database
- Implement key rotation
- Rate limiting per key
- Monitor for suspicious activity

### 2. Database Security
- Row Level Security (RLS) in Supabase
- Regular backups
- Access logging

### 3. Application Security
- Input validation
- CORS configuration
- HTTPS enforcement
- Regular dependency updates

## Cost Estimation

### Monthly Costs (Small Scale)
- **Vercel Pro**: $20/month
- **Supabase Pro**: $25/month  
- **Domain**: $12/year
- **Monitoring**: $0-29/month
- **Total**: ~$50-75/month

### Break-even Analysis
- Need 2-3 Pro users ($49/month) to break even
- At 10 Pro users: $490 MRR - $75 costs = $415 profit
- At 50 Pro users: $2,450 MRR - $150 costs = $2,300 profit

## Quick Start Script

Create `deploy.sh`:
```bash
#!/bin/bash

echo "🚀 Deploying MCP Curator..."

# 1. Database setup
echo "Setting up database..."
# Run SQL migrations via Supabase CLI or API

# 2. Backend deployment
echo "Deploying backend API..."
cd mcp-discovery
vercel --prod --yes

# 3. Frontend deployment  
echo "Deploying frontend dashboard..."
cd ../mcp-curator-dashboard
vercel --prod --yes

echo "✅ Deployment complete!"
echo "Frontend: https://mcp-curator.vercel.app"
echo "API: https://mcp-discovery.vercel.app/api/v1/curator"
```

## Troubleshooting

### Common Issues:

1. **Database connection errors**
   - Check Supabase credentials
   - Verify network access
   - Check if tables exist

2. **CORS errors**
   - Configure CORS properly
   - Check allowed origins
   - Test with curl first

3. **Rate limiting issues**
   - Check API key limits
   - Monitor usage logs
   - Consider upgrading tier

4. **Performance issues**
   - Add database indexes
   - Implement caching
   - Optimize queries

### Getting Help:
- Check logs in Vercel dashboard
- Monitor Supabase logs
- Use API testing tools (Postman, curl)
- Join AI developer communities for support

## Next Steps After Deployment

1. **Add cost data** for more MCP servers
2. **Implement Stripe** for payments
3. **Add email notifications**
4. **Create documentation** site
5. **Set up analytics** (Google Analytics, Mixpanel)
6. **Launch marketing** campaign
7. **Gather user feedback** and iterate

## Launch Checklist

- [ ] Database schema deployed
- [ ] Cost data added to servers
- [ ] Backend API deployed
- [ ] Frontend dashboard deployed
- [ ] Domain configured
- [ ] SSL certificates working
- [ ] Basic monitoring set up
- [ ] Error tracking configured
- [ ] Backup strategy in place
- [ ] Documentation written
- [ ] Marketing materials ready
- [ ] Launch announcement prepared

## Ready to Launch?

Once everything is deployed and tested, you can:
1. Post on Hacker News ("Show HN")
2. Share on Twitter/X with AI communities
3. Email your existing MCP Discovery users
4. Join relevant Discord communities
5. Start collecting feedback and iterating

Good luck! 🚀