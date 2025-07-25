# Vercel Proxy Deployment Guide

## Prerequisites
- Vercel account (free tier is sufficient)
- Vercel CLI installed: `npm i -g vercel`

## Deployment Steps

### 1. Login to Vercel
```bash
vercel login
```

### 2. Deploy to Vercel
From the `vercel-proxy` directory:
```bash
vercel
```

Follow the prompts:
- Confirm deployment settings
- Choose project name (e.g., `aimbti-api-proxy`)
- Link to existing project or create new

### 3. Set Environment Variables
```bash
# Set your OpenAI API key
vercel env add OPENAI_API_KEY
```

When prompted:
- Enter your OpenAI API key value
- Select all environments (Production, Preview, Development)

### 4. Deploy to Production
```bash
vercel --prod
```

### 5. Update iOS App Configuration
After deployment, update `/AIMBTI/Configuration/APIConfiguration.swift`:
```swift
static let proxyBaseURL = "https://your-project-name.vercel.app"
```

## Security Notes
- Never commit API keys to git
- Use environment variables only
- Monitor API usage in OpenAI dashboard
- Consider adding rate limiting for production

## Testing the Proxy
```bash
curl -X POST https://your-project-name.vercel.app/api/chat \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
      {"role": "system", "content": "You are a helpful assistant."},
      {"role": "user", "content": "Hello!"}
    ]
  }'
```

## Monitoring
- Check Vercel dashboard for function logs
- Monitor API usage in OpenAI dashboard
- Set up alerts for errors or high usage