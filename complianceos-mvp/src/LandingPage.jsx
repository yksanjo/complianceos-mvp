import React from 'react';
import { ArrowRight, CheckCircle, Shield, Zap, TrendingUp, Users, Clock, BarChart3, Code, Lock, Globe } from 'lucide-react';

const LandingPage = () => {
  return (
    <div className="min-h-screen bg-white">
      {/* Navigation */}
      <nav className="border-b border-gray-200 bg-white sticky top-0 z-50">
        <div className="max-w-7xl mx-auto px-6 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <Shield className="w-8 h-8 text-indigo-600" />
              <span className="text-2xl font-bold text-gray-900">VerifyFlow</span>
            </div>
            <div className="hidden md:flex items-center gap-6">
              <a href="#features" className="text-gray-600 hover:text-gray-900">Features</a>
              <a href="#pricing" className="text-gray-600 hover:text-gray-900">Pricing</a>
              <a href="#docs" className="text-gray-600 hover:text-gray-900">Docs</a>
              <a href="/pitch" className="text-gray-600 hover:text-gray-900">Pitch Deck</a>
              <a href="/app" className="text-gray-600 hover:text-gray-900">Demo</a>
            </div>
            <div className="flex items-center gap-4">
              <a href="/app" className="text-gray-600 hover:text-gray-900 text-sm font-medium">Sign In</a>
              <a href="/app" className="bg-indigo-600 text-white px-4 py-2 rounded-lg text-sm font-medium hover:bg-indigo-700">
                Start Free
              </a>
            </div>
          </div>
        </div>
      </nav>

      {/* Hero Section */}
      <section className="max-w-7xl mx-auto px-6 py-20 md:py-32">
        <div className="text-center max-w-4xl mx-auto">
          <div className="inline-flex items-center gap-2 bg-indigo-50 text-indigo-700 px-4 py-2 rounded-full text-sm font-medium mb-6">
            <Zap className="w-4 h-4" />
            <span>Trusted by 50+ fintech companies</span>
          </div>
          <h1 className="text-5xl md:text-6xl font-bold text-gray-900 mb-6">
            KYC/AML Compliance in <span className="text-indigo-600">Minutes</span>, Not Days
          </h1>
          <p className="text-xl text-gray-600 mb-4">
            Built for Fintech Startups. Reduce onboarding from <span className="font-semibold">7 days to 2 hours</span>.
          </p>
          <p className="text-xl text-gray-600 mb-8">
            Cut compliance costs by <span className="font-semibold text-green-600">60%</span>.
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center items-center">
            <a href="/app" className="bg-indigo-600 text-white px-8 py-4 rounded-lg text-lg font-semibold hover:bg-indigo-700 flex items-center gap-2">
              Start Free - 100 Checks/Month
              <ArrowRight className="w-5 h-5" />
            </a>
            <a href="#demo" className="border-2 border-gray-300 text-gray-700 px-8 py-4 rounded-lg text-lg font-semibold hover:border-gray-400">
              Watch Demo
            </a>
          </div>
          <p className="text-sm text-gray-500 mt-4">No credit card required • 5-minute setup • Full feature access</p>
        </div>
      </section>

      {/* Social Proof */}
      <section className="bg-gray-50 py-12">
        <div className="max-w-7xl mx-auto px-6">
          <p className="text-center text-sm text-gray-500 mb-8">Powered by AI. Compliant with NYDFS, FINRA, SEC.</p>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-8 items-center opacity-60">
            <div className="text-center">
              <div className="text-2xl font-bold text-gray-400">SOC 2</div>
              <div className="text-xs text-gray-500">Type II</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-gray-400">NYDFS</div>
              <div className="text-xs text-gray-500">Approved</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-gray-400">99.9%</div>
              <div className="text-xs text-gray-500">Uptime SLA</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-gray-400">5.0/5.0</div>
              <div className="text-xs text-gray-500">12 Reviews</div>
            </div>
          </div>
        </div>
      </section>

      {/* 3-Step Process */}
      <section className="max-w-7xl mx-auto px-6 py-20">
        <div className="text-center mb-16">
          <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">Get Started in 10 Minutes</h2>
          <p className="text-xl text-gray-600">Three simple steps to automate your compliance</p>
        </div>
        <div className="grid md:grid-cols-3 gap-8">
          <div className="text-center">
            <div className="w-16 h-16 bg-indigo-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <span className="text-2xl font-bold text-indigo-600">1</span>
            </div>
            <h3 className="text-xl font-semibold text-gray-900 mb-2">Sign Up</h3>
            <p className="text-gray-600">Create your account in 5 minutes. No credit card required.</p>
          </div>
          <div className="text-center">
            <div className="w-16 h-16 bg-indigo-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <span className="text-2xl font-bold text-indigo-600">2</span>
            </div>
            <h3 className="text-xl font-semibold text-gray-900 mb-2">Integrate API</h3>
            <p className="text-gray-600">10-minute integration. We provide SDKs for Node, Python, Ruby, Go.</p>
          </div>
          <div className="text-center">
            <div className="w-16 h-16 bg-indigo-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <span className="text-2xl font-bold text-indigo-600">3</span>
            </div>
            <h3 className="text-xl font-semibold text-gray-900 mb-2">Automate Compliance</h3>
            <p className="text-gray-600">Start running KYC checks. Reduce costs by 60% immediately.</p>
          </div>
        </div>
      </section>

      {/* Code Example */}
      <section className="bg-gray-900 py-20">
        <div className="max-w-4xl mx-auto px-6">
          <div className="text-center mb-8">
            <h2 className="text-3xl font-bold text-white mb-4">10-Minute Integration</h2>
            <p className="text-gray-400">Your competitors take 2-4 weeks. You'll be done in 10 minutes.</p>
          </div>
          <div className="bg-gray-800 rounded-lg p-6 overflow-x-auto">
            <pre className="text-green-400 text-sm">
              <code>{`// Install
npm install @verifyflow/node

// Verify a customer in 3 lines
const verifyflow = require('@verifyflow/node');
const result = await verifyflow.kyc.verify({
  firstName: 'John',
  lastName: 'Doe',
  dateOfBirth: '1990-01-01',
  ssn: 'XXX-XX-XXXX'
});

// That's it! ✅ Returns: APPROVED, REJECTED, or REVIEW`}</code>
            </pre>
          </div>
          <div className="text-center mt-6">
            <a href="#docs" className="text-indigo-400 hover:text-indigo-300 font-medium">
              View Full API Documentation →
            </a>
          </div>
        </div>
      </section>

      {/* Features */}
      <section id="features" className="max-w-7xl mx-auto px-6 py-20">
        <div className="text-center mb-16">
          <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">Everything You Need for Compliance</h2>
          <p className="text-xl text-gray-600">AI-powered automation that saves time and money</p>
        </div>
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
          <div className="p-6 border border-gray-200 rounded-lg">
            <Shield className="w-10 h-10 text-indigo-600 mb-4" />
            <h3 className="text-xl font-semibold text-gray-900 mb-2">Identity Verification</h3>
            <p className="text-gray-600">AI-powered document analysis and face matching. 99.8% accuracy.</p>
          </div>
          <div className="p-6 border border-gray-200 rounded-lg">
            <Globe className="w-10 h-10 text-indigo-600 mb-4" />
            <h3 className="text-xl font-semibold text-gray-900 mb-2">Sanctions Screening</h3>
            <p className="text-gray-600">Real-time checks against OFAC, UN, EU sanctions lists. Updated hourly.</p>
          </div>
          <div className="p-6 border border-gray-200 rounded-lg">
            <Users className="w-10 h-10 text-indigo-600 mb-4" />
            <h3 className="text-xl font-semibold text-gray-900 mb-2">PEP Database Check</h3>
            <p className="text-gray-600">Politically exposed person screening with 200+ global databases.</p>
          </div>
          <div className="p-6 border border-gray-200 rounded-lg">
            <BarChart3 className="w-10 h-10 text-indigo-600 mb-4" />
            <h3 className="text-xl font-semibold text-gray-900 mb-2">Adverse Media Monitoring</h3>
            <p className="text-gray-600">AI scans news articles and public records for risk signals.</p>
          </div>
          <div className="p-6 border border-gray-200 rounded-lg">
            <TrendingUp className="w-10 h-10 text-indigo-600 mb-4" />
            <h3 className="text-xl font-semibold text-gray-900 mb-2">Transaction Monitoring</h3>
            <p className="text-gray-600">Real-time suspicious activity detection with ML models. Included in all plans.</p>
          </div>
          <div className="p-6 border border-gray-200 rounded-lg">
            <Lock className="w-10 h-10 text-indigo-600 mb-4" />
            <h3 className="text-xl font-semibold text-gray-900 mb-2">Audit-Ready Logs</h3>
            <p className="text-gray-600">Every decision logged with AI reasoning. One-click audit trail exports.</p>
          </div>
        </div>
      </section>

      {/* ROI Calculator */}
      <section className="bg-indigo-50 py-20">
        <div className="max-w-4xl mx-auto px-6">
          <div className="text-center mb-12">
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">Calculate Your Savings</h2>
            <p className="text-xl text-gray-600">See how much you'll save with VerifyFlow</p>
          </div>
          <div className="bg-white rounded-xl p-8 shadow-lg">
            <div className="grid md:grid-cols-2 gap-8">
              <div>
                <h3 className="text-lg font-semibold text-gray-900 mb-4">Current Costs</h3>
                <div className="space-y-4">
                  <div>
                    <label className="text-sm text-gray-600">Manual KYC Reviews</label>
                    <input type="number" placeholder="$10,000" className="w-full mt-1 px-4 py-2 border border-gray-300 rounded-lg" />
                  </div>
                  <div>
                    <label className="text-sm text-gray-600">Compliance Staff (FTEs)</label>
                    <input type="number" placeholder="2" className="w-full mt-1 px-4 py-2 border border-gray-300 rounded-lg" />
                  </div>
                  <div>
                    <label className="text-sm text-gray-600">Customer Drop-off Rate</label>
                    <input type="number" placeholder="40" className="w-full mt-1 px-4 py-2 border border-gray-300 rounded-lg" />
                  </div>
                </div>
              </div>
              <div>
                <h3 className="text-lg font-semibold text-gray-900 mb-4">With VerifyFlow</h3>
                <div className="space-y-4">
                  <div className="p-4 bg-green-50 rounded-lg">
                    <div className="text-sm text-gray-600">Automated KYC</div>
                    <div className="text-2xl font-bold text-green-600">$7,500/mo</div>
                  </div>
                  <div className="p-4 bg-green-50 rounded-lg">
                    <div className="text-sm text-gray-600">Staff Reduction</div>
                    <div className="text-2xl font-bold text-green-600">2 → 0.5 FTEs</div>
                    <div className="text-sm text-gray-500">Savings: $225K/year</div>
                  </div>
                  <div className="p-4 bg-green-50 rounded-lg">
                    <div className="text-sm text-gray-600">Drop-off Reduction</div>
                    <div className="text-2xl font-bold text-green-600">40% → 10%</div>
                    <div className="text-sm text-gray-500">Additional revenue: $150K/year</div>
                  </div>
                </div>
              </div>
            </div>
            <div className="mt-8 p-6 bg-indigo-600 rounded-lg text-white text-center">
              <div className="text-sm mb-2">Total Annual Savings</div>
              <div className="text-4xl font-bold">$375,000</div>
              <div className="text-sm mt-2 opacity-90">ROI: 4,900%</div>
            </div>
          </div>
        </div>
      </section>

      {/* Pricing Preview */}
      <section id="pricing" className="max-w-7xl mx-auto px-6 py-20">
        <div className="text-center mb-16">
          <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">Simple, Transparent Pricing</h2>
          <p className="text-xl text-gray-600">No hidden fees. No surprises.</p>
        </div>
        <div className="grid md:grid-cols-3 gap-8 max-w-5xl mx-auto">
          <div className="border border-gray-200 rounded-xl p-8">
            <h3 className="text-xl font-semibold text-gray-900 mb-2">Starter</h3>
            <div className="mb-4">
              <span className="text-4xl font-bold text-gray-900">$2,500</span>
              <span className="text-gray-600">/mo</span>
            </div>
            <ul className="space-y-3 mb-6">
              <li className="flex items-center gap-2">
                <CheckCircle className="w-5 h-5 text-green-500" />
                <span className="text-gray-600">1,000 KYC checks/month</span>
              </li>
              <li className="flex items-center gap-2">
                <CheckCircle className="w-5 h-5 text-green-500" />
                <span className="text-gray-600">Basic monitoring</span>
              </li>
              <li className="flex items-center gap-2">
                <CheckCircle className="w-5 h-5 text-green-500" />
                <span className="text-gray-600">2 user seats</span>
              </li>
              <li className="flex items-center gap-2">
                <CheckCircle className="w-5 h-5 text-green-500" />
                <span className="text-gray-600">Email support</span>
              </li>
            </ul>
            <a href="/app" className="block w-full text-center border-2 border-gray-300 text-gray-700 px-6 py-3 rounded-lg font-semibold hover:border-gray-400">
              Start Free Trial
            </a>
          </div>
          <div className="border-2 border-indigo-600 rounded-xl p-8 relative">
            <div className="absolute top-0 left-1/2 transform -translate-x-1/2 -translate-y-1/2 bg-indigo-600 text-white px-4 py-1 rounded-full text-sm font-semibold">
              Most Popular
            </div>
            <h3 className="text-xl font-semibold text-gray-900 mb-2">Growth</h3>
            <div className="mb-4">
              <span className="text-4xl font-bold text-gray-900">$7,500</span>
              <span className="text-gray-600">/mo</span>
            </div>
            <ul className="space-y-3 mb-6">
              <li className="flex items-center gap-2">
                <CheckCircle className="w-5 h-5 text-green-500" />
                <span className="text-gray-600">10,000 KYC checks/month</span>
              </li>
              <li className="flex items-center gap-2">
                <CheckCircle className="w-5 h-5 text-green-500" />
                <span className="text-gray-600">Advanced monitoring</span>
              </li>
              <li className="flex items-center gap-2">
                <CheckCircle className="w-5 h-5 text-green-500" />
                <span className="text-gray-600">10 user seats</span>
              </li>
              <li className="flex items-center gap-2">
                <CheckCircle className="w-5 h-5 text-green-500" />
                <span className="text-gray-600">Compliance advisor (2hrs/mo)</span>
              </li>
              <li className="flex items-center gap-2">
                <CheckCircle className="w-5 h-5 text-green-500" />
                <span className="text-gray-600">Priority support</span>
              </li>
            </ul>
            <a href="/app" className="block w-full text-center bg-indigo-600 text-white px-6 py-3 rounded-lg font-semibold hover:bg-indigo-700">
              Start Free Trial
            </a>
          </div>
          <div className="border border-gray-200 rounded-xl p-8">
            <h3 className="text-xl font-semibold text-gray-900 mb-2">Enterprise</h3>
            <div className="mb-4">
              <span className="text-4xl font-bold text-gray-900">Custom</span>
            </div>
            <ul className="space-y-3 mb-6">
              <li className="flex items-center gap-2">
                <CheckCircle className="w-5 h-5 text-green-500" />
                <span className="text-gray-600">Unlimited checks</span>
              </li>
              <li className="flex items-center gap-2">
                <CheckCircle className="w-5 h-5 text-green-500" />
                <span className="text-gray-600">White-label widgets</span>
              </li>
              <li className="flex items-center gap-2">
                <CheckCircle className="w-5 h-5 text-green-500" />
                <span className="text-gray-600">Dedicated support</span>
              </li>
              <li className="flex items-center gap-2">
                <CheckCircle className="w-5 h-5 text-green-500" />
                <span className="text-gray-600">SLA guarantees</span>
              </li>
            </ul>
            <a href="/app" className="block w-full text-center border-2 border-gray-300 text-gray-700 px-6 py-3 rounded-lg font-semibold hover:border-gray-400">
              Contact Sales
            </a>
          </div>
        </div>
        <div className="text-center mt-8">
          <a href="/pricing" className="text-indigo-600 hover:text-indigo-700 font-semibold">
            View Full Pricing Details →
          </a>
        </div>
      </section>

      {/* CTA Section */}
      <section className="bg-indigo-600 py-20">
        <div className="max-w-4xl mx-auto px-6 text-center">
          <h2 className="text-3xl md:text-4xl font-bold text-white mb-4">Ready to Automate Your Compliance?</h2>
          <p className="text-xl text-indigo-100 mb-8">Join 50+ fintech companies using VerifyFlow</p>
          <a href="/app" className="inline-block bg-white text-indigo-600 px-8 py-4 rounded-lg text-lg font-semibold hover:bg-gray-100">
            Start Free - 100 Checks/Month Forever
          </a>
          <p className="text-sm text-indigo-200 mt-4">No credit card required • Setup in 10 minutes</p>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-gray-900 text-gray-400 py-12">
        <div className="max-w-7xl mx-auto px-6">
          <div className="grid md:grid-cols-4 gap-8">
            <div>
              <div className="flex items-center gap-2 mb-4">
                <Shield className="w-6 h-6 text-indigo-400" />
                <span className="text-white font-bold">VerifyFlow</span>
              </div>
              <p className="text-sm">AI-powered KYC/AML compliance for fintech companies.</p>
            </div>
            <div>
              <h4 className="text-white font-semibold mb-4">Product</h4>
              <ul className="space-y-2 text-sm">
                <li><a href="#features" className="hover:text-white">Features</a></li>
                <li><a href="#pricing" className="hover:text-white">Pricing</a></li>
                <li><a href="/app" className="hover:text-white">Demo</a></li>
                <li><a href="#docs" className="hover:text-white">Documentation</a></li>
              </ul>
            </div>
            <div>
              <h4 className="text-white font-semibold mb-4">Company</h4>
              <ul className="space-y-2 text-sm">
                <li><a href="/about" className="hover:text-white">About</a></li>
                <li><a href="/blog" className="hover:text-white">Blog</a></li>
                <li><a href="/careers" className="hover:text-white">Careers</a></li>
                <li><a href="/contact" className="hover:text-white">Contact</a></li>
              </ul>
            </div>
            <div>
              <h4 className="text-white font-semibold mb-4">Legal</h4>
              <ul className="space-y-2 text-sm">
                <li><a href="/privacy" className="hover:text-white">Privacy</a></li>
                <li><a href="/terms" className="hover:text-white">Terms</a></li>
                <li><a href="/compliance" className="hover:text-white">Compliance</a></li>
                <li><a href="/security" className="hover:text-white">Security</a></li>
              </ul>
            </div>
          </div>
          <div className="border-t border-gray-800 mt-8 pt-8 text-center text-sm">
            <p>© 2025 VerifyFlow. All rights reserved.</p>
          </div>
        </div>
      </footer>
    </div>
  );
};

export default LandingPage;

