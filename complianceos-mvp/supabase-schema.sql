-- VerifyFlow Database Schema for Supabase

-- KYC Cases Table
CREATE TABLE IF NOT EXISTS kyc_cases (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  first_name TEXT,
  last_name TEXT,
  date_of_birth DATE,
  country TEXT NOT NULL,
  id_number TEXT,
  status TEXT NOT NULL CHECK (status IN ('approved', 'review', 'rejected', 'pending')),
  risk_level TEXT NOT NULL CHECK (risk_level IN ('low', 'medium', 'high')),
  date DATE NOT NULL DEFAULT CURRENT_DATE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- KYC Checks Table (stores individual check results)
CREATE TABLE IF NOT EXISTS kyc_checks (
  id SERIAL PRIMARY KEY,
  case_id TEXT REFERENCES kyc_cases(id) ON DELETE CASCADE,
  check_type TEXT NOT NULL CHECK (check_type IN ('identity', 'sanctions', 'pep', 'adverseMedia')),
  status TEXT NOT NULL CHECK (status IN ('passed', 'flagged', 'failed', 'pending')),
  details JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_kyc_cases_status ON kyc_cases(status);
CREATE INDEX IF NOT EXISTS idx_kyc_cases_date ON kyc_cases(date);
CREATE INDEX IF NOT EXISTS idx_kyc_cases_risk_level ON kyc_cases(risk_level);
CREATE INDEX IF NOT EXISTS idx_kyc_checks_case_id ON kyc_checks(case_id);

-- Enable Row Level Security (RLS)
ALTER TABLE kyc_cases ENABLE ROW LEVEL SECURITY;
ALTER TABLE kyc_checks ENABLE ROW LEVEL SECURITY;

-- Create policies (allow all operations for now - add authentication later)
CREATE POLICY "Allow all operations on kyc_cases" ON kyc_cases
  FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Allow all operations on kyc_checks" ON kyc_checks
  FOR ALL USING (true) WITH CHECK (true);

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = TIMEZONE('utc', NOW());
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to automatically update updated_at
CREATE TRIGGER update_kyc_cases_updated_at BEFORE UPDATE ON kyc_cases
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert some sample data for testing
INSERT INTO kyc_cases (id, name, first_name, last_name, country, status, risk_level, date)
VALUES
  ('KYC-2025-001', 'Sarah Chen', 'Sarah', 'Chen', 'United States', 'approved', 'low', '2025-12-27'),
  ('KYC-2025-002', 'Michael Rodriguez', 'Michael', 'Rodriguez', 'Mexico', 'review', 'medium', '2025-12-27'),
  ('KYC-2025-003', 'James Wilson', 'James', 'Wilson', 'United Kingdom', 'approved', 'low', '2025-12-26')
ON CONFLICT (id) DO NOTHING;

-- Insert sample check results
INSERT INTO kyc_checks (case_id, check_type, status)
VALUES
  ('KYC-2025-001', 'identity', 'passed'),
  ('KYC-2025-001', 'sanctions', 'passed'),
  ('KYC-2025-001', 'pep', 'passed'),
  ('KYC-2025-001', 'adverseMedia', 'passed'),
  ('KYC-2025-002', 'identity', 'passed'),
  ('KYC-2025-002', 'sanctions', 'passed'),
  ('KYC-2025-002', 'pep', 'flagged'),
  ('KYC-2025-002', 'adverseMedia', 'passed'),
  ('KYC-2025-003', 'identity', 'passed'),
  ('KYC-2025-003', 'sanctions', 'passed'),
  ('KYC-2025-003', 'pep', 'passed'),
  ('KYC-2025-003', 'adverseMedia', 'passed')
ON CONFLICT DO NOTHING;
