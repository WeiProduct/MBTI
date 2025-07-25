import Foundation
import SwiftData

// MARK: - Chat Message Model
@Model
class ChatMessage {
    var id: UUID
    var content: String
    var role: MessageRole
    var timestamp: Date
    var isError: Bool
    
    // Relationship
    var session: ChatSession?
    
    init(content: String, role: MessageRole, isError: Bool = false) {
        self.id = UUID()
        self.content = content
        self.role = role
        self.timestamp = Date()
        self.isError = isError
    }
}

// MARK: - Message Role
enum MessageRole: String, Codable {
    case user = "user"
    case assistant = "assistant"
    case system = "system"
    
    var isUser: Bool {
        self == .user
    }
}

// MARK: - Chat Session Model
@Model
class ChatSession {
    var id: UUID
    var title: String
    var createdAt: Date
    var updatedAt: Date
    var mbtiType: String
    var isActive: Bool
    
    // Relationship
    @Relationship(deleteRule: .cascade, inverse: \ChatMessage.session)
    var messages: [ChatMessage]
    
    // Computed property for last message preview
    var lastMessagePreview: String {
        messages.last?.content ?? ""
    }
    
    init(title: String = "", mbtiType: String) {
        self.id = UUID()
        self.title = title.isEmpty ? Self.generateTitle() : title
        self.createdAt = Date()
        self.updatedAt = Date()
        self.mbtiType = mbtiType
        self.isActive = true
        self.messages = []
    }
    
    private static func generateTitle() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        let language = LanguageManager.shared.currentLanguage
        if language == .chinese {
            return "对话 - \(formatter.string(from: Date()))"
        } else {
            return "Chat - \(formatter.string(from: Date()))"
        }
    }
    
    func addMessage(_ message: ChatMessage) {
        messages.append(message)
        updatedAt = Date()
    }
}

// MARK: - Quick Reply Template
struct QuickReplyTemplate: Identifiable {
    let id: UUID = UUID()
    let title: String
    let message: String
    let category: ReplyCategory
    
    enum ReplyCategory: String, CaseIterable {
        case career = "career"
        case relationships = "relationships"
        case growth = "growth"
        case daily = "daily"
        
        var localizedTitle: String {
            let language = LanguageManager.shared.currentLanguage
            switch self {
            case .career:
                return language == .chinese ? "职业发展" : "Career Development"
            case .relationships:
                return language == .chinese ? "人际关系" : "Relationships"
            case .growth:
                return language == .chinese ? "个人成长" : "Personal Growth"
            case .daily:
                return language == .chinese ? "日常建议" : "Daily Advice"
            }
        }
    }
}

// MARK: - Chat Settings
struct ChatSettings: Codable {
    var aiPersonality: AIPersonality = .professional
    var responseLength: ResponseLength = .medium
    var focusAreas: Set<FocusArea> = []
    var enableNotifications: Bool = false
    
    enum AIPersonality: String, Codable, CaseIterable {
        case professional = "professional"
        case friendly = "friendly"
        case humorous = "humorous"
        
        var localizedTitle: String {
            let language = LanguageManager.shared.currentLanguage
            switch self {
            case .professional:
                return language == .chinese ? "专业" : "Professional"
            case .friendly:
                return language == .chinese ? "友好" : "Friendly"
            case .humorous:
                return language == .chinese ? "幽默" : "Humorous"
            }
        }
    }
    
    enum ResponseLength: String, Codable, CaseIterable {
        case brief = "brief"
        case medium = "medium"
        case detailed = "detailed"
        
        var localizedTitle: String {
            let language = LanguageManager.shared.currentLanguage
            switch self {
            case .brief:
                return language == .chinese ? "简洁" : "Brief"
            case .medium:
                return language == .chinese ? "适中" : "Medium"
            case .detailed:
                return language == .chinese ? "详细" : "Detailed"
            }
        }
    }
    
    enum FocusArea: String, Codable, CaseIterable {
        case career = "career"
        case relationships = "relationships"
        case health = "health"
        case creativity = "creativity"
        case leadership = "leadership"
        case learning = "learning"
        
        var localizedTitle: String {
            let language = LanguageManager.shared.currentLanguage
            switch self {
            case .career:
                return language == .chinese ? "职业发展" : "Career"
            case .relationships:
                return language == .chinese ? "人际关系" : "Relationships"
            case .health:
                return language == .chinese ? "健康生活" : "Health"
            case .creativity:
                return language == .chinese ? "创造力" : "Creativity"
            case .leadership:
                return language == .chinese ? "领导力" : "Leadership"
            case .learning:
                return language == .chinese ? "学习成长" : "Learning"
            }
        }
    }
}