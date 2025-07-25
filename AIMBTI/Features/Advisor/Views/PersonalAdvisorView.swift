import SwiftUI
import SwiftData

struct PersonalAdvisorView: View {
    @StateObject private var chatService = ChatService.shared
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ChatSession.updatedAt, order: .reverse) private var sessions: [ChatSession]
    
    @State private var messageText = ""
    @State private var showingSessions = false
    @State private var showingSettings = false
    @State private var scrollToBottom = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    // Get user's MBTI type from saved results
    @Query(sort: \TestResult.date, order: .reverse) private var testResults: [TestResult]
    
    var currentMBTIType: MBTIType? {
        guard let latestResult = testResults.first,
              let type = MBTIType(rawValue: latestResult.mbtiType) else {
            return nil
        }
        return type
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if let mbtiType = currentMBTIType {
                    if chatService.currentSession != nil {
                        // Chat interface
                        chatContent
                    } else {
                        // Welcome screen
                        welcomeView(mbtiType: mbtiType)
                    }
                } else {
                    // No MBTI test completed
                    noMBTIView
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if chatService.currentSession != nil {
                        Button(action: { showingSessions = true }) {
                            Image(systemName: "list.bullet")
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        if chatService.currentSession != nil {
                            Button(action: startNewChat) {
                                Image(systemName: "square.and.pencil")
                            }
                        }
                        
                        Button(action: { showingSettings = true }) {
                            Image(systemName: "gearshape")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingSessions) {
                ChatSessionsView()
            }
            .sheet(isPresented: $showingSettings) {
                ChatSettingsView()
            }
            .alert("Error", isPresented: $showError) {
                Button("OK") {
                    showError = false
                }
                Button("Copy Error") {
                    UIPasteboard.general.string = errorMessage
                }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    // MARK: - Chat Content
    
    private var chatContent: some View {
        VStack(spacing: 0) {
            // Messages list
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 12) {
                        if let session = chatService.currentSession {
                            ForEach(session.messages
                                .filter { $0.role != .system }
                                .sorted(by: { $0.timestamp < $1.timestamp })) { message in
                                ChatBubbleView(message: message)
                                    .id(message.id)
                            }
                            
                            if chatService.isLoading {
                                LoadingBubbleView()
                            }
                        }
                    }
                    .padding()
                }
                .onChange(of: scrollToBottom) { _, _ in
                    if let lastMessage = chatService.currentSession?.messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            Divider()
            
            // Input area
            ChatInputView(
                text: $messageText,
                onSend: sendMessage,
                quickReplies: currentMBTIType.map { chatService.getQuickReplies(for: $0) } ?? []
            )
        }
        .background(Theme.backgroundColor)
    }
    
    // MARK: - Welcome View
    
    private func welcomeView(mbtiType: MBTIType) -> some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "bubble.left.and.bubble.right.fill")
                .font(.system(size: 80))
                .foregroundColor(Theme.primaryColor)
            
            VStack(spacing: 10) {
                Text(welcomeTitle)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                
                Text(welcomeSubtitle(for: mbtiType))
                    .font(.system(size: 16))
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: { startNewChat() }) {
                Text(startChatButtonText)
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal, 60)
            
            Spacer()
        }
    }
    
    // MARK: - No MBTI View
    
    private var noMBTIView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(Color.orange)
            
            Text(noMBTITitle)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Theme.textPrimary)
            
            Text(noMBTIMessage)
                .font(.system(size: 16))
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    // MARK: - Actions
    
    private func startNewChat() {
        guard let mbtiType = currentMBTIType else { return }
        chatService.createNewSession(mbtiType: mbtiType)
        
        // Save session to database
        if let session = chatService.currentSession {
            modelContext.insert(session)
            try? modelContext.save()
        }
    }
    
    private func sendMessage() {
        let trimmedText = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        Task {
            await chatService.sendMessage(trimmedText)
            scrollToBottom.toggle()
            
            // Save to database
            try? modelContext.save()
        }
        
        messageText = ""
    }
    
    // MARK: - Localized Strings
    
    private var navigationTitle: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "个人顾问" : "Personal Advisor"
    }
    
    private var welcomeTitle: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "您的专属MBTI顾问" : "Your Personal MBTI Advisor"
    }
    
    private func welcomeSubtitle(for type: MBTIType) -> String {
        let language = LanguageManager.shared.currentLanguage
        if language == .chinese {
            return "专为\(type.rawValue)类型定制的个人发展指导"
        } else {
            return "Personalized guidance tailored for \(type.rawValue) types"
        }
    }
    
    private var startChatButtonText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "开始对话" : "Start Chat"
    }
    
    private var noMBTITitle: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "请先完成测试" : "Please Complete Test First"
    }
    
    private var noMBTIMessage: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "完成MBTI测试后，即可使用个人顾问功能" :
            "Complete the MBTI test to use the personal advisor feature"
    }
}

// MARK: - Chat Bubble View

struct ChatBubbleView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.role.isUser {
                Spacer(minLength: 60)
            }
            
            VStack(alignment: message.role.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .font(.system(size: 16))
                    .foregroundColor(message.role.isUser ? .white : Theme.textPrimary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(backgroundColor)
                    )
                
                Text(timeString)
                    .font(.system(size: 12))
                    .foregroundColor(Theme.textSecondary)
            }
            
            if !message.role.isUser {
                Spacer(minLength: 60)
            }
        }
    }
    
    private var backgroundColor: Color {
        if message.isError {
            return Color.red.opacity(0.1)
        } else if message.role.isUser {
            return Theme.primaryColor
        } else {
            return Color.gray.opacity(0.1)
        }
    }
    
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: message.timestamp)
    }
}

// MARK: - Loading Bubble

struct LoadingBubbleView: View {
    @State private var animatingDots = false
    
    var body: some View {
        HStack {
            HStack(spacing: 4) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Theme.primaryColor)
                        .frame(width: 8, height: 8)
                        .scaleEffect(animatingDots ? 1.0 : 0.5)
                        .animation(
                            .easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                            value: animatingDots
                        )
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.gray.opacity(0.1))
            )
            
            Spacer()
        }
        .onAppear {
            animatingDots = true
        }
    }
}

#Preview {
    PersonalAdvisorView()
        .modelContainer(for: [ChatSession.self, ChatMessage.self, TestResult.self])
}