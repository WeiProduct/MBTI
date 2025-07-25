# AIMBTI Deployment Guide

## 🚀 Complete Deployment Steps

### Step 1: Deploy Vercel Proxy Server

1. **Navigate to proxy directory**
   ```bash
   cd vercel-proxy
   ```

2. **Run deployment script**
   ```bash
   ./deploy.sh
   ```
   
   Or manually:
   ```bash
   vercel
   vercel env add OPENAI_API_KEY
   vercel --prod
   ```

3. **Note your deployment URL**
   - Example: `https://aimbti-api-proxy.vercel.app`

### Step 2: Update iOS App Configuration

1. **Open APIConfiguration.swift**
   ```
   /AIMBTI/Configuration/APIConfiguration.swift
   ```

2. **Update the proxy URL** (line 12)
   ```swift
   static let proxyBaseURL = "https://your-actual-vercel-url.vercel.app"
   ```

3. **Rebuild the app**
   ```bash
   xcodebuild -scheme AIMBTI -configuration Release build
   ```

### Step 3: Test the Integration

1. **Run the app in simulator**
2. **Complete a test using debug mode**
3. **Navigate to Personal Advisor tab**
4. **Send a test message**

## 🔍 Verification Checklist

- [ ] Vercel proxy deployed successfully
- [ ] Environment variable OPENAI_API_KEY set in Vercel
- [ ] iOS app APIConfiguration.swift updated with correct URL
- [ ] App builds without errors
- [ ] Personal Advisor chat feature works

## 🛠 Troubleshooting

### Proxy Issues
1. **Check Vercel logs**
   ```bash
   vercel logs
   ```

2. **Test proxy directly**
   ```bash
   curl -X POST https://your-proxy.vercel.app/api/chat \
     -H "Content-Type: application/json" \
     -d '{"messages": [{"role": "user", "content": "Hello"}]}'
   ```

### iOS App Issues
1. **Check console logs in Xcode**
2. **Verify proxy URL is correct**
3. **Ensure network permissions are enabled**

## 🔒 Security Reminders

1. **Never commit API keys**
   - Use `.gitignore` to exclude `.env` files
   - Store keys only in Vercel environment variables

2. **Monitor usage**
   - Check OpenAI dashboard regularly
   - Set up usage alerts

3. **Rotate keys periodically**
   - Generate new API keys monthly
   - Update Vercel environment variables

## 📱 App Store Deployment (Future)

When ready for App Store:

1. **Switch to Release configuration**
2. **Ensure proxy URL is production URL**
3. **Remove all DEBUG code**
4. **Test thoroughly on real devices**
5. **Follow Apple's submission guidelines**

## 📊 Monitoring

### Vercel Dashboard
- Function execution logs
- Error tracking
- Usage metrics

### OpenAI Dashboard
- API usage
- Cost tracking
- Rate limit status

### App Analytics
- User engagement
- Feature usage
- Crash reports

## 🚨 Emergency Procedures

### If API key is compromised:
1. Immediately revoke key in OpenAI dashboard
2. Generate new key
3. Update Vercel environment variable
4. Redeploy proxy

### If rate limited:
1. Check OpenAI rate limits
2. Implement request throttling
3. Consider upgrading OpenAI plan

### If proxy is down:
1. Check Vercel status page
2. Review function logs
3. Redeploy if necessary

## 📞 Support

For issues with:
- **Vercel**: https://vercel.com/support
- **OpenAI**: https://help.openai.com
- **iOS Development**: Apple Developer Forums

---

Last updated: 2025-07-25