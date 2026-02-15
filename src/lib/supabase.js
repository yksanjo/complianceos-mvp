// Supabase client for VerifyFlow
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || '';
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY || '';

// Create Supabase client
export const supabase = createClient(supabaseUrl, supabaseAnonKey);

// Helper function to get KYC cases
export async function getCases() {
  const { data, error } = await supabase
    .from('kyc_cases')
    .select(`
      *,
      kyc_checks (
        check_type,
        status
      )
    `)
    .order('created_at', { ascending: false });

  if (error) throw error;

  // Transform data to match frontend format
  return data.map(caseData => ({
    id: caseData.id,
    name: caseData.name,
    status: caseData.status,
    riskLevel: caseData.risk_level,
    date: caseData.date,
    country: caseData.country,
    checks: caseData.kyc_checks.reduce((acc, check) => {
      acc[check.check_type] = check.status;
      return acc;
    }, {})
  }));
}

// Helper function to get a specific case
export async function getCase(id) {
  const { data, error } = await supabase
    .from('kyc_cases')
    .select(`
      *,
      kyc_checks (
        check_type,
        status,
        details
      )
    `)
    .eq('id', id)
    .single();

  if (error) throw error;

  // Transform to match frontend format
  return {
    id: data.id,
    name: data.name,
    status: data.status,
    riskLevel: data.risk_level,
    date: data.date,
    country: data.country,
    checks: data.kyc_checks.reduce((acc, check) => {
      acc[check.check_type] = check.status;
      return acc;
    }, {})
  };
}

// Helper function to create a new KYC case
export async function createKYCCase(caseData, checks) {
  // Insert case
  const { data: newCase, error: caseError } = await supabase
    .from('kyc_cases')
    .insert([{
      id: caseData.id,
      name: caseData.name,
      first_name: caseData.firstName,
      last_name: caseData.lastName,
      date_of_birth: caseData.dateOfBirth,
      country: caseData.country,
      id_number: caseData.idNumber,
      status: caseData.status,
      risk_level: caseData.riskLevel,
      date: caseData.date
    }])
    .select()
    .single();

  if (caseError) throw caseError;

  // Insert checks
  const checkRecords = Object.entries(checks).map(([checkType, status]) => ({
    case_id: newCase.id,
    check_type: checkType,
    status: status
  }));

  const { error: checksError } = await supabase
    .from('kyc_checks')
    .insert(checkRecords);

  if (checksError) throw checksError;

  return {
    id: newCase.id,
    name: newCase.name,
    status: newCase.status,
    riskLevel: newCase.risk_level,
    date: newCase.date,
    country: newCase.country,
    checks: checks
  };
}

// Helper function to get stats
export async function getStats() {
  // Get all cases
  const { data: cases, error } = await supabase
    .from('kyc_cases')
    .select('status, risk_level, date');

  if (error) throw error;

  // Calculate stats
  const totalChecks = cases.length;
  const approved = cases.filter(c => c.status === 'approved').length;
  const pending = cases.filter(c => c.status === 'pending' || c.status === 'review').length;
  const rejected = cases.filter(c => c.status === 'rejected').length;
  const approvalRate = totalChecks > 0 ? (approved / totalChecks * 100).toFixed(1) : 0;

  const riskDistribution = {
    low: cases.filter(c => c.risk_level === 'low').length,
    medium: cases.filter(c => c.risk_level === 'medium').length,
    high: cases.filter(c => c.risk_level === 'high').length
  };

  return {
    totalChecks,
    approved,
    pending,
    rejected,
    approvalRate: parseFloat(approvalRate),
    totalChecksChange: 12.5, // TODO: Calculate from historical data
    approvalRateChange: 2.1, // TODO: Calculate from historical data
    avgProcessingTime: 2.4,
    riskDistribution,
    weeklyData: [65, 72, 68, 75, 82, 78, totalChecks], // TODO: Calculate from actual data
    riskData: [
      { label: 'Low', value: riskDistribution.low, color: 'bg-blue-500', percentage: (riskDistribution.low / totalChecks * 100).toFixed(1) },
      { label: 'Medium', value: riskDistribution.medium, color: 'bg-orange-500', percentage: (riskDistribution.medium / totalChecks * 100).toFixed(1) },
      { label: 'High', value: riskDistribution.high, color: 'bg-red-500', percentage: (riskDistribution.high / totalChecks * 100).toFixed(1) }
    ]
  };
}
