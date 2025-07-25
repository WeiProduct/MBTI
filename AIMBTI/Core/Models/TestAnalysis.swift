import Foundation

struct TestAnalysis {
    let mbtiType: MBTIType
    let dimensionScores: [String: Double]
    let totalQuestions: Int
    let answeredQuestions: Int
    let completionRate: Double
    let dominantTraits: [DominantTrait]
    let reliability: ReliabilityLevel
}

struct DominantTrait {
    let dimension: String
    let percentage: Double
    let strength: TraitStrength
}

enum TraitStrength: String {
    case veryStrong = "非常明显"
    case strong = "明显"
    case moderate = "中等"
    case slight = "轻微"
    
    var englishDescription: String {
        switch self {
        case .veryStrong: return "Very Strong"
        case .strong: return "Strong"
        case .moderate: return "Moderate"
        case .slight: return "Slight"
        }
    }
    
    static func from(percentage: Double) -> TraitStrength {
        if percentage >= 75 {
            return .veryStrong
        } else if percentage >= 65 {
            return .strong
        } else if percentage >= 55 {
            return .moderate
        } else {
            return .slight
        }
    }
}

enum ReliabilityLevel: String {
    case high = "高"
    case medium = "中"
    case low = "低"
    
    var englishDescription: String {
        switch self {
        case .high: return "High"
        case .medium: return "Medium"
        case .low: return "Low"
        }
    }
    
    var color: String {
        switch self {
        case .high: return "27AE60"
        case .medium: return "E67E22"
        case .low: return "E74C3C"
        }
    }
}

extension TestService {
    func analyzeTestResult(answers: [Int: String]) -> TestAnalysis {
        let (mbtiType, scores) = calculateMBTIType(answers: answers)
        
        // 计算完成率
        let totalQuestions = 93
        let answeredQuestions = answers.count
        let completionRate = Double(answeredQuestions) / Double(totalQuestions) * 100
        
        // 分析主导特征
        var dominantTraits: [DominantTrait] = []
        
        let eScore = scores["E"] ?? 50
        let iScore = scores["I"] ?? 50
        if eScore > iScore {
            dominantTraits.append(DominantTrait(
                dimension: "E",
                percentage: eScore,
                strength: TraitStrength.from(percentage: eScore)
            ))
        } else {
            dominantTraits.append(DominantTrait(
                dimension: "I",
                percentage: iScore,
                strength: TraitStrength.from(percentage: iScore)
            ))
        }
        
        let nScore = scores["N"] ?? 50
        let sScore = scores["S"] ?? 50
        if nScore > sScore {
            dominantTraits.append(DominantTrait(
                dimension: "N",
                percentage: nScore,
                strength: TraitStrength.from(percentage: nScore)
            ))
        } else {
            dominantTraits.append(DominantTrait(
                dimension: "S",
                percentage: sScore,
                strength: TraitStrength.from(percentage: sScore)
            ))
        }
        
        let tScore = scores["T"] ?? 50
        let fScore = scores["F"] ?? 50
        if tScore > fScore {
            dominantTraits.append(DominantTrait(
                dimension: "T",
                percentage: tScore,
                strength: TraitStrength.from(percentage: tScore)
            ))
        } else {
            dominantTraits.append(DominantTrait(
                dimension: "F",
                percentage: fScore,
                strength: TraitStrength.from(percentage: fScore)
            ))
        }
        
        let jScore = scores["J"] ?? 50
        let pScore = scores["P"] ?? 50
        if jScore > pScore {
            dominantTraits.append(DominantTrait(
                dimension: "J",
                percentage: jScore,
                strength: TraitStrength.from(percentage: jScore)
            ))
        } else {
            dominantTraits.append(DominantTrait(
                dimension: "P",
                percentage: pScore,
                strength: TraitStrength.from(percentage: pScore)
            ))
        }
        
        // 计算可信度
        let reliability: ReliabilityLevel
        if completionRate >= 90 {
            let avgStrength = dominantTraits.map { $0.percentage }.reduce(0, +) / Double(dominantTraits.count)
            if avgStrength >= 60 {
                reliability = .high
            } else {
                reliability = .medium
            }
        } else if completionRate >= 70 {
            reliability = .medium
        } else {
            reliability = .low
        }
        
        return TestAnalysis(
            mbtiType: mbtiType,
            dimensionScores: scores,
            totalQuestions: totalQuestions,
            answeredQuestions: answeredQuestions,
            completionRate: completionRate,
            dominantTraits: dominantTraits,
            reliability: reliability
        )
    }
}