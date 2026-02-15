# VerifyFlow API Documentation

## Backend Structure

VerifyFlow uses **Vercel Serverless Functions** for the backend API.

### API Endpoints

#### 1. Run KYC Check
```
POST /api/kyc/check
```

**Request Body:**
```json
{
  "firstName": "John",
  "lastName": "Doe",
  "dateOfBirth": "1990-01-01",
  "country": "United States",
  "idNumber": "123-45-6789"
}
```

**Response:**
```json
{
  "success": true,
  "case": {
    "id": "KYC-1234567890",
    "name": "John Doe",
    "status": "approved",
    "riskLevel": "low",
    "date": "2026-01-02",
    "country": "United States",
    "checks": {
      "identity": "passed",
      "sanctions": "passed",
      "pep": "passed",
      "adverseMedia": "passed"
    }
  }
}
```

#### 2. Get All Cases
```
GET /api/kyc/cases
```

**Response:**
```json
{
  "success": true,
  "cases": [...],
  "total": 3
}
```

#### 3. Get Specific Case
```
GET /api/kyc/case/{id}
```

**Response:**
```json
{
  "success": true,
  "case": {...}
}
```

#### 4. Get Dashboard Stats
```
GET /api/stats
```

**Response:**
```json
{
  "success": true,
  "stats": {
    "totalChecks": 847,
    "approved": 782,
    "pending": 12,
    "rejected": 53,
    "approvalRate": 92.3,
    ...
  }
}
```

## Current Status

✅ **Phase 1 Complete:** Mock API with Vercel Serverless Functions
- All endpoints working with mock data
- CORS enabled
- Error handling implemented
- Ready to deploy

## Next Steps

### Phase 2: Database Integration (Supabase)
1. Create Supabase project
2. Set up database schema:
   - `kyc_cases` table
   - `users` table (for auth later)
   - `audit_logs` table
3. Replace mock data with real database queries
4. Add environment variables to Vercel

### Phase 3: Real KYC API Integration
1. Sign up for KYC services:
   - Persona (https://withpersona.com) - Identity verification
   - ComplyAdvantage (https://complyadvantage.com) - Sanctions/PEP
   - Or use aggregator like Unit21
2. Add API keys to environment variables
3. Replace mock check functions with real API calls
4. Add webhook handlers for async results

### Phase 4: Authentication
1. Add user registration/login
2. JWT token management
3. API key management UI
4. Protected routes

## Testing Locally

```bash
# Install dependencies
npm install

# Run development server
npm run dev

# Frontend: http://localhost:5173
# API: http://localhost:5173/api/*
```

## Deployment

```bash
# Deploy to Vercel
vercel

# Or push to GitHub (if connected to Vercel)
git add .
git commit -m "Add backend API"
git push
```

## File Structure

```
complianceos-mvp/
├── api/                          # Vercel Serverless Functions
│   ├── stats.js                 # Dashboard stats
│   └── kyc/
│       ├── check.js             # POST - Run KYC check
│       ├── cases.js             # GET - List all cases
│       └── case/
│           └── [id].js          # GET - Get specific case
├── src/
│   ├── lib/
│   │   └── api.js               # API client utility
│   ├── App.jsx                  # Main app (now using real APIs)
│   └── ...
└── .env.example                 # Environment variables template
```

## Production Checklist

- [ ] Deploy to Vercel
- [ ] Add Supabase database
- [ ] Integrate real KYC APIs
- [ ] Add authentication
- [ ] Set up monitoring
- [ ] Add rate limiting
- [ ] Configure custom domain
- [ ] Add error tracking (Sentry)

---

**Status:** Ready for deployment! 🚀
