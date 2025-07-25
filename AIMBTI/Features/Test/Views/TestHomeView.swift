import SwiftUI
import SwiftData

struct TestHomeView: View {
    @State private var showTestIntro = false
    @State private var showTest = false
    @State private var showContinueAlert = false
    @State private var showDebugTest = false
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                
                VStack(spacing: 25) {
                    Image(systemName: "checkmark.square.fill")
                        .font(.system(size: 80))
                        .foregroundColor(Theme.primaryColor)
                    
                    Text(LocalizedStrings.shared.get("app_name"))
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Theme.secondaryColor)
                    
                    Text(LanguageManager.shared.currentLanguage == .chinese ? 
                         "通过科学的测试方法\n了解你的性格类型" : 
                         "Discover your personality type\nthrough scientific testing")
                        .font(.system(size: 16))
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(5)
                }
                
                Spacer()
                
                Button(action: {
                    Task { @MainActor in
                        if TestProgressService.shared.hasProgress(context: modelContext) {
                            showContinueAlert = true
                        } else {
                            showTestIntro = true
                        }
                    }
                }) {
                    Text(LocalizedStrings.shared.get("start_test"))
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal, 40)
                
                #if DEBUG
                // Debug button to quickly complete test
                Button(action: {
                    showDebugTest = true
                }) {
                    HStack {
                        Image(systemName: "hammer.fill")
                        Text(LanguageManager.shared.currentLanguage == .chinese ? 
                             "调试：快速完成测试" : "Debug: Quick Test")
                    }
                    .font(.system(size: 14, weight: .medium))
                }
                .buttonStyle(SecondaryButtonStyle())
                .padding(.horizontal, 40)
                #endif
                
                Spacer()
                    .frame(height: 50)
            }
            .background(Theme.backgroundColor)
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showTestIntro) {
                TestIntroView(showTest: $showTest)
            }
            .fullScreenCover(isPresented: $showTest) {
                TestView()
            }
            .fullScreenCover(isPresented: $showDebugTest) {
                TestView(autoComplete: true)
            }
            .alert(continueAlertTitle, isPresented: $showContinueAlert) {
                Button(continueTestText) {
                    showTest = true
                }
                Button(startNewTestText) {
                    Task { @MainActor in
                        TestProgressService.shared.deleteProgress(context: modelContext)
                        showTestIntro = true
                    }
                }
                Button(cancelText, role: .cancel) {}
            } message: {
                Text(continueAlertMessage)
            }
        }
    }
    
    private var continueAlertTitle: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "继续测试？" : "Continue Test?"
    }
    
    private var continueAlertMessage: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "检测到您有未完成的测试进度，是否要继续？" :
            "You have an unfinished test. Would you like to continue?"
    }
    
    private var continueTestText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "继续测试" : "Continue Test"
    }
    
    private var startNewTestText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "重新开始" : "Start New Test"
    }
    
    private var cancelText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "取消" : "Cancel"
    }
}

#Preview {
    TestHomeView()
}