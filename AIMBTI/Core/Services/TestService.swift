import Foundation

class TestService {
    static let shared = TestService()
    
    private var allQuestions: [TestQuestion] = []
    private var translationDict: [String: String] = [:]
    
    private init() {
        loadTranslations()
        loadQuestions()
    }
    
    private func loadTranslations() {
        guard let url = Bundle.main.url(forResource: "mbti_translations", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let translations = try? JSONDecoder().decode([String: [String: String]].self, from: data),
              let dict = translations["translations"] else {
            return
        }
        translationDict = dict
    }
    
    var questions: [TestQuestion] {
        return allQuestions
    }
    
    func refreshQuestions() {
        loadQuestions()
    }
    
    private func loadQuestions() {
        // 加载93道题目
        guard let url = Bundle.main.url(forResource: "mbti_questions_chinese", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let mbtiData = try? JSONDecoder().decode([MBTIQuestion].self, from: data) else {
            // 如果加载失败，使用备用题目
            allQuestions = getFallbackQuestions()
            return
        }
        
        // 转换题目格式
        allQuestions = mbtiData.enumerated().map { index, mbtiQuestion in
            let dimension = getDimension(from: mbtiQuestion.choice_a.value, mbtiQuestion.choice_b.value)
            let language = LanguageManager.shared.currentLanguage
            
            return TestQuestion(
                id: index + 1,
                text: language == .english ? getEnglishTranslation(for: mbtiQuestion.question) : mbtiQuestion.question,
                optionA: language == .english ? getEnglishTranslation(for: mbtiQuestion.choice_a.text) : mbtiQuestion.choice_a.text,
                optionB: language == .english ? getEnglishTranslation(for: mbtiQuestion.choice_b.text) : mbtiQuestion.choice_b.text,
                dimension: dimension
            )
        }
    }
    
    private func getDimension(from valueA: String, _ valueB: String) -> MBTIDimension {
        // 根据选项的值判断维度
        let values = Set([valueA, valueB])
        
        if values.contains("E") || values.contains("I") {
            return .EI
        } else if values.contains("S") || values.contains("N") {
            return .SN
        } else if values.contains("T") || values.contains("F") {
            return .TF
        } else if values.contains("J") || values.contains("P") {
            return .JP
        }
        
        return .EI // 默认值
    }
    
    private func getEnglishTranslation(for text: String) -> String {
        return translationDict[text] ?? text
    }
    
    private func getFallbackQuestions() -> [TestQuestion] {
        let language = LanguageManager.shared.currentLanguage
        if language == .english {
            return questionsEnglish
        } else {
            return questionsChinese
        }
    }
    
    private let questionsChinese: [TestQuestion] = [
        TestQuestion(id: 1, text: "在社交聚会中，你更倾向于：", 
                    optionA: "主动与很多人交谈，享受热闹氛围", 
                    optionB: "与少数几个人深入交流", 
                    dimension: .EI),
        TestQuestion(id: 2, text: "当面对新的任务时，你更倾向于：", 
                    optionA: "先了解整体概念和可能性", 
                    optionB: "先了解具体步骤和细节", 
                    dimension: .SN),
        TestQuestion(id: 3, text: "做决定时，你更看重：", 
                    optionA: "逻辑分析和客观事实", 
                    optionB: "个人价值观和对他人的影响", 
                    dimension: .TF),
        TestQuestion(id: 4, text: "你更喜欢的生活方式是：", 
                    optionA: "有计划和条理的", 
                    optionB: "灵活和随性的", 
                    dimension: .JP),
        TestQuestion(id: 5, text: "独处时，你通常感到：", 
                    optionA: "精力充沛，享受独处时光", 
                    optionB: "希望能有人陪伴", 
                    dimension: .EI),
        TestQuestion(id: 6, text: "你更相信：", 
                    optionA: "直觉和灵感", 
                    optionB: "经验和事实", 
                    dimension: .SN),
        TestQuestion(id: 7, text: "与人争论时，你更倾向于：", 
                    optionA: "坚持真理和原则", 
                    optionB: "寻求和谐与妥协", 
                    dimension: .TF),
        TestQuestion(id: 8, text: "对于截止日期，你通常：", 
                    optionA: "提前完成任务", 
                    optionB: "在最后时刻完成", 
                    dimension: .JP),
        TestQuestion(id: 9, text: "在团队中，你更喜欢：", 
                    optionA: "积极发言，分享想法", 
                    optionB: "倾听他人，深思熟虑后发言", 
                    dimension: .EI),
        TestQuestion(id: 10, text: "学习新知识时，你更喜欢：", 
                    optionA: "理论概念和抽象思考", 
                    optionB: "实际案例和具体应用", 
                    dimension: .SN),
        TestQuestion(id: 11, text: "批评他人时，你更倾向于：", 
                    optionA: "直接指出问题", 
                    optionB: "委婉地表达意见", 
                    dimension: .TF),
        TestQuestion(id: 12, text: "旅行时，你更喜欢：", 
                    optionA: "详细规划行程", 
                    optionB: "随心所欲地探索", 
                    dimension: .JP)
    ]
    
    private let questionsEnglish: [TestQuestion] = [
        TestQuestion(id: 1, text: "At social gatherings, you prefer to:", 
                    optionA: "Talk to many people and enjoy the lively atmosphere", 
                    optionB: "Have deep conversations with a few people", 
                    dimension: .EI),
        TestQuestion(id: 2, text: "When facing a new task, you prefer to:", 
                    optionA: "Understand the overall concept and possibilities first", 
                    optionB: "Understand the specific steps and details first", 
                    dimension: .SN),
        TestQuestion(id: 3, text: "When making decisions, you value more:", 
                    optionA: "Logical analysis and objective facts", 
                    optionB: "Personal values and impact on others", 
                    dimension: .TF),
        TestQuestion(id: 4, text: "Your preferred lifestyle is:", 
                    optionA: "Planned and organized", 
                    optionB: "Flexible and spontaneous", 
                    dimension: .JP),
        TestQuestion(id: 5, text: "When alone, you usually feel:", 
                    optionA: "Energized, enjoying the solitude", 
                    optionB: "Wishing for someone's company", 
                    dimension: .EI),
        TestQuestion(id: 6, text: "You trust more in:", 
                    optionA: "Intuition and inspiration", 
                    optionB: "Experience and facts", 
                    dimension: .SN),
        TestQuestion(id: 7, text: "During arguments, you tend to:", 
                    optionA: "Stand by truth and principles", 
                    optionB: "Seek harmony and compromise", 
                    dimension: .TF),
        TestQuestion(id: 8, text: "Regarding deadlines, you usually:", 
                    optionA: "Complete tasks ahead of time", 
                    optionB: "Finish at the last moment", 
                    dimension: .JP),
        TestQuestion(id: 9, text: "In a team, you prefer to:", 
                    optionA: "Speak up actively and share ideas", 
                    optionB: "Listen to others and speak after consideration", 
                    dimension: .EI),
        TestQuestion(id: 10, text: "When learning new knowledge, you prefer:", 
                    optionA: "Theoretical concepts and abstract thinking", 
                    optionB: "Practical examples and concrete applications", 
                    dimension: .SN),
        TestQuestion(id: 11, text: "When criticizing others, you tend to:", 
                    optionA: "Point out problems directly", 
                    optionB: "Express opinions tactfully", 
                    dimension: .TF),
        TestQuestion(id: 12, text: "When traveling, you prefer to:", 
                    optionA: "Plan the itinerary in detail", 
                    optionB: "Explore freely as you go", 
                    dimension: .JP)
    ]
    
    func calculateMBTIType(answers: [Int: String]) -> (MBTIType, [String: Double]) {
        guard let url = Bundle.main.url(forResource: "mbti_questions_chinese", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let mbtiQuestions = try? JSONDecoder().decode([MBTIQuestion].self, from: data) else {
            return calculateMBTITypeOldMethod(answers: answers)
        }
        
        // 计算每个维度的得分
        var dimensionCounts: [String: Int] = [
            "E": 0, "I": 0,
            "S": 0, "N": 0,
            "T": 0, "F": 0,
            "J": 0, "P": 0
        ]
        
        for (questionId, answer) in answers {
            if questionId > 0 && questionId <= mbtiQuestions.count {
                let question = mbtiQuestions[questionId - 1]
                if answer == "A" {
                    dimensionCounts[question.choice_a.value, default: 0] += 1
                } else if answer == "B" {
                    dimensionCounts[question.choice_b.value, default: 0] += 1
                }
            }
        }
        
        // 确定MBTI类型
        let e = dimensionCounts["E", default: 0] > dimensionCounts["I", default: 0]
        let n = dimensionCounts["N", default: 0] > dimensionCounts["S", default: 0]
        let t = dimensionCounts["T", default: 0] > dimensionCounts["F", default: 0]
        let j = dimensionCounts["J", default: 0] > dimensionCounts["P", default: 0]
        
        let typeString = "\(e ? "E" : "I")\(n ? "N" : "S")\(t ? "T" : "F")\(j ? "J" : "P")"
        let mbtiType = MBTIType(rawValue: typeString)!
        
        // 计算百分比
        let totalE_I = dimensionCounts["E", default: 0] + dimensionCounts["I", default: 0]
        let totalS_N = dimensionCounts["S", default: 0] + dimensionCounts["N", default: 0]
        let totalT_F = dimensionCounts["T", default: 0] + dimensionCounts["F", default: 0]
        let totalJ_P = dimensionCounts["J", default: 0] + dimensionCounts["P", default: 0]
        
        let dimensionScores: [String: Double] = [
            "E": totalE_I > 0 ? Double(dimensionCounts["E", default: 0]) / Double(totalE_I) * 100 : 50,
            "I": totalE_I > 0 ? Double(dimensionCounts["I", default: 0]) / Double(totalE_I) * 100 : 50,
            "N": totalS_N > 0 ? Double(dimensionCounts["N", default: 0]) / Double(totalS_N) * 100 : 50,
            "S": totalS_N > 0 ? Double(dimensionCounts["S", default: 0]) / Double(totalS_N) * 100 : 50,
            "T": totalT_F > 0 ? Double(dimensionCounts["T", default: 0]) / Double(totalT_F) * 100 : 50,
            "F": totalT_F > 0 ? Double(dimensionCounts["F", default: 0]) / Double(totalT_F) * 100 : 50,
            "J": totalJ_P > 0 ? Double(dimensionCounts["J", default: 0]) / Double(totalJ_P) * 100 : 50,
            "P": totalJ_P > 0 ? Double(dimensionCounts["P", default: 0]) / Double(totalJ_P) * 100 : 50
        ]
        
        return (mbtiType, dimensionScores)
    }
    
    private func calculateMBTITypeOldMethod(answers: [Int: String]) -> (MBTIType, [String: Double]) {
        // 原有的计算方法作为备用
        var scores: [MBTIDimension: Int] = [:]
        
        for (questionId, answer) in answers {
            if let question = questions.first(where: { $0.id == questionId }) {
                if answer == "A" {
                    switch question.dimension {
                    case .EI: scores[.EI, default: 0] += 1
                    case .SN: scores[.SN, default: 0] += 1
                    case .TF: scores[.TF, default: 0] += 1
                    case .JP: scores[.JP, default: 0] += 1
                    }
                }
            }
        }
        
        let totalQuestions = questions.count / 4
        
        let e = scores[.EI, default: 0] > totalQuestions / 2
        let n = scores[.SN, default: 0] > totalQuestions / 2
        let t = scores[.TF, default: 0] > totalQuestions / 2
        let j = scores[.JP, default: 0] > totalQuestions / 2
        
        let typeString = "\(e ? "E" : "I")\(n ? "N" : "S")\(t ? "T" : "F")\(j ? "J" : "P")"
        let mbtiType = MBTIType(rawValue: typeString)!
        
        let dimensionScores: [String: Double] = [
            "E": Double(scores[.EI, default: 0]) / Double(totalQuestions) * 100,
            "I": Double(totalQuestions - scores[.EI, default: 0]) / Double(totalQuestions) * 100,
            "N": Double(scores[.SN, default: 0]) / Double(totalQuestions) * 100,
            "S": Double(totalQuestions - scores[.SN, default: 0]) / Double(totalQuestions) * 100,
            "T": Double(scores[.TF, default: 0]) / Double(totalQuestions) * 100,
            "F": Double(totalQuestions - scores[.TF, default: 0]) / Double(totalQuestions) * 100,
            "J": Double(scores[.JP, default: 0]) / Double(totalQuestions) * 100,
            "P": Double(totalQuestions - scores[.JP, default: 0]) / Double(totalQuestions) * 100
        ]
        
        return (mbtiType, dimensionScores)
    }
}