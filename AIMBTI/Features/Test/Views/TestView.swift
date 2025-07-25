import SwiftUI
import SwiftData

struct TestView: View {
    @StateObject private var viewModel = TestViewModel()
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var selectedAnswer: String?
    @State private var showExitAlert = false
    
    var autoComplete: Bool = false
    
    var body: some View {
        NavigationView {
            if viewModel.showStageComplete {
                StageCompleteView(
                    currentStage: viewModel.currentStage,
                    totalStages: viewModel.totalStages,
                    onContinue: {
                        if viewModel.currentStage < viewModel.totalStages {
                            viewModel.continueToNextStage()
                        } else {
                            viewModel.calculateResult()
                        }
                    },
                    onPause: {
                        viewModel.pauseTest()
                        dismiss()
                    }
                )
            } else {
                VStack(spacing: 0) {
                    // 添加退出按钮行
                    HStack {
                        Button(action: {
                            if viewModel.answers.isEmpty {
                                dismiss()
                            } else {
                                showExitAlert = true
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .medium))
                                Text(LocalizedStrings.shared.get("exit"))
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(Theme.primaryColor)
                        }
                        
                        Spacer()
                        
                        #if DEBUG
                        Button(action: {
                            viewModel.randomlyAnswerAllQuestions()
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "wand.and.stars")
                                    .font(.system(size: 14))
                                Text(LocalizedStrings.shared.get("random"))
                                    .font(.system(size: 14))
                            }
                            .foregroundColor(Theme.primaryColor)
                        }
                        #endif
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    
                    Divider()
                    
                    VStack(spacing: 5) {
                        Text(viewModel.stageProgress)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Theme.primaryColor)
                        
                        ProgressHeader(
                            questionNumber: viewModel.questionNumber,
                            progress: viewModel.progress
                        )
                    }
                    
                    if let question = viewModel.currentQuestion {
                        QuestionContent(
                            question: question,
                            selectedAnswer: $selectedAnswer,
                            onAnswerSelected: { answer in
                                viewModel.selectAnswer(answer)
                            }
                        )
                    }
                    
                    NavigationButtons(
                        canGoBack: viewModel.canGoBack,
                        canGoNext: viewModel.canGoNext,
                        isLastQuestion: viewModel.currentQuestionIndex == viewModel.questions.count - 1,
                        onPrevious: {
                            viewModel.previousQuestion()
                            selectedAnswer = viewModel.answers[viewModel.currentQuestion?.id ?? 0]
                        },
                        onNext: {
                            viewModel.nextQuestion()
                            selectedAnswer = viewModel.answers[viewModel.currentQuestion?.id ?? 0]
                        }
                    )
                }
                .background(Theme.backgroundColor)
            }
        }
        .navigationTitle(LocalizedStrings.shared.get("personality_test"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    if viewModel.answers.isEmpty {
                        // No answers yet, just dismiss
                        dismiss()
                    } else {
                        // Show exit confirmation
                        showExitAlert = true
                    }
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(Theme.textPrimary)
                }
            }
            
