# AIMBTI API Proxy Server

This is a secure proxy server for the AIMBTI iOS app to safely access OpenAI API without exposing API keys in the client application.

## 🚀 Quick Start

1. **Deploy to Vercel**
   ```bash
   ./deploy.sh
   ```

2. **Manual Deployment**
   ```bash
   # Install Vercel CLI
   npm i -g vercel
   
   # Login to Vercel
   vercel login
   
   # Deploy
   vercel
   
   # Set environment variable
   vercel env add OPENAI_API_KEY
   
   # Deploy to production
   vercel --prod
   ```

## 🔧 Configuration

### Environment Variables
- `OPENAI_API_KEY`: Your OpenAI API key (required)

### iOS App Configuration
After deployment, update your iOS app configuration:

```swift
// In APIConfiguration.swift
static let proxyBaseURL = "https://your-project.vercel.app"
```

## 📁 Project Structure

```
vercel-proxy/
├── api/
│   └── chat.js         # Chat endpoint handler
├── package.json        # Node.js configuration
├── vercel.json        # Vercel configuration
├── .gitignore         # Git ignore file
├── deploy.sh          # Deployment script
└── README.md          # This file
```

## 🔒 Security Features

- API key stored securely in environment variables
- CORS headers configured for mobile app access
- Error messages sanitized to prevent information leakage
- Rate limiting handled by Vercel platform

## 🧪 Testing the Proxy

Test your deployed proxy with curl:

```bash
curl -X POST https://your-project.vercel.app/api/chat \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
      {"role": "system", "content": "You are a helpful assistant."},
      {"role": "user", "content": "Hello!"}
    ]
  }'
```

## 📊 Monitoring

- **Vercel Dashboard**: Monitor function logs and usage
- **OpenAI Dashboard**: Track API usage and costs
- **Error Tracking**: Check Vercel function logs for errors

## ⚠️ Important Notes

1. **Free Tier Limits**: Vercel free tier includes 100GB bandwidth and 100 hours of function execution per month
2. **Cold Starts**: First request after inactivity may be slower
3. **API Costs**: Monitor your OpenAI usage to control costs

## 🛠 Troubleshooting

### Common Issues

1. **"OpenAI API key not configured"**
   - Ensure OPENAI_API_KEY is set in Vercel environment variables
   - Redeploy after adding environment variables

2. **CORS Errors**
   - Check that your iOS app is making requests to the correct URL
   - Verify CORS headers in chat.js

3. **Rate Limit Errors**
   - Check OpenAI dashboard for rate limits
   - Implement request throttling in your iOS app

## 📚 Resources

- [Vercel Documentation](https://vercel.com/docs)
- [OpenAI API Reference](https://platform.openai.com/docs)
- [AIMBTI iOS App Repository](../AIMBTI)

## 📝 License

This proxy server is part of the AIMBTI project.