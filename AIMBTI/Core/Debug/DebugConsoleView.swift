import SwiftUI

struct DebugConsoleView: View {
    @StateObject private var consoleManager = DebugConsoleManager.shared
    @State private var dragOffset = CGSize.zero
    @State private var position = CGPoint(x: UIScreen.main.bounds.width - 150, y: 100)
    
    var body: some View {
        #if DEBUG
        Group {
            if consoleManager.isVisible {
                if consoleManager.isMinimized {
                    MinimizedConsoleView(position: $position, dragOffset: $dragOffset)
                } else {
                    ExpandedConsoleView()
                }
            }
        }
        .transition(.asymmetric(
            insertion: .scale.combined(with: .opacity),
            removal: .scale.combined(with: .opacity)
        ))
        #endif
    }
}

// MARK: - Minimized Console View
#if DEBUG
struct MinimizedConsoleView: View {
    @StateObject private var consoleManager = DebugConsoleManager.shared
    @Binding var position: CGPoint
    @Binding var dragOffset: CGSize
    @State private var showCopied = false
    
    private var errorCount: Int {
        consoleManager.logs.filter { $0.level == .error }.count
    }
    
    private var warningCount: Int {
        consoleManager.logs.filter { $0.level == .warning }.count
    }
    
    private func copyErrorsToClipboard() {
        let errorLogs = consoleManager.logs.filter { $0.level == .error }
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        
        let errorText = errorLogs.map { log in
            "[\(timeFormatter.string(from: log.timestamp))] \(log.message)\n  File: \(log.file):\(log.line)"
        }.joined(separator: "\n\n")
        
        UIPasteboard.general.string = errorText
        
        withAnimation(.easeInOut(duration: 0.2)) {
            showCopied = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut(duration: 0.2)) {
                showCopied = false
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "terminal.fill")
                .font(.system(size: 20))
                .foregroundColor(.white)
            
            if errorCount > 0 {
                HStack(spacing: 2) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 12))
                    Text("\(errorCount)")
                        .font(.system(size: 12, weight: .bold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.red)
                .cornerRadius(10)
                .onLongPressGesture {
                    copyErrorsToClipboard()
                }
            }
            
            if warningCount > 0 {
                HStack(spacing: 2) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 12))
                    Text("\(warningCount)")
                        .font(.system(size: 12, weight: .bold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.orange)
                .cornerRadius(10)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.black.opacity(0.8))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
        .position(
            x: position.x + dragOffset.width,
            y: position.y + dragOffset.height
        )
        .onTapGesture {
            consoleManager.maximize()
        }
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
                    position.x = max(50, min(screenBounds.width - 50, position.x))
                    position.y = max(50, min(screenBounds.height - 50, position.y))
                }
        )
        .overlay(
            Group {
                if showCopied {
                    Text("Copied!")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green)
                        .cornerRadius(8)
                        .transition(.scale.combined(with: .opacity))
                        .offset(y: -35)
                }
            }
        )
    }
}

// MARK: - Expanded Console View
struct ExpandedConsoleView: View {
    @StateObject private var consoleManager = DebugConsoleManager.shared
    @State private var selectedLogId: UUID?
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            ConsoleHeaderView()
            
            // Filter Bar
            ConsoleFilterBar()
            
