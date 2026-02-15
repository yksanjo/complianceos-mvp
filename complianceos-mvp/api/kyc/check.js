// Vercel Serverless Function for KYC Check
import { createKYCCase } from '../../src/lib/supabase.js';

export default async function handler(req, res) {
  // Enable CORS
  res.setHeader('Access-Control-Allow-Credentials', true);
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET,OPTIONS,PATCH,DELETE,POST,PUT');
  res.setHeader(
    'Access-Control-Allow-Headers',
    'X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version'
  );

  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  try {
    const { firstName, lastName, dateOfBirth, country, idNumber } = req.body;

    // Validate required fields
    if (!firstName || !lastName || !dateOfBirth || !country || !idNumber) {
      return res.status(400).json({
        error: 'Missing required fields',
        required: ['firstName', 'lastName', 'dateOfBirth', 'country', 'idNumber']
      });
    }

    // Simulate processing delay (replace with real KYC API calls later)
    await new Promise(resolve => setTimeout(resolve, 1500));

    // Run KYC checks
    const checks = {
      identity: await mockIdentityCheck(firstName, lastName, dateOfBirth),
      sanctions: await mockSanctionsCheck(firstName, lastName),
      pep: await mockPEPCheck(firstName, lastName),
      adverseMedia: await mockAdverseMediaCheck(firstName, lastName)
    };

    // Prepare case data
    const caseData = {
      id: `KYC-${Date.now()}`,
      name: `${firstName} ${lastName}`,
      firstName,
      lastName,
      dateOfBirth,
      country,
      idNumber,
      status: 'approved', // or 'review', 'rejected'
      riskLevel: 'low', // or 'medium', 'high'
      date: new Date().toISOString().split('T')[0]
    };

    // Save to Supabase database
    const kycResult = await createKYCCase(caseData, checks);

    return res.status(200).json({
      success: true,
      case: kycResult
    });

  } catch (error) {
    console.error('KYC Check Error:', error);
    return res.status(500).json({
      error: 'Internal server error',
      message: error.message
    });
  }
}

// Mock KYC check functions (replace with real API calls later)
async function mockIdentityCheck(firstName, lastName, dob) {
  // TODO: Integrate with Persona, Onfido, or similar
  await new Promise(resolve => setTimeout(resolve, 300));
  return 'passed';
}

async function mockSanctionsCheck(firstName, lastName) {
  // TODO: Integrate with ComplyAdvantage, OFAC API
  await new Promise(resolve => setTimeout(resolve, 400));
  return 'passed';
}

async function mockPEPCheck(firstName, lastName) {
  // TODO: Integrate with PEP database
  await new Promise(resolve => setTimeout(resolve, 350));
  // Randomly flag some for demo purposes
  return Math.random() > 0.8 ? 'flagged' : 'passed';
}

async function mockAdverseMediaCheck(firstName, lastName) {
  // TODO: Integrate with news/media monitoring APIs
  await new Promise(resolve => setTimeout(resolve, 450));
  return 'passed';
}
