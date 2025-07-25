import SwiftUI

struct DebugMenuView: View {
    @State private var isExpanded = false
    @State private var dragOffset = CGSize.zero
    @State private var position = CGPoint(x: 50, y: 200)
    
    var body: some View {
        #if DEBUG
        VStack(spacing: 12) {
            // Main Debug Button
            Button(action: {
                withAnimation(.spring()) {
                    isExpanded.toggle()
                }
            }) {
                Image(systemName: isExpanded ? "xmark" : "hammer.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(Theme.primaryColor)
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                    )
            }
            .scaleEffect(isExpanded ? 1.1 : 1.0)
            
            // Debug Options
            if isExpanded {
                VStack(spacing: 8) {
                    DebugMenuButton(
                        icon: "terminal",
                        title: "Console",
                        action: {
                            DebugConsoleManager.shared.toggle()
                            isExpanded = false
                        }
                    )
                    
                    DebugMenuButton(
                        icon: "network",
                        title: "Network",
                        action: {
                            ILog("Network debugging not implemented yet")
                            isExpanded = false
                        }
                    )
                    
                    DebugMenuButton(
                        icon: "doc.text",
                        title: "Logs",
                        action: {
                            exportLogs()
                            isExpanded = false
                        }
                    )
                    
                    DebugMenuButton(
                        icon: "info.circle",
                        title: "Info",
                        action: {
                            showDebugInfo()
                            isExpanded = false
                        }
                    )
                    
                    DebugMenuButton(
                        icon: "ant.circle",
                        title: "Test",
                        action: {
                            runDebugTests()
                            isExpanded = false
                        }
                    )
                }
                .transition(.asymmetric(
                    insertion: .scale.combined(with: .opacity),
                    removal: .scale.combined(with: .opacity)
                ))
            }
        }
        .position(
            x: position.x + dragOffset.width,
            y: position.y + dragOffset.height
        )
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragOffset = value.translation
                }
                .onEnded { value in
                    position.x += value.translation.width
                    position.y += value.translation.height
                    dragOffset = .zero
                    
                    // Keep within screen bounds
                    let screenBounds = UIScreen.main.bounds
                    position.x = max(30, min(screenBounds.width - 30, position.x))
                    position.y = max(100, min(screenBounds.height - 100, position.y))
                }
        )
        #endif
    }
    
    #if DEBUG
    private func exportLogs() {
        let logs = DebugConsoleManager.shared.logs
        var logText = "AIMBTI Debug Logs - \(Date())\n\n"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        
        for log in logs {
            logText += "\(formatter.string(from: log.timestamp)) [\(log.level.rawValue)] [\(log.category)] \(log.message)\n"
            logText += "  File: \(log.file):\(log.line) - \(log.function)\n\n"
        }
        
        // Save to documents directory
        if let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileName = "debug_logs_\(Date().timeIntervalSince1970).txt"
            let filePath = documentsPath.appendingPathComponent(fileName)
            
            do {
                try logText.write(to: filePath, atomically: true, encoding: .utf8)
                ILog("Logs exported to: \(fileName)")
            } catch {
                ELog("Failed to export logs: \(error)")
            }
        }
    }
    
    private func showDebugInfo() {
        var info = "Debug Information\n"
        info += "================\n"
        info += "App Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown")\n"
        info += "Build: \(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown")\n"
        info += "Device: \(UIDevice.current.model)\n"
        info += "iOS: \(UIDevice.current.systemVersion)\n"
        info += "Language: \(LanguageManager.shared.currentLanguage.rawValue)\n"
        info += "API URL: \(APIKeyManager.shared.openAIEndpoint)\n"
        info += "Using Proxy: true\n"
        
        ILog(info)
    }
    
    private func runDebugTests() {
        DLog("Starting debug tests...")
        
        // Test different log levels
        DLog("This is a debug message")
        ILog("This is an info message")
        WLog("This is a warning message")
        ELog("This is an error message")
        
        // Test categories
        DebugConsoleManager.shared.log("Network request started", level: .info, category: "Network")
        DebugConsoleManager.shared.log("Database query executed", level: .debug, category: "Database")
        DebugConsoleManager.shared.log("UI rendered", level: .debug, category: "UI")
        
        // Test long message
        let longMessage = "This is a very long message that should wrap properly in the debug console. " +
                         "It contains multiple sentences and should demonstrate how the console handles " +
                         "text that exceeds the width of the console window."
        ILog(longMessage)
        
        DLog("Debug tests completed!")
    }
    #endif
}

// MARK: - Debug Menu Button
struct DebugMenuButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(title)
                    .font(.system(size: 10))
            }
            .foregroundColor(.white)
            .frame(width: 50, height: 50)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.7))
                    .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
            )
        }
    }
}

// MARK: - Debug Menu Modifier
struct DebugMenuModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(
                DebugMenuView()
                    .allowsHitTesting(true)
            )
    }
}

extension View {
    func withDebugMenu() -> some View {
        #if DEBUG
        modifier(DebugMenuModifier())
        #else
        self
        #endif
    }
}