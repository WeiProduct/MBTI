#!/bin/bash

echo "🔑 Adding OpenAI API Key to Vercel"
echo "=================================="
echo ""

# Check if API key is provided as argument
if [ -z "$1" ]; then
    echo "❌ Error: Please provide API key as argument"
    echo "Usage: ./add-api-key-direct.sh YOUR_API_KEY"
    exit 1
fi

API_KEY="$1"

# Add to Vercel
echo "Adding API key to Vercel environment..."
vercel env add OPENAI_API_KEY production <<< "$API_KEY"

echo ""
echo "✅ API key added successfully!"
echo ""
echo "🚀 Now deploying to production..."
vercel --prod

echo ""
echo "✅ Deployment complete!"
echo ""
echo "Your production URL is ready to use."