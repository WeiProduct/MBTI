#!/bin/bash

echo "🔑 Adding OpenAI API Key to Vercel"
echo "=================================="
echo ""
echo "Please enter your OpenAI API key:"
echo "(It will be hidden while typing)"
echo ""

# Read API key securely
read -s -p "OpenAI API Key: " API_KEY
echo ""

if [ -z "$API_KEY" ]; then
    echo "❌ Error: API key cannot be empty"
    exit 1
fi

# Add to Vercel
echo ""
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