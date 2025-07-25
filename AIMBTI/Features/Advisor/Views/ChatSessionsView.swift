import SwiftUI
import SwiftData

struct ChatSessionsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ChatSession.updatedAt, order: .reverse) private var sessions: [ChatSession]
    @StateObject private var chatService = ChatService.shared
    
    @State private var searchText = ""
    @State private var showingDeleteAlert = false
    @State private var sessionToDelete: ChatSession?
    
    var filteredSessions: [ChatSession] {
        if searchText.isEmpty {
            return sessions
        } else {
            return sessions.filter { session in
                session.title.localizedCaseInsensitiveContains(searchText) ||
                session.messages.contains { $0.content.localizedCaseInsensitiveContains(searchText) }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if sessions.isEmpty {
                    emptyView
                } else {
                    List {
                        ForEach(filteredSessions) { session in
                            SessionRow(session: session) {
                                chatService.loadSession(session)
                                dismiss()
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    sessionToDelete = session
                                    showingDeleteAlert = true
                                } label: {
                                    Label(deleteText, systemImage: "trash")
                                }
                            }
                        }
                    }
                    .searchable(text: $searchText, prompt: searchPrompt)
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(doneText) {
                        dismiss()
                    }
                }
            }
            .alert(deleteAlertTitle, isPresented: $showingDeleteAlert) {
                Button(cancelText, role: .cancel) {}
                Button(deleteText, role: .destructive) {
                    if let session = sessionToDelete {
                        deleteSession(session)
                    }
                }
            } message: {
                Text(deleteAlertMessage)
            }
        }
    }
    
    // MARK: - Empty View
    
    private var emptyView: some View {
        VStack(spacing: 20) {
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 60))
                .foregroundColor(Color.gray.opacity(0.3))
            
            Text(emptyTitle)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Theme.textSecondary)
            
            Text(emptyMessage)
                .font(.system(size: 14))
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Actions
    
    private func deleteSession(_ session: ChatSession) {
        modelContext.delete(session)
        try? modelContext.save()
        
        // If deleting current session, clear it
        if chatService.currentSession?.id == session.id {
            chatService.currentSession = nil
        }
    }
    
    // MARK: - Localized Strings
    
    private var navigationTitle: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "对话历史" : "Chat History"
    }
    
    private var doneText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "完成" : "Done"
    }
    
    private var searchPrompt: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "搜索对话内容" : "Search conversations"
    }
    
    private var deleteText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "删除" : "Delete"
    }
    
    private var cancelText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "取消" : "Cancel"
    }
    
    private var deleteAlertTitle: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "删除对话？" : "Delete Conversation?"
    }
    
    private var deleteAlertMessage: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "此操作无法撤销" : "This action cannot be undone"
    }
    
    private var emptyTitle: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "暂无对话记录" : "No Conversations"
    }
    
    private var emptyMessage: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "开始新对话后，历史记录将显示在这里" :
            "Your conversation history will appear here"
    }
}

// MARK: - Session Row

struct SessionRow: View {
    let session: ChatSession
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(session.title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Theme.textPrimary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(Color.gray.opacity(0.5))
                }
                
                if !session.lastMessagePreview.isEmpty {
                    Text(session.lastMessagePreview)
                        .font(.system(size: 14))
                        .foregroundColor(Theme.textSecondary)
                        .lineLimit(2)
                }
                
                HStack {
                    Text(session.mbtiType)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Theme.primaryColor)
                    
                    Spacer()
                    
                    Text(formattedDate)
                        .font(.system(size: 12))
                        .foregroundColor(Color.gray)
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var formattedDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: session.updatedAt, relativeTo: Date())
    }
}

#Preview {
    ChatSessionsView()
        .modelContainer(for: [ChatSession.self, ChatMessage.self])
}