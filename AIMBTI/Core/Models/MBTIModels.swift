import Foundation
import SwiftData

enum MBTIDimension: String, CaseIterable, Codable {
    case EI = "EI"
    case SN = "SN"
    case TF = "TF"
    case JP = "JP"
}

enum MBTIType: String, CaseIterable, Codable, Identifiable {
    var id: String { self.rawValue }
    case INTJ = "INTJ"
    case INTP = "INTP"
    case ENTJ = "ENTJ"
    case ENTP = "ENTP"
    case INFJ = "INFJ"
    case INFP = "INFP"
    case ENFJ = "ENFJ"
    case ENFP = "ENFP"
    case ISTJ = "ISTJ"
    case ISFJ = "ISFJ"
    case ESTJ = "ESTJ"
    case ESFJ = "ESFJ"
    case ISTP = "ISTP"
    case ISFP = "ISFP"
    case ESTP = "ESTP"
    case ESFP = "ESFP"
    
    var title: String {
        let language = LanguageManager.shared.currentLanguage
        switch (self, language) {
        case (.INTJ, .chinese): return "建筑师"
        case (.INTJ, .english): return "Architect"
        case (.INTP, .chinese): return "思想家"
        case (.INTP, .english): return "Thinker"
        case (.ENTJ, .chinese): return "指挥官"
        case (.ENTJ, .english): return "Commander"
        case (.ENTP, .chinese): return "辩论家"
        case (.ENTP, .english): return "Debater"
        case (.INFJ, .chinese): return "倡导者"
        case (.INFJ, .english): return "Advocate"
        case (.INFP, .chinese): return "调停者"
        case (.INFP, .english): return "Mediator"
        case (.ENFJ, .chinese): return "主人公"
        case (.ENFJ, .english): return "Protagonist"
        case (.ENFP, .chinese): return "竞选者"
        case (.ENFP, .english): return "Campaigner"
        case (.ISTJ, .chinese): return "物流师"
        case (.ISTJ, .english): return "Logistician"
        case (.ISFJ, .chinese): return "守护者"
        case (.ISFJ, .english): return "Defender"
        case (.ESTJ, .chinese): return "总经理"
        case (.ESTJ, .english): return "Executive"
        case (.ESFJ, .chinese): return "执政官"
        case (.ESFJ, .english): return "Consul"
        case (.ISTP, .chinese): return "鉴赏家"
        case (.ISTP, .english): return "Virtuoso"
        case (.ISFP, .chinese): return "探险家"
        case (.ISFP, .english): return "Adventurer"
        case (.ESTP, .chinese): return "企业家"
        case (.ESTP, .english): return "Entrepreneur"
        case (.ESFP, .chinese): return "娱乐家"
        case (.ESFP, .english): return "Entertainer"
        }
    }
    
