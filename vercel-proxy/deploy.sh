#!/bin/bash

# Vercel Proxy Deployment Script for AIMBTI

echo "🚀 AIMBTI API Proxy Deployment Script"
echo "====================================="

# Check if Vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo "❌ Vercel CLI not found. Installing..."
    npm i -g vercel
fi

# Check if we're in the correct directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: package.json not found. Please run this script from the vercel-proxy directory."
    exit 1
fi

echo ""
echo "📋 Prerequisites:"
echo "1. You need a Vercel account (free tier is sufficient)"
echo "2. You need your OpenAI API key ready"
echo ""
read -p "Press Enter to continue or Ctrl+C to cancel..."

echo ""
echo "🔐 Step 1: Login to Vercel"
vercel login

echo ""
echo "📦 Step 2: Deploy to Vercel"
echo "When prompted:"
echo "- Set up and deploy: Yes"
echo "- Which scope: Select your account"
echo "- Link to existing project: No (create new)"
echo "- Project name: aimbti-api-proxy (or your preferred name)"
echo "- Directory: ./ (current directory)"
echo "- Override settings: No"
echo ""
read -p "Press Enter to start deployment..."

vercel

echo ""
echo "🔑 Step 3: Set Environment Variables"
echo "You need to add your OpenAI API key to Vercel."
echo ""
echo "Option 1: Use Vercel CLI (recommended)"
echo "Run: vercel env add OPENAI_API_KEY"
echo ""
echo "Option 2: Use Vercel Dashboard"
echo "1. Go to https://vercel.com/dashboard"
echo "2. Select your project"
echo "3. Go to Settings > Environment Variables"
echo "4. Add OPENAI_API_KEY with your key value"
echo ""
read -p "Press Enter after adding the environment variable..."

echo ""
echo "🚀 Step 4: Deploy to Production"
vercel --prod

echo ""
echo "✅ Deployment Complete!"
echo ""
echo "📝 Next Steps:"
echo "1. Copy your production URL (e.g., https://aimbti-api-proxy.vercel.app)"
echo "2. Update /AIMBTI/Configuration/APIConfiguration.swift:"
echo "   static let proxyBaseURL = \"YOUR_VERCEL_URL_HERE\""
echo "3. Rebuild your iOS app"
echo ""
echo "🔒 Security Reminder:"
echo "- Never commit API keys to Git"
echo "- Keep your Vercel deployment private"
echo "- Monitor API usage in OpenAI dashboard"