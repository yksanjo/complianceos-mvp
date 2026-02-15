#!/usr/bin/env python3
"""
Moltbook Analysis Interactive CLI

Interactive tool to explore Moltbook.com's login and active agent system analysis.
"""

import json
import sys
from typing import Optional
from dataclasses import asdict

# Import the analyzer
from moltbook_analyzer import MoltbookAnalyzer, MoltbookEndpoint


class MoltbookAnalysisCLI:
    """Interactive CLI for Moltbook analysis."""
    
    def __init__(self):
        self.analyzer: Optional[MoltbookAnalyzer] = None
        self.results = None
    
    def print_header(self, title: str):
        """Print a formatted header."""
        print("\n" + "=" * 60)
        print(f"  {title}")
        print("=" * 60)
    
    def print_menu(self):
        """Print main menu."""
        self.print_header("MOLTBOOK ANALYSIS CLI")
        print("""
  1. 🚀 Run Full Analysis
  2. 📚 View Documentation (skill.md, heartbeat.md, messaging.md)
  3. 🔐 View Authentication System
  4. 💓 View Heartbeat System
  5. 📡 View API Endpoints
  6. 🛡️  View Security Features
  7. 💬 View Messaging System
  8. 📊 View Platform Statistics
  9. 💾 Save Analysis to JSON
  0. 🚪 Exit
        """)
    
    def run_analysis(self):
        """Run the full analysis."""
        self.analyzer = MoltbookAnalyzer()
        self.analyzer.run_full_analysis()
        self.results = self.analyzer.results
        input("\nPress Enter to continue...")
    
    def view_documentation(self):
        """View fetched documentation."""
        if not self.analyzer:
            print("\n⚠️  Please run analysis first (Option 1)")
            input("\nPress Enter to continue...")
            return
        
        self.print_header("DOCUMENTATION VIEWER")
        print("\n  1. skill.md - Platform capabilities and API")
        print("  2. heartbeat.md - Active agent system")
        print("  3. messaging.md - Private messaging system")
        print("  0. Back to main menu")
        
        choice = input("\nSelect document: ").strip()
        
        if choice == "1":
            self._show_doc("skill.md", self.analyzer.results.skill_md)
        elif choice == "2":
            self._show_doc("heartbeat.md", self.analyzer.results.heartbeat_md)
        elif choice == "3":
            self._show_doc("messaging.md", self.analyzer.results.messaging_md)
    
    def _show_doc(self, name: str, content: str):
        """Show document content with pagination."""
        self.print_header(f"VIEWING: {name}")
        
        lines = content.split('\n')
        page_size = 30
        current = 0
        
        while current < len(lines):
            # Show page
            for line in lines[current:current + page_size]:
                print(line)
            
            current += page_size
            
            if current < len(lines):
                more = input(f"\n... {len(lines) - current} lines remaining. Press Enter for more, 'q' to quit: ")
                if more.lower() == 'q':
                    break
    
    def view_auth_system(self):
        """View authentication system details."""
        if not self.analyzer:
            print("\n⚠️  Please run analysis first (Option 1)")
            input("\nPress Enter to continue...")
            return
        
        self.print_header("AUTHENTICATION SYSTEM")
        auth = self.analyzer.results.auth_flow
        
        print("\n🔑 REGISTRATION FLOW:")
        print("-" * 40)
        reg = auth.get('registration', {})
        print(f"  Endpoint: {reg.get('endpoint', 'N/A')}")
        print(f"  Method: {reg.get('method', 'N/A')}")
        print(f"  Required Fields: {', '.join(reg.get('required_fields', []))}")
        print(f"  Response Fields: {', '.join(reg.get('response_fields', []))}")
        
        print("\n🔒 AUTHENTICATION:")
        print("-" * 40)
        authn = auth.get('authentication', {})
        print(f"  Type: {authn.get('type', 'N/A')}")
        print(f"  Header: {authn.get('header_format', 'N/A')}")
        print(f"  ⚠️  Warning: {authn.get('security_warning', 'N/A')}")
        
        print("\n✅ CLAIM PROCESS:")
        print("-" * 40)
        claim = auth.get('claim_process', {})
        for i, step in enumerate(claim.get('steps', []), 1):
            print(f"  {i}. {step}")
        
        print("\n📊 STATUS CHECK:")
        print("-" * 40)
        status = auth.get('status_check', {})
        print(f"  Endpoint: {status.get('endpoint', 'N/A')}")
        print(f"  States: {', '.join(status.get('states', []))}")
        
        input("\nPress Enter to continue...")
    
    def view_heartbeat_system(self):
        """View heartbeat system details."""
        if not self.analyzer:
            print("\n⚠️  Please run analysis first (Option 1)")
            input("\nPress Enter to continue...")
            return
        
        self.print_header("HEARTBEAT SYSTEM (ACTIVE AGENT)")
        hb = self.analyzer.results.heartbeat_system
        
        print(f"\n💓 PURPOSE: {hb.get('purpose', 'N/A')}")
        print(f"⏱️  FREQUENCY: {hb.get('frequency', 'N/A')}")
        print(f"📋 MECHANISM: {hb.get('mechanism', 'N/A')}")
        
        print("\n📋 HEARTBEAT CHECKLIST:")
        print("-" * 60)
        for item in hb.get('checklist', []):
            print(f"\n  Step {item.get('step', '?')}:")
            print(f"    Action: {item.get('action', 'N/A')}")
            print(f"    Endpoint: {item.get('endpoint', 'N/A')}")
            print(f"    Purpose: {item.get('purpose', 'N/A')}")
            if item.get('rate_limit'):
                print(f"    ⚠️  Rate Limit: {item['rate_limit']}")
        
        print("\n🗄️  STATE MANAGEMENT:")
        print("-" * 40)
        state = hb.get('state_management', {})
        print(f"  Required State: {', '.join(state.get('required_state', []))}")
        print(f"  Logic: {state.get('logic', 'N/A')}")
        print(f"  Storage: {state.get('storage', 'N/A')}")
        
        input("\nPress Enter to continue...")
    
    def view_api_endpoints(self):
        """View API endpoints."""
        if not self.analyzer:
            print("\n⚠️  Please run analysis first (Option 1)")
            input("\nPress Enter to continue...")
            return
        
        self.print_header("API ENDPOINTS")
        
        # Show sample endpoints based on documentation
        endpoints = [
            ("POST", "/api/v1/agents/register", "Register new agent", False),
            ("GET", "/api/v1/agents/status", "Check claim status"),
            ("GET", "/api/v1/agents/me", "Get own profile"),
            ("GET", "/api/v1/posts", "Get feed posts"),
            ("POST", "/api/v1/posts", "Create new post"),
            ("POST", "/api/v1/posts/{id}/upvote", "Upvote a post"),
            ("GET", "/api/v1/posts/{id}/comments", "Get post comments"),
            ("POST", "/api/v1/posts/{id}/comments", "Add comment"),
            ("GET", "/api/v1/submolts", "List communities"),
            ("GET", "/api/v1/feed", "Get personalized feed"),
            ("GET", "/api/v1/search", "Semantic search"),
            ("GET", "/api/v1/agents/dm/check", "Check DM activity"),
            ("POST", "/api/v1/agents/dm/request", "Send chat request"),
            ("GET", "/api/v1/agents/dm/conversations", "List conversations"),
            ("POST", "/api/v1/agents/dm/conversations/{id}/send", "Send DM"),
        ]
        
        print(f"\nFound {len(endpoints)} endpoints:\n")
        print(f"{'Method':<8} {'Endpoint':<45} {'Auth':<6}")
        print("-" * 70)
        
        for method, path, desc, *auth in endpoints:
            auth_required = auth[0] if auth else True
            auth_str = "✓" if auth_required else "✗"
            print(f"{method:<8} {path:<45} {auth_str:<6}")
        
        print("\n" + "-" * 70)
        print("Note: ✓ = Authentication required, ✗ = Public endpoint")
        
        input("\nPress Enter to continue...")
    
    def view_security_features(self):
        """View security features."""
        if not self.analyzer:
            print("\n⚠️  Please run analysis first (Option 1)")
            input("\nPress Enter to continue...")
            return
        
        self.print_header("SECURITY FEATURES")
        
        for feature in self.analyzer.results.security_features:
            print(f"\n🛡️  {feature['feature']}")
            print(f"   Description: {feature['description']}")
            print(f"   Purpose: {feature['purpose']}")
        
        input("\nPress Enter to continue...")
    
    def view_messaging_system(self):
        """View messaging system."""
        if not self.analyzer:
            print("\n⚠️  Please run analysis first (Option 1)")
            input("\nPress Enter to continue...")
            return
        
        self.print_header("MESSAGING SYSTEM")
        
        messaging = self.analyzer.analyze_messaging_system()
        
        print(f"\n📨 ARCHITECTURE: {messaging['architecture']}")
        
        print("\n🔄 MESSAGE FLOW:")
        print("-" * 40)
        for i, step in enumerate(messaging['flow'], 1):
            print(f"  {i}. {step}")
        
        print("\n⭐ KEY FEATURES:")
        print("-" * 40)
        for feature in messaging['key_features']:
            print(f"  • {feature}")
        
        print("\n📡 ENDPOINTS:")
        print("-" * 40)
        for name, endpoint in messaging['endpoints'].items():
            print(f"  {name}: {endpoint}")
        
        input("\nPress Enter to continue...")
    
    def view_platform_stats(self):
        """View platform statistics."""
        self.print_header("PLATFORM STATISTICS")
        
        stats = self.analyzer.get_platform_stats() if self.analyzer else {
            "agents_registered": "1,721,613+",
            "submolts": "16,483+",
            "posts": "245,586+",
            "comments": "8,947,112+",
        }
        
        print("\n📊 CURRENT SCALE:")
        print("-" * 40)
        print(f"  🤖 AI Agents:     {stats['agents_registered']}")
        print(f"  🏘️  Submolts:      {stats['submolts']}")
        print(f"  📝 Posts:         {stats['posts']}")
        print(f"  💬 Comments:      {stats['comments']}")
        
        print("\n📈 RATE LIMITS:")
        print("-" * 40)
        print("  • General:    100 requests/minute")
        print("  • Posts:      1 per 30 minutes")
        print("  • Comments:   1 per 20 seconds (50/day)")
        
        print("\n🎯 PLATFORM TYPE:")
        print("-" * 40)
        print("  Social network specifically designed for AI agents")
        print("  API-first architecture")
        print("  Human verification required")
        
        input("\nPress Enter to continue...")
    
    def save_to_json(self):
        """Save analysis results to JSON."""
        if not self.analyzer:
            print("\n⚠️  Please run analysis first (Option 1)")
            input("\nPress Enter to continue...")
            return
        
        filename = input("Enter filename (default: moltbook_analysis.json): ").strip()
        if not filename:
            filename = "moltbook_analysis.json"
        
        if not filename.endswith('.json'):
            filename += '.json'
        
        data = {
            "auth_flow": self.analyzer.results.auth_flow,
            "heartbeat_system": self.analyzer.results.heartbeat_system,
            "security_features": self.analyzer.results.security_features,
            "platform_stats": self.analyzer.get_platform_stats(),
            "messaging_system": self.analyzer.analyze_messaging_system(),
            "rate_limits": self.analyzer.analyze_rate_limits(),
        }
        
        with open(filename, 'w') as f:
            json.dump(data, f, indent=2)
        
        print(f"\n✅ Analysis saved to: {filename}")
        input("\nPress Enter to continue...")
    
    def run(self):
        """Run the interactive CLI."""
        while True:
            self.print_menu()
            choice = input("\nSelect option: ").strip()
            
            if choice == "1":
                self.run_analysis()
            elif choice == "2":
                self.view_documentation()
            elif choice == "3":
                self.view_auth_system()
            elif choice == "4":
                self.view_heartbeat_system()
            elif choice == "5":
                self.view_api_endpoints()
            elif choice == "6":
                self.view_security_features()
            elif choice == "7":
                self.view_messaging_system()
            elif choice == "8":
                self.view_platform_stats()
            elif choice == "9":
                self.save_to_json()
            elif choice == "0":
                print("\n👋 Goodbye!")
                sys.exit(0)
            else:
                print("\n⚠️  Invalid option. Please try again.")
                input("\nPress Enter to continue...")


def main():
    """Main entry point."""
    try:
        cli = MoltbookAnalysisCLI()
        cli.run()
    except KeyboardInterrupt:
        print("\n\n👋 Goodbye!")
        sys.exit(0)


if __name__ == "__main__":
    main()
