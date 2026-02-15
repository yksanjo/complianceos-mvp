// API Client for VerifyFlow

const API_BASE_URL = import.meta.env.VITE_API_URL || '/api';

class APIClient {
  async request(endpoint, options = {}) {
    const url = `${API_BASE_URL}${endpoint}`;

    const config = {
      headers: {
        'Content-Type': 'application/json',
        ...options.headers,
      },
      ...options,
    };

    try {
      const response = await fetch(url, config);
      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.error || 'API request failed');
      }

      return data;
    } catch (error) {
      console.error('API Error:', error);
      throw error;
    }
  }

  // KYC Check
  async runKYCCheck(formData) {
    return this.request('/kyc/check', {
      method: 'POST',
      body: JSON.stringify(formData),
    });
  }

  // Get all cases
  async getCases() {
    return this.request('/kyc/cases');
  }

  // Get specific case
  async getCase(id) {
    return this.request(`/kyc/case/${id}`);
  }

  // Get dashboard stats
  async getStats() {
    return this.request('/stats');
  }
}

export const api = new APIClient();
