import Foundation

/// Manages API endpoints - Proxy Only Mode
/// Always uses proxy mode to protect API keys
public class APIKeyManager {
    public static let shared = APIKeyManager()
    
    private init() {}
    
    // MARK: - OpenAI Configuration
    
    /// No API key needed - proxy handles authentication
    public var openAIKey: String? {
        return nil
    }
    
    /// Returns the OpenAI proxy endpoint
    public var openAIEndpoint: String {
        return APIConfiguration.openAIProxyEndpoint
    }
    
    /// Always using proxy mode
    public var shouldUseProxy: Bool {
        return true
    }
    
    /// Builds headers for API requests
    public func buildHeaders() -> [String: String] {
        return ["Content-Type": "application/json"]
    }
    
    // MARK: - Legacy Support
    
    /// Legacy method - no-op since we only use proxy mode
    public func setProxyMode(_ useProxy: Bool) {
        // Always proxy mode, ignore parameter
    }
    
    /// Direct mode is never available
    public var isDirectModeAvailable: Bool {
        return false
    }
}