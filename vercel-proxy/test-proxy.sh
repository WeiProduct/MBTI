#!/bin/bash

echo "🧪 Testing AIMBTI API Proxy"
echo "=========================="
echo ""

PROXY_URL="https://aimbti-api-proxy-45lx1nw03-weis-projects-90c8634a.vercel.app"

echo "Testing endpoint: $PROXY_URL/api/chat"
echo ""

# Test the proxy
curl -X POST "$PROXY_URL/api/chat" \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
      {"role": "system", "content": "You are a helpful assistant."},
      {"role": "user", "content": "Say hello in one word"}
    ],
    "max_tokens": 10
  }' \
  --silent \
  --show-error \
  | python3 -m json.tool

echo ""
echo "Test complete!"