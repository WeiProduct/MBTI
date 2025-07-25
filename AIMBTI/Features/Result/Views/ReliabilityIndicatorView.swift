import SwiftUI

struct ReliabilityIndicatorView: View {
    let completionRate: Double
    let reliability: ReliabilityLevel
    let answeredQuestions: Int
    let totalQuestions: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(reliabilityAssessmentText)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(completionRateText)
                        .font(.system(size: 14))
                        .foregroundColor(Theme.textSecondary)
                    
                    HStack(spacing: 5) {
                        Text(String(format: "%.0f%%", completionRate))
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Theme.primaryColor)
                        
                        Text("(\(answeredQuestions)/\(totalQuestions))")
                            .font(.system(size: 14))
                            .foregroundColor(Theme.textSecondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    Text(reliabilityLevelText)
                        .font(.system(size: 14))
                        .foregroundColor(Theme.textSecondary)
                    
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color(hex: reliability.color))
                            .frame(width: 12, height: 12)
                        
                        Text(reliabilityDescription)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(hex: reliability.color))
                    }
                }
            }
            
            // Visual reliability indicator
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 10)
                    
                    RoundedRectangle(cornerRadius: 5)
                        .fill(reliabilityGradient)
                        .frame(width: geometry.size.width * completionRate / 100, height: 10)
                }
            }
            .frame(height: 10)
            
            Text(reliabilityNote)
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)
                .italic()
        }
        .padding()
        .cardStyle()
        .padding(.horizontal)
    }
    
    private var reliabilityAssessmentText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "结果可信度评估" : "Result Reliability Assessment"
    }
    
    private var completionRateText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "完成度" : "Completion Rate"
    }
    
    private var reliabilityLevelText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "可信度" : "Reliability"
    }
    
    private var reliabilityDescription: String {
        let language = LanguageManager.shared.currentLanguage
        return language == .chinese ? reliability.rawValue : reliability.englishDescription
    }
    
    private var reliabilityNote: String {
        let language = LanguageManager.shared.currentLanguage
        switch reliability {
        case .high:
            return language == .chinese ?
                "测试结果高度可信，能够准确反映您的人格特征。" :
                "Test results are highly reliable and accurately reflect your personality traits."
        case .medium:
            return language == .chinese ?
                "测试结果基本可信，但建议完成所有题目以获得更准确的结果。" :
                "Test results are moderately reliable, but completing all questions is recommended for more accurate results."
        case .low:
            return language == .chinese ?
                "由于回答题目较少，结果可能不够准确，建议重新完成完整测试。" :
                "Due to limited responses, results may not be accurate. Please consider retaking the complete test."
        }
    }
    
    private var reliabilityGradient: LinearGradient {
        switch reliability {
        case .high:
            return LinearGradient(
                colors: [Theme.successColor.opacity(0.8), Theme.successColor],
                startPoint: .leading,
                endPoint: .trailing
            )
        case .medium:
            return LinearGradient(
                colors: [Color.orange.opacity(0.8), Color.orange],
                startPoint: .leading,
                endPoint: .trailing
            )
        case .low:
            return LinearGradient(
                colors: [Color.red.opacity(0.8), Color.red],
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }
}

#Preview {
    ReliabilityIndicatorView(
        completionRate: 92,
        reliability: .high,
        answeredQuestions: 86,
        totalQuestions: 93
    )
}