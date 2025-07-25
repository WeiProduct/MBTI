import SwiftUI

struct StageCompleteView: View {
    let currentStage: Int
    let totalStages: Int
    let onContinue: () -> Void
    let onPause: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(Theme.successColor)
            
            VStack(spacing: 15) {
                Text(stageCompleteTitle)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                
                Text(stageCompleteMessage)
                    .font(.system(size: 16))
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 20) {
                if currentStage < totalStages {
                    Button(action: onContinue) {
                        Text(continueButtonText)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    
                    Button(action: onPause) {
                        Text(pauseButtonText)
                    }
                    .buttonStyle(SecondaryButtonStyle())
                } else {
                    Button(action: onContinue) {
                        Text(viewResultsText)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .background(Theme.backgroundColor)
    }
    
    private var stageCompleteTitle: String {
        let language = LanguageManager.shared.currentLanguage
        if language == .english {
            return "Stage \(currentStage) Complete!"
        } else {
            return "阶段 \(currentStage) 完成！"
        }
    }
    
    private var stageCompleteMessage: String {
        let language = LanguageManager.shared.currentLanguage
        if currentStage < totalStages {
            if language == .english {
                return "Great job! You can continue to the next stage or take a break."
            } else {
                return "做得很好！你可以继续下一阶段或稍作休息。"
            }
        } else {
            if language == .english {
                return "Congratulations! You have completed all test questions."
            } else {
                return "恭喜！你已完成所有测试题目。"
            }
        }
    }
    
    private var continueButtonText: String {
        let language = LanguageManager.shared.currentLanguage
        if language == .english {
            return "Continue to Next Stage"
        } else {
            return "继续下一阶段"
        }
    }
    
    private var pauseButtonText: String {
        let language = LanguageManager.shared.currentLanguage
        if language == .english {
            return "Save and Exit"
        } else {
            return "保存并退出"
        }
    }
    
    private var viewResultsText: String {
        let language = LanguageManager.shared.currentLanguage
        if language == .english {
            return "View Results"
        } else {
            return "查看结果"
        }
    }
}

#Preview {
    StageCompleteView(
        currentStage: 1,
        totalStages: 3,
        onContinue: {},
        onPause: {}
    )
}