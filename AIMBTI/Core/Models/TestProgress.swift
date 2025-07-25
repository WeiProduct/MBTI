import Foundation
import SwiftData

@Model
class TestProgress {
    var id: UUID
    var currentQuestionIndex: Int
    var currentStage: Int
    var answers: Data // Encoded dictionary [Int: String]
    var timestamp: Date
    var language: String
    
    init(currentQuestionIndex: Int, currentStage: Int, answers: [Int: String], language: String) {
        self.id = UUID()
        self.currentQuestionIndex = currentQuestionIndex
        self.currentStage = currentStage
        self.answers = (try? JSONEncoder().encode(answers)) ?? Data()
        self.timestamp = Date()
        self.language = language
    }
    
    func getAnswers() -> [Int: String] {
        guard let decoded = try? JSONDecoder().decode([Int: String].self, from: answers) else {
            return [:]
        }
        return decoded
    }
}