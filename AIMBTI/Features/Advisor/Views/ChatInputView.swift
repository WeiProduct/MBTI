import SwiftUI

struct ChatInputView: View {
    @Binding var text: String
    let onSend: () -> Void
    let quickReplies: [QuickReplyTemplate]
    
    @State private var showingQuickReplies = false
    @FocusState private var isTextFieldFocused: Bool
    
    private let maxCharacters = 500
    
    var body: some View {
        VStack(spacing: 0) {
            // Quick replies
            if showingQuickReplies {
                quickRepliesView
            }
            
            // Input area
            HStack(spacing: 12) {
                // Quick replies toggle
                Button(action: {
                    withAnimation(.spring(response: 0.3)) {
                        showingQuickReplies.toggle()
                    }
                }) {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 20))
                        .foregroundColor(showingQuickReplies ? Theme.primaryColor : Color.gray)
                }
                
                // Text field
                HStack {
                    TextField(placeholderText, text: $text, axis: .vertical)
                        .lineLimit(1...4)
                        .focused($isTextFieldFocused)
                        .onSubmit {
                            if !text.isEmpty {
                                onSend()
                            }
                        }
                    
                    if !text.isEmpty {
                        Button(action: { text = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 16))
                                .foregroundColor(Color.gray.opacity(0.5))
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.1))
                )
                
                // Send button
                Button(action: {
                    if canSend {
                        onSend()
                    }
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(canSend ? Theme.primaryColor : Color.gray.opacity(0.3))
                }
                .disabled(!canSend)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            // Character count
            if !text.isEmpty {
                HStack {
                    Spacer()
                    Text("\(text.count)/\(maxCharacters)")
                        .font(.system(size: 12))
                        .foregroundColor(characterCountColor)
                        .padding(.horizontal)
                }
            }
        }
        .background(Color(UIColor.systemBackground))
    }
    
    // MARK: - Quick Replies View
    
    private var quickRepliesView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(quickReplies) { reply in
                    QuickReplyButton(reply: reply) { selectedReply in
                        text = selectedReply.message
                        showingQuickReplies = false
                        isTextFieldFocused = true
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(Color.gray.opacity(0.05))
    }
    
    // MARK: - Computed Properties
    
    private var canSend: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && text.count <= maxCharacters
    }
    
    private var characterCountColor: Color {
        if text.count > maxCharacters {
            return .red
        } else if Double(text.count) > Double(maxCharacters) * 0.8 {
            return .orange
        } else {
            return Theme.textSecondary
        }
    }
    
    private var placeholderText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "输入您的问题..." : "Type your question..."
    }
}

// MARK: - Quick Reply Button

struct QuickReplyButton: View {
    let reply: QuickReplyTemplate
    let onSelect: (QuickReplyTemplate) -> Void
    
    var body: some View {
        Button(action: { onSelect(reply) }) {
            VStack(alignment: .leading, spacing: 4) {
                Text(reply.title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Theme.primaryColor)
                
                Text(reply.category.localizedTitle)
                    .font(.system(size: 12))
                    .foregroundColor(Theme.textSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            )
        }
    }
}

#Preview {
    VStack {
        Spacer()
        ChatInputView(
            text: .constant(""),
            onSend: {},
            quickReplies: [
                QuickReplyTemplate(
                    title: "Career Advice",
                    message: "What career advice do you have?",
                    category: .career
                ),
                QuickReplyTemplate(
                    title: "Daily Tip",
                    message: "Give me a daily tip",
                    category: .daily
                )
            ]
        )
    }
}