    var subtitle: String {
        let language = LanguageManager.shared.currentLanguage
        switch (self, language) {
        case (.INTJ, .chinese): return "富有想象力和战略性的思想家，一切皆在计划之中"
        case (.INTJ, .english): return "Imaginative and strategic thinkers, with a plan for everything"
        case (.INTP, .chinese): return "创新的发明家，对知识有着止不住的渴望"
        case (.INTP, .english): return "Innovative inventors with an unquenchable thirst for knowledge"
        case (.ENTJ, .chinese): return "大胆、富有想象力且意志坚强的领导者"
        case (.ENTJ, .english): return "Bold, imaginative and strong-willed leaders"
        case (.ENTP, .chinese): return "聪明好奇的思想者，不放弃任何智力挑战"
        case (.ENTP, .english): return "Smart and curious thinkers who cannot resist an intellectual challenge"
        case (.INFJ, .chinese): return "安静而神秘，同时鼓舞人心且不知疲倦的理想主义者"
        case (.INFJ, .english): return "Quiet and mystical, yet very inspiring and tireless idealists"
        case (.INFP, .chinese): return "诗意、善良的利他主义者，总是热情地为正义事业而奋斗"
        case (.INFP, .english): return "Poetic, kind and altruistic people, always eager to help a good cause"
        case (.ENFJ, .chinese): return "富有感召力的领导者，能够激励他们的听众"
        case (.ENFJ, .english): return "Charismatic and inspiring leaders, able to mesmerize their listeners"
        case (.ENFP, .chinese): return "充满激情和创造力的自由灵魂，总能找到理由微笑"
        case (.ENFP, .english): return "Enthusiastic, creative and sociable free spirits, who can always find a reason to smile"
        case (.ISTJ, .chinese): return "务实、注重事实的个人，可靠性不容置疑"
        case (.ISTJ, .english): return "Practical and fact-oriented individuals, whose reliability cannot be doubted"
        case (.ISFJ, .chinese): return "非常专注而温暖的守护者，时刻准备保护爱着的人"
        case (.ISFJ, .english): return "Very dedicated and warm protectors, always ready to defend their loved ones"
        case (.ESTJ, .chinese): return "出色的管理者，在管理事情或人方面无与伦比"
        case (.ESTJ, .english): return "Excellent administrators, unsurpassed at managing things or people"
        case (.ESFJ, .chinese): return "极富同情心、爱交际且受欢迎的人，总是热心提供帮助"
        case (.ESFJ, .english): return "Extraordinarily caring, social and popular people, always eager to help"
        case (.ISTP, .chinese): return "大胆而实际的实验家，擅长使用各种工具"
        case (.ISTP, .english): return "Bold and practical experimenters, masters of all kinds of tools"
        case (.ISFP, .chinese): return "灵活而富有魅力的艺术家，时刻准备探索和体验新鲜事物"
        case (.ISFP, .english): return "Flexible and charming artists, always ready to explore and experience something new"
        case (.ESTP, .chinese): return "聪明、精力充沛、感知力强的人，真心享受生活在边缘"
        case (.ESTP, .english): return "Smart, energetic and very perceptive people, who truly enjoy living on the edge"
        case (.ESFP, .chinese): return "自发、精力充沛且热情的娱乐者，生活在他们周围永不无聊"
        case (.ESFP, .english): return "Spontaneous, energetic and enthusiastic entertainers - life is never boring around them"
        }
    }
    
    var category: String {
        let language = LanguageManager.shared.currentLanguage
        switch (self, language) {
        case (.INTJ, .chinese), (.INTP, .chinese), (.ENTJ, .chinese), (.ENTP, .chinese): 
            return "分析师"
        case (.INTJ, .english), (.INTP, .english), (.ENTJ, .english), (.ENTP, .english): 
            return "Analysts"
        case (.INFJ, .chinese), (.INFP, .chinese), (.ENFJ, .chinese), (.ENFP, .chinese): 
            return "外交官"
        case (.INFJ, .english), (.INFP, .english), (.ENFJ, .english), (.ENFP, .english): 
            return "Diplomats"
        case (.ISTJ, .chinese), (.ISFJ, .chinese), (.ESTJ, .chinese), (.ESFJ, .chinese): 
            return "守护者"
        case (.ISTJ, .english), (.ISFJ, .english), (.ESTJ, .english), (.ESFJ, .english): 
            return "Sentinels"
        case (.ISTP, .chinese), (.ISFP, .chinese), (.ESTP, .chinese), (.ESFP, .chinese): 
            return "探险家"
        case (.ISTP, .english), (.ISFP, .english), (.ESTP, .english), (.ESFP, .english): 
            return "Explorers"
        }
    }
}

struct TestQuestion: Codable {
    let id: Int
    let text: String
    let optionA: String
    let optionB: String
    let dimension: MBTIDimension
}

struct QuestionOption: Codable {
    let value: String
    let text: String
}

struct MBTIQuestion: Codable {
    let question: String
    let choice_a: QuestionOption
    let choice_b: QuestionOption
}

struct MBTIQuestionData: Codable {
    let questions: [MBTIQuestion]
}

@Model
final class TestResult {
    var id: UUID
    var mbtiType: String
    var date: Date
    var scores: [String: Double]
    var completionRate: Double
    var answeredQuestions: Int
    var totalQuestions: Int
    
    init(mbtiType: MBTIType, scores: [String: Double]) {
        self.id = UUID()
        self.mbtiType = mbtiType.rawValue
        self.date = Date()
        self.scores = scores
        self.completionRate = 100.0  // Default for completed tests
        self.answeredQuestions = 93
        self.totalQuestions = 93
    }
}

struct PersonalityTrait {
    let dimension: String
    let percentage: Double
    let label: String
}