import SwiftUI

struct DimensionAnalysisView: View {
    let dimensionScores: [String: Double]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(headerText)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            VStack(spacing: 25) {
                DimensionPair(
                    leftDimension: "E",
                    rightDimension: "I",
                    leftLabel: extraversionLabel,
                    rightLabel: introversionLabel,
                    leftScore: dimensionScores["E"] ?? 50,
                    rightScore: dimensionScores["I"] ?? 50
                )
                
                DimensionPair(
                    leftDimension: "N",
                    rightDimension: "S",
                    leftLabel: intuitionLabel,
                    rightLabel: sensingLabel,
                    leftScore: dimensionScores["N"] ?? 50,
                    rightScore: dimensionScores["S"] ?? 50
                )
                
                DimensionPair(
                    leftDimension: "T",
                    rightDimension: "F",
                    leftLabel: thinkingLabel,
                    rightLabel: feelingLabel,
                    leftScore: dimensionScores["T"] ?? 50,
                    rightScore: dimensionScores["F"] ?? 50
                )
                
                DimensionPair(
                    leftDimension: "J",
                    rightDimension: "P",
                    leftLabel: judgingLabel,
                    rightLabel: perceivingLabel,
                    leftScore: dimensionScores["J"] ?? 50,
                    rightScore: dimensionScores["P"] ?? 50
                )
            }
        }
        .padding()
        .cardStyle()
        .padding(.horizontal)
    }
    
    private var headerText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "维度分析" : "Dimension Analysis"
    }
    
    private var extraversionLabel: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "外向" : "Extraversion"
    }
    
    private var introversionLabel: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "内向" : "Introversion"
    }
    
    private var intuitionLabel: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "直觉" : "Intuition"
    }
    
    private var sensingLabel: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "感觉" : "Sensing"
    }
    
    private var thinkingLabel: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "思考" : "Thinking"
    }
    
    private var feelingLabel: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "情感" : "Feeling"
    }
    
    private var judgingLabel: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "判断" : "Judging"
    }
    
    private var perceivingLabel: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "感知" : "Perceiving"
    }
}

struct DimensionPair: View {
    let leftDimension: String
    let rightDimension: String
    let leftLabel: String
    let rightLabel: String
    let leftScore: Double
    let rightScore: Double
    
    private var dominantSide: String {
        leftScore > rightScore ? leftDimension : rightDimension
    }
    
    private var dominantScore: Double {
        max(leftScore, rightScore)
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("\(leftDimension) - \(leftLabel)")
                    .font(.system(size: 14, weight: dominantSide == leftDimension ? .semibold : .regular))
                    .foregroundColor(dominantSide == leftDimension ? Theme.primaryColor : Theme.textSecondary)
                
                Spacer()
                
                Text("\(rightDimension) - \(rightLabel)")
                    .font(.system(size: 14, weight: dominantSide == rightDimension ? .semibold : .regular))
                    .foregroundColor(dominantSide == rightDimension ? Theme.primaryColor : Theme.textSecondary)
            }
            
            GeometryReader { geometry in
                ZStack {
                    // Background bar
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 30)
                    
                    // Left score bar
                    HStack(spacing: 0) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(dominantSide == leftDimension ? Theme.primaryColor : Color.gray.opacity(0.3))
                            .frame(width: geometry.size.width * leftScore / 100, height: 30)
                        
                        Spacer(minLength: 0)
                    }
                    
                    // Center divider
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 2, height: 30)
                        .position(x: geometry.size.width / 2, y: 15)
                    
                    // Percentage labels
                    HStack {
                        Text(String(format: "%.0f%%", leftScore))
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                        
                        Spacer()
                        
                        Text(String(format: "%.0f%%", rightScore))
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(dominantSide == rightDimension ? .white : Theme.textSecondary)
                            .padding(.horizontal, 10)
                    }
                }
            }
            .frame(height: 30)
            
            // Strength indicator
            HStack {
                Spacer()
                Text(strengthText)
                    .font(.system(size: 12))
                    .foregroundColor(strengthColor)
                Spacer()
            }
        }
    }
    
    private var strengthText: String {
        let language = LanguageManager.shared.currentLanguage
        let strength = TraitStrength.from(percentage: dominantScore)
        return language == .chinese ? strength.rawValue : strength.englishDescription
    }
    
    private var strengthColor: Color {
        let strength = TraitStrength.from(percentage: dominantScore)
        switch strength {
        case .veryStrong:
            return Theme.successColor
        case .strong:
            return Theme.primaryColor
        case .moderate:
            return Color.orange
        case .slight:
            return Theme.textSecondary
        }
    }
}

#Preview {
    DimensionAnalysisView(
        dimensionScores: ["E": 78, "I": 22, "N": 85, "S": 15, "T": 35, "F": 65, "J": 40, "P": 60]
    )
}