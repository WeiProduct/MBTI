import SwiftUI

struct DeveloperSettingsView: View {
    private let apiManager = APIKeyManager.shared
    
    var body: some View {
        Form {
            // API Configuration Info
            Section {
                HStack {
                    Text("API Mode:")
                    Spacer()
                    Label("Proxy (Secure)", systemImage: "lock.shield.fill")
                        .foregroundColor(.green)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Current Endpoint:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(apiManager.openAIEndpoint)
                        .font(.caption)
                        .fontDesign(.monospaced)
                        .foregroundColor(.blue)
                }
            } header: {
                Text("API Configuration")
            } footer: {
                Text("Using secure proxy to protect API keys")
            }
            
            Section {
                NavigationLink(destination: APIDebugView()) {
                    Label("API Connection Test", systemImage: "network")
                }
            } header: {
                Text("Debugging")
            }
        }
        .navigationTitle("Developer Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        DeveloperSettingsView()
    }
}