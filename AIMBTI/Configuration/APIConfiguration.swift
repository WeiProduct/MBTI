import Foundation

// MARK: - API Configuration
// ⚠️ SECURITY WARNING: Never hardcode API keys in your app!
// This configuration uses a proxy server to protect your API keys

struct APIConfiguration {
    // MARK: - Proxy Configuration Only
    
    /// Your Vercel proxy base URL
    static let proxyBaseURL = "https://aimbti-api-proxy.vercel.app"
    
    /// Proxy endpoints
    static let chatProxyEndpoint = "\(proxyBaseURL)/api/openai"
    static let openAIProxyEndpoint = "\(proxyBaseURL)/api/openai"
    
    // MARK: - Configuration Methods
    
    // MARK: - Legacy Methods (Deprecated - Use APIKeyManager instead)
    
    @available(*, deprecated, message: "Use APIKeyManager.shared.openAIEndpoint instead")
    static func getChatEndpoint() -> String {
        return APIKeyManager.shared.openAIEndpoint
    }
    
    @available(*, deprecated, message: "Use APIKeyManager.shared.openAIKey instead")
    static func getAPIKey() -> String? {
        return APIKeyManager.shared.openAIKey
    }
    
    @available(*, deprecated, message: "Use APIKeyManager.shared.shouldUseProxy instead")
    static var isUsingProxy: Bool {
        return APIKeyManager.shared.shouldUseProxy
    }
}

// MARK: - API Headers Builder

extension APIConfiguration {
    /// Build headers for API requests
    @available(*, deprecated, message: "Use APIKeyManager.shared.buildHeaders() instead")
    static func buildHeaders(contentType: String = "application/json") -> [String: String] {
        return APIKeyManager.shared.buildHeaders()
    }
}

// MARK: - Security Notice

/*
 🔒 SECURITY BEST PRACTICES:
 
 1. NEVER hardcode API keys in your source code
 2. Use environment variables for development
 3. Use a proxy server for production
 4. Rotate API keys regularly
 5. Monitor API usage for unusual activity
 
 📝 SETUP INSTRUCTIONS:
 
 1. Deploy proxy server to Vercel (see /api folder)
 2. Update proxyBaseURL with your Vercel URL
 3. Add environment variables in Vercel dashboard
 4. For development, add OPENAI_API_KEY to Xcode environment
 
 ⚠️ IMPORTANT: If you accidentally exposed an API key:
 1. Revoke it immediately in your OpenAI dashboard
 2. Generate a new key
 3. Update your proxy server environment variables
 */