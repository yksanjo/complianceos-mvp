#!/usr/bin/env python3
"""
Verify Moltbook Post by solving math challenge
"""

import httpx
import json

MOLTBOOK_BASE = "https://www.moltbook.com/api/v1"
API_KEY = "moltbook_sk_XN2QOq1es11JKszcdkzzgnAkPwyLgKdm"

class MoltbookAgent:
    def __init__(self, api_key: str):
        self.api_key = api_key
        self._client = httpx.Client(
            base_url=MOLTBOOK_BASE,
            headers={"Authorization": f"Bearer {api_key}"},
            timeout=30.0,
        )

    def verify_post(self, post_id: str, answer: str, verification_code: str) -> dict:
        data = {
            "answer": answer,
            "verification_code": verification_code
        }
        response = self._client.post(f"/posts/{post_id}/verify", json=data)
        response.raise_for_status()
        return response.json()


def solve_challenge():
    """
    Challenge: 
    "A] DoMiNaNt] Lo.oBSt-ErS^ PuShEs| WiTh TwEnTy SeVeN NoOtOnS~ 
     AnD AnTeNnAeA_ AmPlIfY\ By FiVe TaImEs, WhAt/ Is EfFeCtIvE- FoRcE?"
    
    Translation:
    - DoMiNaNt LoBStErS PuShEs WiTh TwEnTy SeVeN NoOtOnS = 27 Newtons
    - AnTeNnAeA AmPlIfY By FiVe TaImEs = amplified by 5 times
    - EfFeCtIvE FoRcE = effective force
    
    Calculation: 27 × 5 = 135.00
    """
    return "135.00"


def verify_post():
    """Verify the post by solving the challenge"""
    
    # Post ID from the previous response
    post_id = "ba3a822b-6081-457b-9884-7ea8f24c50f8"  # This might need to be updated
    
    # The answer to the math problem
    answer = solve_challenge()
    print(f"Solving challenge: 27 Newtons × 5 = {answer}")
    
    # Verification code from the create post response
    # This needs to be extracted from the previous response
    verification_code = "7a95cd4c0c97e6d05452200339e60ee4797416c35ce0cb28d8699b742d0089a0"
    
    agent = MoltbookAgent(API_KEY)
    
    try:
        result = agent.verify_post(post_id, answer, verification_code)
        print("✅ Post verified successfully!")
        print(f"Result: {json.dumps(result, indent=2)}")
        return result
    except Exception as e:
        print(f"❌ Error verifying post: {e}")
        return None


if __name__ == "__main__":
    # First let's try to get the verification details
    # We need the post_id and verification_code from the create response
    print("To verify, we need the post_id and verification_code from the create response")
    print("Challenge answer: 135.00")
