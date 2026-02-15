import React from 'react';
import { Shield, CheckCircle, Zap, TrendingUp, Clock, DollarSign, Code, ArrowRight, Mail, Globe, Book, MessageCircle } from 'lucide-react';

const PitchPage = () => {
  return (
    <div className="min-h-screen bg-white">
      {/* Header */}
      <div className="bg-gradient-to-r from-indigo-600 to-purple-600 text-white py-16">
        <div className="max-w-4xl mx-auto px-6 text-center">
          <div className="flex items-center justify-center gap-3 mb-4">
            <Shield className="w-12 h-12" />
            <h1 className="text-5xl font-bold">VerifyFlow</h1>
          </div>
          <p className="text-2xl text-indigo-100">AI-Powered KYC/AML Compliance Platform</p>
        </div>
      </div>

      <div className="max-w-4xl mx-auto px-6 py-12">
        {/* The Problem */}
        <section className="mb-16">
          <h2 className="text-3xl font-bold text-gray-900 mb-6">The Problem</h2>
          <div className="bg-red-50 border-l-4 border-red-500 p-6 rounded-r-lg mb-6">
            <p className="text-xl font-semibold text-gray-900 mb-4">
              Fintech companies lose <span className="text-red-600">40% of customers</span> during manual KYC onboarding.
            </p>
            <p className="text-gray-700 mb-2">
              Traditional KYC processes take <strong>5-7 days</strong>, cost <strong>$500K-$2M annually</strong>, and create massive customer drop-off. Manual reviews create bottlenecks, compliance teams are overwhelmed, and customers abandon sign-ups when onboarding takes too long.
            </p>
            <p className="text-lg font-semibold text-gray-900 mt-4">
              Your customers expect minutes. You're delivering days.
            </p>
          </div>
        </section>

        {/* The Solution */}
        <section className="mb-16">
          <h2 className="text-3xl font-bold text-gray-900 mb-6">The Solution</h2>
          <div className="bg-green-50 border-l-4 border-green-500 p-6 rounded-r-lg mb-6">
            <p className="text-xl font-semibold text-gray-900 mb-4">
              VerifyFlow automates your entire KYC/AML workflow in <span className="text-green-600">under 2 minutes</span>.
            </p>
            <p className="text-gray-700 mb-2">
              We provide a complete compliance platform that handles identity verification, sanctions screening, PEP checks, and adverse media monitoring through a simple API. Reduce onboarding time from days to minutes, cut compliance costs by 60%, and eliminate manual review bottlenecks.
            </p>
            <p className="text-lg font-semibold text-gray-900 mt-4">
              From submission to approval in 60 seconds. 100% automated. Audit-ready.
            </p>
          </div>
        </section>

        {/* Key Features */}
        <section className="mb-16">
          <h2 className="text-3xl font-bold text-gray-900 mb-6">Key Features</h2>
          <div className="grid md:grid-cols-2 gap-4">
            <div className="flex items-start gap-3">
              <CheckCircle className="w-6 h-6 text-green-500 flex-shrink-0 mt-1" />
              <div>
                <strong>Identity Verification</strong> - Government ID validation with 98% accuracy
              </div>
            </div>
            <div className="flex items-start gap-3">
              <CheckCircle className="w-6 h-6 text-green-500 flex-shrink-0 mt-1" />
              <div>
                <strong>Sanctions Screening</strong> - Real-time checks against OFAC, UN, EU lists (updated hourly)
              </div>
            </div>
            <div className="flex items-start gap-3">
              <CheckCircle className="w-6 h-6 text-green-500 flex-shrink-0 mt-1" />
              <div>
                <strong>PEP Database Check</strong> - Comprehensive politically exposed persons screening
              </div>
            </div>
            <div className="flex items-start gap-3">
              <CheckCircle className="w-6 h-6 text-green-500 flex-shrink-0 mt-1" />
              <div>
                <strong>Adverse Media Monitoring</strong> - Automated news and regulatory action monitoring
              </div>
            </div>
            <div className="flex items-start gap-3">
              <CheckCircle className="w-6 h-6 text-green-500 flex-shrink-0 mt-1" />
              <div>
                <strong>REST API</strong> - Simple integration, comprehensive documentation, webhook support
              </div>
            </div>
            <div className="flex items-start gap-3">
              <CheckCircle className="w-6 h-6 text-green-500 flex-shrink-0 mt-1" />
              <div>
                <strong>Dashboard & Analytics</strong> - Real-time insights, risk distribution, compliance reports
              </div>
            </div>
            <div className="flex items-start gap-3">
              <CheckCircle className="w-6 h-6 text-green-500 flex-shrink-0 mt-1" />
              <div>
                <strong>Case Management</strong> - Complete audit trail, export capabilities, bulk operations
              </div>
            </div>
          </div>
        </section>

        {/* Why VerifyFlow */}
        <section className="mb-16">
          <h2 className="text-3xl font-bold text-gray-900 mb-6">Why VerifyFlow?</h2>
          <div className="grid md:grid-cols-2 gap-6">
            <div className="p-6 border border-gray-200 rounded-lg">
              <Zap className="w-8 h-8 text-indigo-600 mb-3" />
              <h3 className="text-xl font-semibold text-gray-900 mb-2">Speed</h3>
              <ul className="space-y-2 text-gray-700">
                <li><strong>2 minutes</strong> average processing time vs. 5-7 days manual</li>
                <li>Real-time results via webhooks</li>
                <li>Automated decision-making (92%+ auto-approval rate)</li>
              </ul>
            </div>
            <div className="p-6 border border-gray-200 rounded-lg">
              <DollarSign className="w-8 h-8 text-green-600 mb-3" />
              <h3 className="text-xl font-semibold text-gray-900 mb-2">Cost Savings</h3>
              <ul className="space-y-2 text-gray-700">
                <li><strong>60% reduction</strong> in compliance costs</li>
                <li>Eliminate manual review overhead</li>
                <li>Pay per check, scale as you grow</li>
              </ul>
            </div>
            <div className="p-6 border border-gray-200 rounded-lg">
              <Shield className="w-8 h-8 text-blue-600 mb-3" />
              <h3 className="text-xl font-semibold text-gray-900 mb-2">Compliance</h3>
              <ul className="space-y-2 text-gray-700">
                <li>Stay compliant with OFAC, UN, EU sanctions</li>
                <li>Complete audit trails for regulators</li>
                <li>SOC 2 compliant infrastructure</li>
              </ul>
            </div>
            <div className="p-6 border border-gray-200 rounded-lg">
              <Code className="w-8 h-8 text-purple-600 mb-3" />
              <h3 className="text-xl font-semibold text-gray-900 mb-2">Developer Experience</h3>
              <ul className="space-y-2 text-gray-700">
                <li><strong>15-minute integration</strong> - Simple REST API</li>
                <li>Comprehensive documentation & SDKs</li>
                <li>Webhook support for real-time updates</li>
                <li>99.9% uptime SLA</li>
              </ul>
            </div>
          </div>
        </section>

        {/* Perfect For */}
        <section className="mb-16">
          <h2 className="text-3xl font-bold text-gray-900 mb-6">Perfect For</h2>
          <div className="grid md:grid-cols-2 gap-4">
            <div className="p-4 bg-gray-50 rounded-lg">
              <strong>🏦 Banking-as-a-Service</strong> (Unit, Synapse, Moov) - White-label KYC for your customers
            </div>
            <div className="p-4 bg-gray-50 rounded-lg">
              <strong>💳 Payment Processors</strong> - Fast onboarding, fraud prevention
            </div>
            <div className="p-4 bg-gray-50 rounded-lg">
              <strong>🏛️ Neobanks</strong> (Current, Step, Mercury) - Consumer & business banking compliance
            </div>
            <div className="p-4 bg-gray-50 rounded-lg">
              <strong>💰 Lending Platforms</strong> - Risk assessment, regulatory compliance
            </div>
            <div className="p-4 bg-gray-50 rounded-lg">
              <strong>🪙 Crypto Exchanges</strong> - Crypto-native KYC with global compliance
            </div>
            <div className="p-4 bg-gray-50 rounded-lg">
              <strong>📊 Fintech Startups</strong> - Get compliant fast, scale without hiring compliance team
            </div>
          </div>
        </section>

        {/* Pricing */}
        <section className="mb-16">
          <h2 className="text-3xl font-bold text-gray-900 mb-6">Pricing</h2>
          <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
            <div className="border border-gray-200 rounded-lg p-6">
              <h3 className="text-lg font-semibold text-gray-900 mb-2">Free Forever</h3>
              <div className="text-2xl font-bold text-gray-900 mb-4">$0</div>
              <ul className="space-y-2 text-sm text-gray-600">
                <li>✓ 100 KYC checks/month</li>
                <li>✓ All core features</li>
                <li>✓ Community support</li>
                <li>✓ Perfect for testing</li>
              </ul>
            </div>
            <div className="border border-gray-200 rounded-lg p-6">
              <h3 className="text-lg font-semibold text-gray-900 mb-2">Starter</h3>
              <div className="text-2xl font-bold text-gray-900 mb-4">$99<span className="text-sm text-gray-600">/mo</span></div>
              <ul className="space-y-2 text-sm text-gray-600">
                <li>✓ 1,000 KYC checks/month</li>
                <li>✓ Priority support</li>
                <li>✓ Webhook configuration</li>
                <li>✓ $0.10 per additional check</li>
              </ul>
            </div>
            <div className="border-2 border-indigo-600 rounded-lg p-6 relative">
              <div className="absolute -top-3 left-1/2 transform -translate-x-1/2 bg-indigo-600 text-white px-3 py-1 rounded-full text-xs font-semibold">
                Popular
              </div>
              <h3 className="text-lg font-semibold text-gray-900 mb-2">Professional</h3>
              <div className="text-2xl font-bold text-gray-900 mb-4">$499<span className="text-sm text-gray-600">/mo</span></div>
              <ul className="space-y-2 text-sm text-gray-600">
                <li>✓ 10,000 KYC checks/month</li>
                <li>✓ API access</li>
                <li>✓ Advanced analytics</li>
                <li>✓ Custom risk rules</li>
                <li>✓ $0.05 per additional check</li>
              </ul>
            </div>
            <div className="border border-gray-200 rounded-lg p-6">
              <h3 className="text-lg font-semibold text-gray-900 mb-2">Enterprise</h3>
              <div className="text-2xl font-bold text-gray-900 mb-4">Custom</div>
              <ul className="space-y-2 text-sm text-gray-600">
                <li>✓ Unlimited checks</li>
                <li>✓ Dedicated account manager</li>
                <li>✓ Custom SLA (99.99%)</li>
                <li>✓ On-premise options</li>
                <li>✓ White-label solutions</li>
              </ul>
            </div>
          </div>
        </section>

        {/* Integration Example */}
        <section className="mb-16">
          <h2 className="text-3xl font-bold text-gray-900 mb-6">Integration Example</h2>
          <div className="bg-gray-900 rounded-lg p-6 overflow-x-auto">
            <pre className="text-green-400 text-sm">
              <code>{`// Run a KYC check in 3 lines of code
const result = await fetch('https://api.verifyflow.com/kyc/check', {
  method: 'POST',
  headers: {
    'Authorization': 'Bearer YOUR_API_KEY',
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    firstName: 'John',
    lastName: 'Doe',
    dateOfBirth: '1990-01-15',
    country: 'United States',
    idNumber: 'P123456789'
  })
});

// Results delivered via webhook in <60 seconds`}</code>
            </pre>
          </div>
          <p className="text-center mt-4 text-gray-700 font-semibold">
            15 minutes to integrate. Start processing checks immediately.
          </p>
        </section>

        {/* Results */}
        <section className="mb-16">
          <h2 className="text-3xl font-bold text-gray-900 mb-6">Results</h2>
          <div className="grid md:grid-cols-2 lg:grid-cols-5 gap-4">
            <div className="text-center p-6 bg-indigo-50 rounded-lg">
              <TrendingUp className="w-8 h-8 text-indigo-600 mx-auto mb-2" />
              <div className="text-2xl font-bold text-gray-900">92.3%</div>
              <div className="text-sm text-gray-600">Approval rate</div>
            </div>
            <div className="text-center p-6 bg-green-50 rounded-lg">
              <Clock className="w-8 h-8 text-green-600 mx-auto mb-2" />
              <div className="text-2xl font-bold text-gray-900">2.4 min</div>
              <div className="text-sm text-gray-600">Average processing</div>
            </div>
            <div className="text-center p-6 bg-blue-50 rounded-lg">
              <DollarSign className="w-8 h-8 text-blue-600 mx-auto mb-2" />
              <div className="text-2xl font-bold text-gray-900">60%</div>
              <div className="text-sm text-gray-600">Cost reduction</div>
            </div>
            <div className="text-center p-6 bg-purple-50 rounded-lg">
              <CheckCircle className="w-8 h-8 text-purple-600 mx-auto mb-2" />
              <div className="text-2xl font-bold text-gray-900">100%</div>
              <div className="text-sm text-gray-600">Audit-ready</div>
            </div>
            <div className="text-center p-6 bg-yellow-50 rounded-lg">
              <Zap className="w-8 h-8 text-yellow-600 mx-auto mb-2" />
              <div className="text-2xl font-bold text-gray-900">99.9%</div>
              <div className="text-sm text-gray-600">Uptime SLA</div>
            </div>
          </div>
        </section>

        {/* Next Steps */}
        <section className="mb-16">
          <h2 className="text-3xl font-bold text-gray-900 mb-6">Next Steps</h2>
          <div className="grid md:grid-cols-2 gap-8">
            <div className="p-6 border border-gray-200 rounded-lg">
              <h3 className="text-xl font-semibold text-gray-900 mb-4">For Developers</h3>
              <ol className="space-y-3 text-gray-700">
                <li className="flex items-start gap-2">
                  <span className="font-bold text-indigo-600">1.</span>
                  <span><strong>Sign up free</strong> - 100 checks/month forever, no credit card</span>
                </li>
                <li className="flex items-start gap-2">
                  <span className="font-bold text-indigo-600">2.</span>
                  <span><strong>Get API keys</strong> - Instant access, test immediately</span>
                </li>
                <li className="flex items-start gap-2">
                  <span className="font-bold text-indigo-600">3.</span>
                  <span><strong>Integrate in 15 minutes</strong> - Simple REST API, full documentation</span>
                </li>
                <li className="flex items-start gap-2">
                  <span className="font-bold text-indigo-600">4.</span>
                  <span><strong>Scale as you grow</strong> - Upgrade when you need more volume</span>
                </li>
              </ol>
            </div>
            <div className="p-6 border border-gray-200 rounded-lg">
              <h3 className="text-xl font-semibold text-gray-900 mb-4">For Business Teams</h3>
              <ol className="space-y-3 text-gray-700">
                <li className="flex items-start gap-2">
                  <span className="font-bold text-indigo-600">1.</span>
                  <span><strong>Schedule a demo</strong> - See the platform in action</span>
                </li>
                <li className="flex items-start gap-2">
                  <span className="font-bold text-indigo-600">2.</span>
                  <span><strong>Free pilot</strong> - 1,000 checks free for qualified companies</span>
                </li>
                <li className="flex items-start gap-2">
                  <span className="font-bold text-indigo-600">3.</span>
                  <span><strong>Custom pricing</strong> - Volume discounts for high-volume users</span>
                </li>
                <li className="flex items-start gap-2">
                  <span className="font-bold text-indigo-600">4.</span>
                  <span><strong>Dedicated support</strong> - Enterprise plans include account manager</span>
                </li>
              </ol>
            </div>
          </div>
        </section>

        {/* API Endpoints */}
        <section className="mb-16">
          <h2 className="text-3xl font-bold text-gray-900 mb-6">API Endpoints</h2>
          <div className="bg-gray-50 rounded-lg p-6">
            <div className="space-y-2 font-mono text-sm">
              <div><span className="text-green-600 font-semibold">POST</span>   /api/kyc/check          - Run new KYC check</div>
              <div><span className="text-blue-600 font-semibold">GET</span>    /api/kyc/cases           - List all cases</div>
              <div><span className="text-blue-600 font-semibold">GET</span>    /api/kyc/cases/:id       - Get case details</div>
              <div><span className="text-green-600 font-semibold">POST</span>   /api/webhooks            - Configure webhooks</div>
              <div><span className="text-blue-600 font-semibold">GET</span>    /api/health              - Health check</div>
            </div>
          </div>
        </section>

        {/* Contact */}
        <section className="mb-16 bg-indigo-600 text-white rounded-xl p-8">
          <h2 className="text-3xl font-bold mb-6">Contact</h2>
          <div className="grid md:grid-cols-2 gap-6">
            <div className="flex items-center gap-3">
              <Globe className="w-6 h-6" />
              <div>
                <div className="font-semibold">Website</div>
                <a href="https://complianceos-47da776pe-yoshi-kondos-projects.vercel.app" className="text-indigo-200 hover:text-white">
                  verifyflow.com
                </a>
              </div>
            </div>
            <div className="flex items-center gap-3">
              <Mail className="w-6 h-6" />
              <div>
                <div className="font-semibold">Partnerships</div>
                <a href="mailto:partnerships@verifyflow.com" className="text-indigo-200 hover:text-white">
                  partnerships@verifyflow.com
                </a>
              </div>
            </div>
            <div className="flex items-center gap-3">
              <Book className="w-6 h-6" />
              <div>
                <div className="font-semibold">Documentation</div>
                <a href="/docs" className="text-indigo-200 hover:text-white">
                  docs.verifyflow.com
                </a>
              </div>
            </div>
            <div className="flex items-center gap-3">
              <MessageCircle className="w-6 h-6" />
              <div>
                <div className="font-semibold">Support</div>
                <a href="mailto:support@verifyflow.com" className="text-indigo-200 hover:text-white">
                  support@verifyflow.com
                </a>
              </div>
            </div>
          </div>
          <div className="mt-8 text-center">
            <a href="/app" className="inline-block bg-white text-indigo-600 px-8 py-4 rounded-lg font-semibold hover:bg-gray-100 flex items-center gap-2 mx-auto">
              Start Free Today
              <ArrowRight className="w-5 h-5" />
            </a>
            <p className="text-indigo-200 mt-4 text-sm">Ready to automate your KYC? Start free today.</p>
          </div>
        </section>

        {/* Footer */}
        <div className="text-center text-gray-500 text-sm py-8 border-t border-gray-200">
          <p className="italic">VerifyFlow - KYC/AML Compliance in Minutes, Not Days</p>
        </div>
      </div>
    </div>
  );
};

export default PitchPage;


