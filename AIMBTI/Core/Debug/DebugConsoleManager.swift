import Foundation
import SwiftUI

// MARK: - Debug Log Entry
struct DebugLogEntry: Identifiable {
    let id = UUID()
    let timestamp: Date
    let level: LogLevel
    let category: String
    let message: String
    let file: String
    let function: String
    let line: Int
    
    enum LogLevel: String, CaseIterable {
        case debug = "DEBUG"
        case info = "INFO"
        case warning = "WARNING"
        case error = "ERROR"
        
        var color: Color {
            switch self {
            case .debug: return .gray
            case .info: return .blue
            case .warning: return .orange
            case .error: return .red
            }
        }
        
        var icon: String {
            switch self {
            case .debug: return "ant.circle"
            case .info: return "info.circle"
            case .warning: return "exclamationmark.triangle"
            case .error: return "xmark.circle"
            }
        }
    }
}

// MARK: - Debug Console Manager
class DebugConsoleManager: ObservableObject {
    static let shared = DebugConsoleManager()
    
    @Published var logs: [DebugLogEntry] = []
    @Published var isVisible: Bool = false
    @Published var isMinimized: Bool = false
    @Published var filterLevel: DebugLogEntry.LogLevel? = nil
    @Published var searchText: String = ""
    
    private let maxLogs = 500
    
    private init() {
        #if DEBUG
        // Auto-show console when error occurs
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleError),
            name: .debugError,
            object: nil
        )
        #endif
    }
    
    // MARK: - Logging Methods
    
    func log(
        _ message: String,
        level: DebugLogEntry.LogLevel = .info,
        category: String = "General",
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        #if DEBUG
        let entry = DebugLogEntry(
            timestamp: Date(),
            level: level,
            category: category,
            message: message,
            file: URL(fileURLWithPath: file).lastPathComponent,
            function: function,
            line: line
        )
        
        DispatchQueue.main.async {
            self.logs.append(entry)
            
            // Keep only the most recent logs
            if self.logs.count > self.maxLogs {
                self.logs.removeFirst(self.logs.count - self.maxLogs)
            }
            
            // Auto-show on error
            if level == .error && !self.isVisible {
                self.show()
            }
        }
        #endif
    }
    
    func debug(_ message: String, category: String = "Debug", file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .debug, category: category, file: file, function: function, line: line)
    }
    
    func info(_ message: String, category: String = "Info", file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .info, category: category, file: file, function: function, line: line)
    }
    
    func warning(_ message: String, category: String = "Warning", file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .warning, category: category, file: file, function: function, line: line)
    }
    
    func error(_ message: String, category: String = "Error", file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .error, category: category, file: file, function: function, line: line)
    }
    
    // MARK: - Console Control
    
    func show() {
        withAnimation(.spring()) {
            isVisible = true
            isMinimized = false
        }
    }
    
    func hide() {
        withAnimation(.spring()) {
            isVisible = false
        }
    }
    
    func toggle() {
        withAnimation(.spring()) {
            isVisible.toggle()
        }
    }
    
    func minimize() {
        withAnimation(.spring()) {
            isMinimized = true
        }
    }
    
    func maximize() {
        withAnimation(.spring()) {
            isMinimized = false
        }
    }
    
    func clear() {
        logs.removeAll()
    }
    
    // MARK: - Filtered Logs
    
    var filteredLogs: [DebugLogEntry] {
        logs.filter { log in
            let matchesLevel = filterLevel == nil || log.level == filterLevel
            let matchesSearch = searchText.isEmpty || 
                log.message.localizedCaseInsensitiveContains(searchText) ||
                log.category.localizedCaseInsensitiveContains(searchText)
            return matchesLevel && matchesSearch
        }
    }
    
    // MARK: - Private Methods
    
    @objc private func handleError(_ notification: Notification) {
        if let error = notification.userInfo?["error"] as? Error {
            self.error(error.localizedDescription, category: "System")
        }
    }
}

// MARK: - Notification Extension
extension Notification.Name {
    static let debugError = Notification.Name("DebugConsoleError")
}

// MARK: - Global Debug Functions
#if DEBUG
func DLog(_ message: String, category: String = "Debug", file: String = #file, function: String = #function, line: Int = #line) {
    DebugConsoleManager.shared.debug(message, category: category, file: file, function: function, line: line)
}

func ILog(_ message: String, category: String = "Info", file: String = #file, function: String = #function, line: Int = #line) {
    DebugConsoleManager.shared.info(message, category: category, file: file, function: function, line: line)
}

func WLog(_ message: String, category: String = "Warning", file: String = #file, function: String = #function, line: Int = #line) {
    DebugConsoleManager.shared.warning(message, category: category, file: file, function: function, line: line)
}

func ELog(_ message: String, category: String = "Error", file: String = #file, function: String = #function, line: Int = #line) {
    DebugConsoleManager.shared.error(message, category: category, file: file, function: function, line: line)
}
#else
func DLog(_ message: String, category: String = "Debug", file: String = #file, function: String = #function, line: Int = #line) {}
func ILog(_ message: String, category: String = "Info", file: String = #file, function: String = #function, line: Int = #line) {}
func WLog(_ message: String, category: String = "Warning", file: String = #file, function: String = #function, line: Int = #line) {}
func ELog(_ message: String, category: String = "Error", file: String = #file, function: String = #function, line: Int = #line) {}
#endif