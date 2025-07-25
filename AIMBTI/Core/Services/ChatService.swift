import Foundation
import SwiftData

@MainActor
class ChatService: ObservableObject {
    static let shared = ChatService()
    
    @Published var currentSession: ChatSession?
    @Published var isLoading = false
    @Published var error: String?
    
    private let maxContextMessages = 10 // Limit context to avoid token limits
    private var chatSettings = ChatSettings()
    
    private init() {
        loadSettings()
    }
    
    // MARK: - Session Management
    
    func createNewSession(mbtiType: MBTIType) {
        let session = ChatSession(mbtiType: mbtiType.rawValue)
        currentSession = session
        
        // Add initial system message
        let systemPrompt = getSystemPrompt(for: mbtiType)
        let systemMessage = ChatMessage(content: systemPrompt, role: .system)
        session.addMessage(systemMessage)
    }
    
    func loadSession(_ session: ChatSession) {
        currentSession = session
    }
    
    // MARK: - Message Handling
    
    func sendMessage(_ content: String) async {
        guard let session = currentSession else { 
            ELog("No active chat session")
            return 
        }
        
        DLog("Sending message: \(content)", category: "Chat")
        
        // Add user message to UI immediately
        let userMessage = ChatMessage(content: content, role: .user)
        session.addMessage(userMessage)
        
        isLoading = true
        error = nil
        
        do {
            // Get response from AI
            ILog("Calling OpenAI API...", category: "Chat")
            let response = try await callOpenAI(with: content, session: session)
            
            ILog("Received response: \(response.prefix(100))...", category: "Chat")
            
            // Add AI response with a small delay to ensure proper ordering
            // This ensures the assistant message timestamp is after the user message
            try await Task.sleep(nanoseconds: 100_000_000) // 0.1 second
            let assistantMessage = ChatMessage(content: response, role: .assistant)
            session.addMessage(assistantMessage)
            
        } catch {
            // Handle error
            ELog("Chat API error: \(error.localizedDescription)", category: "Chat")
            self.error = error.localizedDescription
            let errorMessage = ChatMessage(
                content: getErrorMessage(),
                role: .assistant,
                isError: true
            )
            session.addMessage(errorMessage)
        }
        
        isLoading = false
    }
    
    // MARK: - API Communication
    
    private func callOpenAI(with message: String, session: ChatSession) async throws -> String {
        // Build request URL using APIKeyManager
        let apiManager = APIKeyManager.shared
        let endpoint = apiManager.openAIEndpoint
        guard let url = URL(string: endpoint) else {
            throw ChatError.invalidURL
        }
        
        // Prepare messages for context
        var messages: [[String: String]] = []
        
        // Get recent messages for context
        let recentMessages = Array(session.messages.suffix(maxContextMessages))
        for msg in recentMessages {
            messages.append([
                "role": msg.role.rawValue,
                "content": msg.content
            ])
        }
        
        // Prepare request body
        let requestBody: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": messages,
            "temperature": getTemperature(),
            "max_tokens": getMaxTokens()
        ]
        
        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Set headers using APIKeyManager
        let headers = apiManager.buildHeaders()
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        request.timeoutInterval = 30
        
        // Send request
        DLog("API Request URL: \(url.absoluteString)", category: "Network")
        DLog("Using proxy mode: \(apiManager.shouldUseProxy)", category: "Network")
        DLog("API Key available: \(apiManager.openAIKey != nil)", category: "Network")
        DLog("Request headers: \(headers)", category: "Network")
        DLog("Request body: \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "nil")", category: "Network")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check response
        guard let httpResponse = response as? HTTPURLResponse else {
            ELog("Invalid response type", category: "Network")
            throw ChatError.serverError
        }
        
        ILog("Response status: \(httpResponse.statusCode)", category: "Network")
        
        if httpResponse.statusCode != 200 {
            let responseString = String(data: data, encoding: .utf8) ?? "No response data"
            ELog("API Error Response: \(responseString)", category: "Network")
            throw ChatError.serverError
        }
        
        // Parse response
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let choices = json["choices"] as? [[String: Any]],
              let firstChoice = choices.first,
              let message = firstChoice["message"] as? [String: Any],
              let content = message["content"] as? String else {
            throw ChatError.invalidResponse
        }
        
        return content.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // MARK: - System Prompts
    
    private func getSystemPrompt(for mbtiType: MBTIType) -> String {
        let language = LanguageManager.shared.currentLanguage
        let personality = chatSettings.aiPersonality
        
        if language == .chinese {
            return """
            你是一位专业的MBTI个人发展顾问，专门为\(mbtiType.rawValue)类型的用户提供指导。
            
            用户特征：
            \(mbtiType.chineseDescription)
            
            沟通原则：
            1. 使用适合\(mbtiType.rawValue)类型的沟通方式
            2. 提供实用和可执行的建议
            3. 保持\(personality.localizedTitle)的语气
            4. 根据用户需求调整回复深度
            
            专注领域：\(chatSettings.focusAreas.map { $0.localizedTitle }.joined(separator: "、"))
            """
        } else {
            return """
            You are a professional MBTI personal development advisor, specializing in guidance for \(mbtiType.rawValue) personality types.
            
            User characteristics:
            \(mbtiType.englishDescription)
            
            Communication principles:
            1. Use communication style suitable for \(mbtiType.rawValue) types
            2. Provide practical and actionable advice
            3. Maintain a \(personality.localizedTitle) tone
            4. Adjust response depth based on user needs
            
            Focus areas: \(chatSettings.focusAreas.map { $0.localizedTitle }.joined(separator: ", "))
            """
        }
    }
    
