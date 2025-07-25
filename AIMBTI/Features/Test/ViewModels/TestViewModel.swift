import Foundation
import SwiftUI
import SwiftData

@MainActor
class TestViewModel: ObservableObject {
    @Published var currentQuestionIndex = 0
    @Published var answers: [Int: String] = [:]
    @Published var showResult = false
    @Published var progress: Double = 0.0
    @Published var testResult: MBTIType?
    @Published var dimensionScores: [String: Double] = [:]
    @Published var testAnalysis: TestAnalysis?
    @Published var currentStage = 1
    @Published var showStageComplete = false
    
    private let testService = TestService.shared
    private let progressService = TestProgressService.shared
    private let questionsPerStage = 31 // 93题分3个阶段，每阶段31题
    var modelContext: ModelContext?
    
    var questions: [TestQuestion] {
        testService.questions
    }
    
    var totalStages: Int {
        return Int(ceil(Double(questions.count) / Double(questionsPerStage)))
    }
    
    var currentStageQuestions: [TestQuestion] {
        let startIndex = (currentStage - 1) * questionsPerStage
        let endIndex = min(startIndex + questionsPerStage, questions.count)
        
        guard startIndex < questions.count else { return [] }
        return Array(questions[startIndex..<endIndex])
    }
    
    var currentQuestionInStage: TestQuestion? {
        let stageQuestions = currentStageQuestions
        let indexInStage = currentQuestionIndex % questionsPerStage
        guard indexInStage < stageQuestions.count else { return nil }
        return stageQuestions[indexInStage]
    }
    
    var currentQuestion: TestQuestion? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }
    
    var questionNumber: String {
        let language = LanguageManager.shared.currentLanguage
        if language == .english {
            return "Question \(currentQuestionIndex + 1)/\(questions.count)"
        } else {
            return "题目 \(currentQuestionIndex + 1)/\(questions.count)"
        }
    }
    
    var stageProgress: String {
        let language = LanguageManager.shared.currentLanguage
        if language == .english {
            return "Stage \(currentStage)/\(totalStages)"
        } else {
            return "阶段 \(currentStage)/\(totalStages)"
        }
    }
    
    var canGoBack: Bool {
        currentQuestionIndex > 0
    }
    
    var canGoNext: Bool {
        answers[currentQuestionInStage?.id ?? 0] != nil
    }
    
    func selectAnswer(_ answer: String) {
        if let question = currentQuestionInStage {
            answers[question.id] = answer
            updateProgress()
            saveProgress()
        }
    }
    
    func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            updateProgress()
            
            // 检查是否完成当前阶段
            if (currentQuestionIndex % questionsPerStage) == 0 && currentQuestionIndex < questions.count {
                showStageComplete = true
            }
        } else {
            calculateResult()
        }
    }
    
    func continueToNextStage() {
        currentStage += 1
        showStageComplete = false
    }
    
    func pauseTest() {
        // 保存当前进度（将在下一个任务中实现）
        saveProgress()
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    private func saveProgress() {
        guard let modelContext = modelContext else { return }
        
        progressService.saveProgress(
            questionIndex: currentQuestionIndex,
            stage: currentStage,
            answers: answers,
            language: LanguageManager.shared.currentLanguage.rawValue,
            context: modelContext
        )
    }
    
    func loadProgress() {
        guard let modelContext = modelContext,
              let savedProgress = progressService.loadProgress(context: modelContext) else {
            return
        }
        
        currentQuestionIndex = savedProgress.currentQuestionIndex
        currentStage = savedProgress.currentStage
        answers = savedProgress.getAnswers()
        updateProgress()
    }
    
    func hasProgress() -> Bool {
        guard let modelContext = modelContext else { return false }
        return progressService.hasProgress(context: modelContext)
    }
    
    func previousQuestion() {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
            updateProgress()
        }
    }
    
    private func updateProgress() {
        progress = Double(answers.count) / Double(questions.count)
    }
    
    func calculateResult() {
        let (mbtiType, scores) = testService.calculateMBTIType(answers: answers)
        testResult = mbtiType
        dimensionScores = scores
        
        // Get detailed analysis
        testAnalysis = testService.analyzeTestResult(answers: answers)
        
        showResult = true
        
        // Clear saved progress after completing test
        if let modelContext = modelContext {
            progressService.deleteProgress(context: modelContext)
        }
    }
    
    func resetTest() {
        currentQuestionIndex = 0
        answers = [:]
        showResult = false
        progress = 0.0
        testResult = nil
        dimensionScores = [:]
        testAnalysis = nil
        currentStage = 1
        showStageComplete = false
    }
    
    // MARK: - Debug Functions
    
    #if DEBUG
    /// Randomly answer all questions for debugging purposes
    func randomlyAnswerAllQuestions() {
        DLog("Starting random test completion", category: "Test")
        
        // Reset test state first
        resetTest()
        
        // Create more balanced random answers
        var answeredA = 0
        var answeredB = 0
        
        // Shuffle questions for more randomness
        let shuffledQuestions = questions.shuffled()
        
        for question in shuffledQuestions {
            // Use arc4random_uniform for better randomness
            let randomAnswer = arc4random_uniform(2) == 0 ? "A" : "B"
            answers[question.id] = randomAnswer
            
            if randomAnswer == "A" {
                answeredA += 1
            } else {
                answeredB += 1
            }
        }
        
        ILog("Answered all \(questions.count) questions randomly (A: \(answeredA), B: \(answeredB))", category: "Test")
        DLog("Answer distribution: \(String(format: "%.1f%%", Double(answeredA) / Double(questions.count) * 100)) A, \(String(format: "%.1f%%", Double(answeredB) / Double(questions.count) * 100)) B", category: "Test")
        
        // Update progress
        updateProgress()
        
        // Small delay to ensure UI updates
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.calculateResult()
        }
    }
    #endif
}