            // Logs List
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(consoleManager.filteredLogs) { log in
                            LogEntryView(log: log, isSelected: selectedLogId == log.id)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        selectedLogId = selectedLogId == log.id ? nil : log.id
                                    }
                                }
                                .id(log.id)
                        }
                    }
                }
                .onChange(of: consoleManager.filteredLogs.count) { _ in
                    // Auto-scroll to bottom when new log added
                    if let lastLog = consoleManager.filteredLogs.last {
                        withAnimation {
                            proxy.scrollTo(lastLog.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            // Footer
            ConsoleFooterView()
        }
        .frame(maxWidth: 400, maxHeight: 600)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
        .padding()
    }
}

// MARK: - Console Header
struct ConsoleHeaderView: View {
    @StateObject private var consoleManager = DebugConsoleManager.shared
    
    var body: some View {
        HStack {
            Label("Debug Console", systemImage: "terminal.fill")
                .font(.system(size: 16, weight: .semibold))
            
            Spacer()
            
            Button(action: {
                consoleManager.minimize()
            }) {
                Image(systemName: "minus")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                    .frame(width: 24, height: 24)
                    .background(Circle().fill(Color.gray.opacity(0.1)))
            }
            
            Button(action: {
                consoleManager.hide()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                    .frame(width: 24, height: 24)
                    .background(Circle().fill(Color.gray.opacity(0.1)))
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
}

// MARK: - Console Filter Bar
struct ConsoleFilterBar: View {
    @StateObject private var consoleManager = DebugConsoleManager.shared
    
    var body: some View {
        VStack(spacing: 12) {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search logs...", text: $consoleManager.searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !consoleManager.searchText.isEmpty {
                    Button(action: {
                        consoleManager.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            // Level Filters
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    FilterChip(
                        title: "All",
                        isSelected: consoleManager.filterLevel == nil,
                        action: {
                            consoleManager.filterLevel = nil
                        }
                    )
                    
                    ForEach(DebugLogEntry.LogLevel.allCases, id: \.self) { level in
                        FilterChip(
                            title: level.rawValue,
                            color: level.color,
                            isSelected: consoleManager.filterLevel == level,
                            action: {
                                consoleManager.filterLevel = consoleManager.filterLevel == level ? nil : level
                            }
                        )
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.05))
    }
}

// MARK: - Filter Chip
struct FilterChip: View {
    let title: String
    var color: Color = .blue
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(isSelected ? .white : color)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(isSelected ? color : color.opacity(0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        }
    }
}

// MARK: - Log Entry View
struct LogEntryView: View {
    let log: DebugLogEntry
    let isSelected: Bool
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Main log line
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: log.level.icon)
                    .font(.system(size: 14))
                    .foregroundColor(log.level.color)
                    .frame(width: 20)
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(timeFormatter.string(from: log.timestamp))
                            .font(.system(size: 11, weight: .medium, design: .monospaced))
                            .foregroundColor(.gray)
                        
                        Text("[\(log.category)]")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(log.level.color)
                        
                        Spacer()
                    }
                    
                    Text(log.message)
                        .font(.system(size: 13))
                        .foregroundColor(Theme.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            
            // Expanded details
            if isSelected {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("File:")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.gray)
                        Text("\(log.file):\(log.line)")
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundColor(Theme.textSecondary)
                    }
                    
                    HStack {
                        Text("Function:")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.gray)
                        Text(log.function)
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundColor(Theme.textSecondary)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 8)
            }
        }
        .background(
            Rectangle()
                .fill(isSelected ? Color.gray.opacity(0.1) : Color.clear)
        )
        .overlay(
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1),
            alignment: .bottom
        )
    }
}

// MARK: - Console Footer
struct ConsoleFooterView: View {
    @StateObject private var consoleManager = DebugConsoleManager.shared
    @State private var showCopied = false
    
    private var errorLogs: [DebugLogEntry] {
        consoleManager.logs.filter { $0.level == .error }
    }
    
    var body: some View {
        HStack {
            Text("\(consoleManager.filteredLogs.count) logs")
                .font(.system(size: 12))
                .foregroundColor(.gray)
            
            Spacer()
            
            if !errorLogs.isEmpty {
                Button(action: {
                    copyErrors()
                }) {
                    Label("Copy Errors", systemImage: "doc.on.doc")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.orange)
                }
                
                Divider()
                    .frame(height: 16)
            }
            
            Button(action: {
                consoleManager.clear()
            }) {
                Label("Clear", systemImage: "trash")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .overlay(
            Group {
                if showCopied {
                    Text("Copied!")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green)
                        .cornerRadius(8)
                        .transition(.scale.combined(with: .opacity))
                }
            },
            alignment: .center
        )
    }
    
    private func copyErrors() {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        
        let errorText = errorLogs.map { log in
            "[\(timeFormatter.string(from: log.timestamp))] \(log.message)\n  File: \(log.file):\(log.line)"
        }.joined(separator: "\n\n")
        
        UIPasteboard.general.string = errorText
        
        withAnimation(.easeInOut(duration: 0.2)) {
            showCopied = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut(duration: 0.2)) {
                showCopied = false
            }
        }
    }
}
#endif

// MARK: - Debug Console Modifier
struct DebugConsoleModifier: ViewModifier {
    @StateObject private var consoleManager = DebugConsoleManager.shared
    
    func body(content: Content) -> some View {
        content
            .overlay(
                DebugConsoleView()
                    .allowsHitTesting(consoleManager.isVisible)
                    .animation(.spring(), value: consoleManager.isVisible)
                    .animation(.spring(), value: consoleManager.isMinimized)
            )
    }
}

extension View {
    func withDebugConsole() -> some View {
        modifier(DebugConsoleModifier())
    }
}