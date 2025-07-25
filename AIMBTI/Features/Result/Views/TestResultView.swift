import SwiftUI
import SwiftData

struct TestResultView: View {
    let mbtiType: MBTIType
    let dimensionScores: [String: Double]
    let testAnalysis: TestAnalysis
    let onDismiss: () -> Void
    
    @StateObject private var viewModel = TestResultViewModel()
    @Environment(\.modelContext) private var modelContext
    @State private var showDetailedAnalysis = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ResultHeader(mbtiType: mbtiType)
                    
                    ReliabilityIndicatorView(
                        completionRate: testAnalysis.completionRate,
                        reliability: testAnalysis.reliability,
                        answeredQuestions: testAnalysis.answeredQuestions,
                        totalQuestions: testAnalysis.totalQuestions
                    )
                    
                    DimensionAnalysisView(dimensionScores: dimensionScores)
                    
                    TraitsCard(
                        traits: viewModel.getPersonalityTraits(from: dimensionScores)
                    )
                    
                    Button(action: {
                        showDetailedAnalysis = true
                    }) {
                        Text(detailedAnalysisButtonText)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .padding(.horizontal)
                    
                    HStack(spacing: 15) {
                        Button(action: {
                            DLog("User tapped save result button", category: "UI")
                            viewModel.saveResult(
                                mbtiType: mbtiType,
                                dimensionScores: dimensionScores,
                                modelContext: modelContext
                            )
                        }) {
                            HStack {
                                if viewModel.isSaving {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                }
                                Text(viewModel.isSaving ? savingText : (viewModel.saveSuccess ? savedText : saveResultText))
                            }
                        }
                        .buttonStyle(SecondaryButtonStyle())
                        .disabled(viewModel.isSaving || viewModel.saveSuccess)
                        
                        Button(action: onDismiss) {
                            Text(completeText)
                        }
                        .buttonStyle(SecondaryButtonStyle())
                    }
                    .padding(.horizontal)
                    
                    if let error = viewModel.saveError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .background(Theme.backgroundColor)
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $showDetailedAnalysis) {
                DetailedAnalysisView(mbtiType: mbtiType)
            }
        }
    }
    
    private var detailedAnalysisButtonText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "查看详细分析" : "View Detailed Analysis"
    }
    
    private var saveResultText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "保存结果" : "Save Result"
    }
    
    private var completeText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "完成" : "Complete"
    }
    
    private var navigationTitle: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "测试完成" : "Test Complete"
    }
    
    private var savingText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "保存中..." : "Saving..."
    }
    
    private var savedText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "已保存" : "Saved"
    }
}

struct ResultHeader: View {
    let mbtiType: MBTIType
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "trophy.fill")
                .font(.system(size: 50))
                .foregroundColor(Theme.primaryColor)
                .scaleEffect(isAnimating ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isAnimating)
            
            Text(yourPersonalityTypeText)
                .font(.system(size: 20))
                .foregroundColor(Theme.textSecondary)
            
            Text(mbtiType.rawValue)
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
                .background(Theme.secondaryColor)
                .cornerRadius(Theme.buttonCornerRadius)
            
            Text(mbtiType.title)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(Theme.primaryColor)
            
            Text(mbtiType.subtitle)
                .font(.system(size: 16))
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .lineSpacing(3)
        }
        .padding()
        .onAppear {
            isAnimating = true
        }
    }
    
    private var yourPersonalityTypeText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "你的人格类型是" : "Your personality type is"
    }
}

struct TraitsCard: View {
    let traits: [PersonalityTrait]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(mainTraitsText)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            ForEach(traits, id: \.dimension) { trait in
                TraitBar(trait: trait)
            }
        }
        .padding()
        .cardStyle()
        .padding(.horizontal)
    }
    
    private var mainTraitsText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "主要特征" : "Main Traits"
    }
}

struct TraitBar: View {
    let trait: PersonalityTrait
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(trait.dimension)
                    .font(.system(size: 14))
                    .foregroundColor(Theme.textPrimary)
                Spacer()
                Text("\(Int(trait.percentage))%")
                    .font(.system(size: 14))
                    .foregroundColor(Theme.textSecondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 6)
                        .cornerRadius(3)
                    
                    Rectangle()
                        .fill(Theme.primaryColor)
                        .frame(width: geometry.size.width * trait.percentage / 100, height: 6)
                        .cornerRadius(3)
                }
            }
            .frame(height: 6)
        }
    }
}

#Preview {
    TestResultView(
        mbtiType: .ENFP,
        dimensionScores: ["E": 78, "I": 22, "N": 85, "S": 15, "F": 65, "T": 35, "P": 60, "J": 40],
        testAnalysis: TestAnalysis(
            mbtiType: .ENFP,
            dimensionScores: ["E": 78, "I": 22, "N": 85, "S": 15, "F": 65, "T": 35, "P": 60, "J": 40],
            totalQuestions: 93,
            answeredQuestions: 86,
            completionRate: 92.5,
            dominantTraits: [
                DominantTrait(dimension: "E", percentage: 78, strength: .veryStrong),
                DominantTrait(dimension: "N", percentage: 85, strength: .veryStrong),
                DominantTrait(dimension: "F", percentage: 65, strength: .strong),
                DominantTrait(dimension: "P", percentage: 60, strength: .moderate)
            ],
            reliability: .high
        ),
        onDismiss: {}
    )
}