            #if DEBUG
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.randomlyAnswerAllQuestions()
                }) {
                    HStack {
                        Image(systemName: "wand.and.stars")
                        Text(LanguageManager.shared.currentLanguage == .chinese ? "随机答题" : "Random")
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Theme.primaryColor)
                }
            }
            #endif
        }
        .fullScreenCover(isPresented: $viewModel.showResult) {
            if let result = viewModel.testResult,
               let analysis = viewModel.testAnalysis {
                TestResultView(
                    mbtiType: result,
                    dimensionScores: viewModel.dimensionScores,
                    testAnalysis: analysis,
                    onDismiss: {
                        viewModel.resetTest()
                        dismiss()
                    }
                )
            }
        }
        .onAppear {
            viewModel.setModelContext(modelContext)
            
            #if DEBUG
            if autoComplete {
                // Automatically complete test with random answers
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    viewModel.randomlyAnswerAllQuestions()
                }
            } else {
                viewModel.loadProgress()
                selectedAnswer = viewModel.answers[viewModel.currentQuestion?.id ?? 0]
            }
            #else
            viewModel.loadProgress()
            selectedAnswer = viewModel.answers[viewModel.currentQuestion?.id ?? 0]
            #endif
        }
        .alert(exitAlertTitle, isPresented: $showExitAlert) {
            Button(saveAndExitText) {
                viewModel.pauseTest()
                dismiss()
            }
            Button(exitWithoutSavingText, role: .destructive) {
                // Clear progress and exit
                viewModel.resetTest()
                if let modelContext = viewModel.modelContext {
                    TestProgressService.shared.deleteProgress(context: modelContext)
                }
                dismiss()
            }
            Button(cancelText, role: .cancel) {}
        } message: {
            Text(exitAlertMessage)
        }
    }
    
    // MARK: - Alert Strings
    
    private var exitAlertTitle: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "退出测试？" : "Exit Test?"
    }
    
    private var exitAlertMessage: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "您可以保存当前进度，下次继续测试。" :
            "You can save your progress and continue later."
    }
    
    private var saveAndExitText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "保存并退出" : "Save & Exit"
    }
    
    private var exitWithoutSavingText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "放弃测试" : "Discard Test"
    }
    
    private var cancelText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "继续测试" : "Continue Test"
    }
}

struct ProgressHeader: View {
    let questionNumber: String
    let progress: Double
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Spacer()
                Text(questionNumber)
                    .font(.system(size: 14))
                    .foregroundColor(Theme.textSecondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(Theme.primaryColor)
                        .frame(width: max(0, geometry.size.width * min(1, max(0, progress))), height: 8)
                        .cornerRadius(4)
                        .animation(.easeInOut(duration: 0.3), value: progress)
                }
            }
            .frame(height: 8)
        }
        .padding()
    }
}

struct QuestionContent: View {
    let question: TestQuestion
    @Binding var selectedAnswer: String?
    let onAnswerSelected: (String) -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Text(question.text)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.leading)
                .padding(.horizontal)
                .padding(.top, 20)
            
            VStack(spacing: 15) {
                AnswerOption(
                    label: "A",
                    text: question.optionA,
                    isSelected: selectedAnswer == "A",
                    action: {
                        selectedAnswer = "A"
                        onAnswerSelected("A")
                    }
                )
                
                AnswerOption(
                    label: "B",
                    text: question.optionB,
                    isSelected: selectedAnswer == "B",
                    action: {
                        selectedAnswer = "B"
                        onAnswerSelected("B")
                    }
                )
            }
            .padding(.horizontal)
            
            Spacer()
        }
    }
}

struct AnswerOption: View {
    let label: String
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 15) {
                Text(label)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(isSelected ? Theme.primaryColor : Theme.textPrimary)
                
                Text(text)
                    .font(.system(size: 16))
                    .foregroundColor(Theme.textPrimary)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding()
            .background(isSelected ? Theme.primaryColor.opacity(0.1) : Color.gray.opacity(0.1))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Theme.primaryColor : Color.clear, lineWidth: 2)
            )
            .cornerRadius(10)
        }
    }
}

struct NavigationButtons: View {
    let canGoBack: Bool
    let canGoNext: Bool
    let isLastQuestion: Bool
    let onPrevious: () -> Void
    let onNext: () -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            if canGoBack {
                Button(action: onPrevious) {
                    Text(LocalizedStrings.shared.get("previous"))
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            
            Button(action: onNext) {
                Text(isLastQuestion ? LocalizedStrings.shared.get("complete_test") : LocalizedStrings.shared.get("next"))
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(!canGoNext)
            .opacity(canGoNext ? 1.0 : 0.6)
            .frame(maxWidth: .infinity)
        }
        .padding()
    }
}

#Preview {
    TestView()
}