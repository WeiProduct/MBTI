import SwiftUI

struct APIDebugView: View {
    @State private var isChecking = false
    @State private var testResult = ""
    private let apiManager = APIKeyManager.shared
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Current Configuration
                VStack(alignment: .leading, spacing: 10) {
                    Text("Current Configuration")
                        .font(.headline)
                    
                    HStack {
                        Text("Mode:")
                            .fontWeight(.medium)
                        Label("Proxy (Secure)", systemImage: "lock.shield.fill")
                            .foregroundColor(.green)
                    }
                    
                    HStack {
                        Text("Endpoint:")
                            .fontWeight(.medium)
                        Text(apiManager.openAIEndpoint)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                // Test Connection Button
                Button(action: testConnection) {
                    if isChecking {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        Text("Test Connection")
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(isChecking)
                
                // Test Results
                if !testResult.isEmpty {
                    ScrollView {
                        Text(testResult)
                            .font(.system(.caption, design: .monospaced))
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                    }
                    .frame(maxHeight: 200)
                }
                
                // Instructions
                VStack(alignment: .leading, spacing: 10) {
                    Text("Troubleshooting Steps:")
                        .font(.headline)
                    
                    Text("1. Check if Vercel proxy is deployed and accessible")
                    Text("2. Ensure Vercel deployment is not behind authentication")
                    Text("3. Verify OPENAI_API_KEY is set in Vercel environment")
                    Text("4. Check Vercel deployment logs for errors")
                }
                .font(.caption)
                .foregroundColor(.gray)
                .padding()
                
                Spacer()
            }
            .padding()
            .navigationTitle("API Debug")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func testConnection() {
        isChecking = true
        testResult = ""
        
        Task {
            var results = ["=== API Connection Test ===\n"]
            
            // Test proxy endpoint
            results.append("\nTesting Proxy Endpoint...")
            results.append("URL: \(apiManager.openAIEndpoint)")
            
            do {
                let proxyURL = URL(string: apiManager.openAIEndpoint)!
                var request = URLRequest(url: proxyURL)
                request.httpMethod = "POST"
                
                // Set headers using APIKeyManager
                let headers = apiManager.buildHeaders()
                for (key, value) in headers {
                    request.setValue(value, forHTTPHeaderField: key)
                }
                
                let testBody: [String: Any] = [
                    "model": "gpt-3.5-turbo",
                    "messages": [
                        ["role": "system", "content": "You are a test assistant."],
                        ["role": "user", "content": "Say 'API test successful' if you receive this."]
                    ],
                    "max_tokens": 20
                ]
                
                request.httpBody = try JSONSerialization.data(withJSONObject: testBody)
                
                let (data, response) = try await URLSession.shared.data(for: request)
                
                if let httpResponse = response as? HTTPURLResponse {
                    results.append("Status Code: \(httpResponse.statusCode)")
                    
                    if httpResponse.statusCode == 200 {
                        results.append("✅ Proxy connection successful!")
                        
                        if (try? JSONSerialization.jsonObject(with: data) as? [String: Any]) != nil {
                            results.append("Response: Valid JSON received")
                        }
                    } else {
                        results.append("❌ Error: HTTP \(httpResponse.statusCode)")
                        
                        if let responseString = String(data: data, encoding: .utf8) {
                            results.append("Response: \(responseString.prefix(200))...")
                            
                            if responseString.contains("<html") || responseString.contains("<!DOCTYPE") {
                                results.append("⚠️ Received HTML instead of JSON - Vercel authentication wall detected!")
                            }
                        }
                    }
                }
            } catch {
                results.append("❌ Connection failed: \(error.localizedDescription)")
            }
            
            
            await MainActor.run {
                testResult = results.joined(separator: "\n")
                isChecking = false
            }
        }
    }
}

#Preview {
    APIDebugView()
}