    // MARK: - Settings
    
    private func loadSettings() {
        if let data = UserDefaults.standard.data(forKey: "ChatSettings"),
           let settings = try? JSONDecoder().decode(ChatSettings.self, from: data) {
            self.chatSettings = settings
        }
    }
    
    func saveSettings(_ settings: ChatSettings) {
        self.chatSettings = settings
        if let data = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(data, forKey: "ChatSettings")
        }
    }
    
    // MARK: - Helper Methods
    
    private func getTemperature() -> Double {
        switch chatSettings.aiPersonality {
        case .professional:
            return 0.7
        case .friendly:
            return 0.8
        case .humorous:
            return 0.9
        }
    }
    
    private func getMaxTokens() -> Int {
        switch chatSettings.responseLength {
        case .brief:
            return 150
        case .medium:
            return 300
        case .detailed:
            return 500
        }
    }
    
    private func getErrorMessage() -> String {
        let language = LanguageManager.shared.currentLanguage
        if language == .chinese {
            return "抱歉，我现在无法回复。请稍后再试。"
        } else {
            return "Sorry, I cannot respond right now. Please try again later."
        }
    }
    
    // MARK: - Quick Replies
    
    func getQuickReplies(for mbtiType: MBTIType) -> [QuickReplyTemplate] {
        let language = LanguageManager.shared.currentLanguage
        
        if language == .chinese {
            return [
                QuickReplyTemplate(
                    title: "职业建议",
                    message: "请给我一些适合\(mbtiType.rawValue)类型的职业发展建议",
                    category: .career
                ),
                QuickReplyTemplate(
                    title: "人际关系",
                    message: "作为\(mbtiType.rawValue)类型，我该如何改善人际关系？",
                    category: .relationships
                ),
                QuickReplyTemplate(
                    title: "个人成长",
                    message: "针对\(mbtiType.rawValue)类型，有哪些个人成长的方向？",
                    category: .growth
                ),
                QuickReplyTemplate(
                    title: "今日建议",
                    message: "请给我一个适合\(mbtiType.rawValue)类型的今日建议",
                    category: .daily
                )
            ]
        } else {
            return [
                QuickReplyTemplate(
                    title: "Career Advice",
                    message: "Please give me career development advice suitable for \(mbtiType.rawValue) type",
                    category: .career
                ),
                QuickReplyTemplate(
                    title: "Relationships",
                    message: "As an \(mbtiType.rawValue) type, how can I improve my relationships?",
                    category: .relationships
                ),
                QuickReplyTemplate(
                    title: "Personal Growth",
                    message: "What are some personal growth directions for \(mbtiType.rawValue) type?",
                    category: .growth
                ),
                QuickReplyTemplate(
                    title: "Daily Advice",
                    message: "Please give me a daily advice suitable for \(mbtiType.rawValue) type",
                    category: .daily
                )
            ]
        }
    }
}

// MARK: - Chat Errors

enum ChatError: LocalizedError {
    case invalidURL
    case serverError
    case invalidResponse
    case noSession
    
    var errorDescription: String? {
        let language = LanguageManager.shared.currentLanguage
        switch self {
        case .invalidURL:
            return language == .chinese ? "无效的服务器地址" : "Invalid server URL"
        case .serverError:
            return language == .chinese ? "服务器错误" : "Server error"
        case .invalidResponse:
            return language == .chinese ? "无效的响应" : "Invalid response"
        case .noSession:
            return language == .chinese ? "没有活动的会话" : "No active session"
        }
    }
}

// MARK: - MBTI Extensions for Chat

extension MBTIType {
    var chineseDescription: String {
        // Add detailed Chinese descriptions for each type
        switch self {
        case .INTJ:
            return "独立、有远见、追求完美、喜欢规划"
        case .INTP:
            return "逻辑思维强、好奇心重、喜欢分析、追求真理"
        case .ENTJ:
            return "天生的领导者、目标导向、决断力强、喜欢挑战"
        case .ENTP:
            return "创新思维、喜欢辩论、适应力强、充满好奇"
        // Add all 16 types...
        default:
            return "富有个性、独特思维"
        }
    }
    
    var englishDescription: String {
        // Add detailed English descriptions for each type
        switch self {
        case .INTJ:
            return "Independent, visionary, perfectionist, strategic planner"
        case .INTP:
            return "Logical thinker, curious, analytical, truth-seeker"
        case .ENTJ:
            return "Natural leader, goal-oriented, decisive, challenge-lover"
        case .ENTP:
            return "Innovative, debate-lover, adaptable, curious"
        // Add all 16 types...
        default:
            return "Unique personality with distinctive thinking"
        }
    }
}