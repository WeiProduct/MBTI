# API Key Setup Guide

## 🔑 Quick Setup

### Step 1: Add Your API Key to Vercel

Run this command and paste your OpenAI API key when prompted:

```bash
cd /Users/weifu/Desktop/AIMBTI/vercel-proxy
echo "YOUR_OPENAI_API_KEY_HERE" | vercel env add OPENAI_API_KEY production
```

### Step 2: Redeploy to Production

```bash
vercel --prod
```

### Step 3: Switch iOS App to Production Mode

Edit `/AIMBTI/Configuration/APIConfiguration.swift` and remove the DEBUG condition:

```swift
// Change from:
#if DEBUG
static let chatProxyEndpoint = "\(proxyBaseURL)/api/chat-test"
#else
static let chatProxyEndpoint = "\(proxyBaseURL)/api/chat"
#endif

// To:
static let chatProxyEndpoint = "\(proxyBaseURL)/api/chat"
```

### Step 4: Rebuild and Test

1. Clean build folder in Xcode: `Shift + Cmd + K`
2. Build and run: `Cmd + R`
3. Test the chat feature

## 🧪 Current Test Mode

The app is currently using a test endpoint that returns mock responses. This allows you to:
- Test the UI functionality
- Verify the proxy connection
- Check that all components work together

Once you add your API key, you'll get real AI responses.

## 🔐 Security Note

Your API key is:
- Never stored in the iOS app
- Only stored in Vercel's secure environment
- Not exposed to end users
- Protected by the proxy server

---

**Remember**: The API key you shared earlier should be added using the secure method above, not hardcoded anywhere.