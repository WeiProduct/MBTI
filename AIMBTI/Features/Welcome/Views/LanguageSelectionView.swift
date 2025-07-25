import SwiftUI

struct LanguageSelectionView: View {
    @StateObject private var languageManager = LanguageManager.shared
    @Binding var showLanguageSelection: Bool
    @State private var selectedLanguage: Language?
    @State private var isAnimating = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Theme.secondaryColor, Theme.secondaryColor.opacity(0.8)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    // App Icon and Title
                    VStack(spacing: 20) {
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                            .scaleEffect(isAnimating ? 1.0 : 0.8)
                            .opacity(isAnimating ? 1.0 : 0.5)
                        
                        Text("MBTI")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("请选择您的语言偏好\nPlease select your language preference")
                            .font(.system(size: 18))
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .lineSpacing(5)
                    }
                    
                    Spacer()
                    
                    // Language Selection Buttons
                    HStack(spacing: 20) {
                        // English Button (Left)
                        LanguageButton(
                            language: .english,
                            isSelected: selectedLanguage == .english,
                            action: {
                                withAnimation(.spring()) {
                                    selectedLanguage = .english
                                }
                                hapticFeedback()
                                confirmSelection(.english)
                            }
                        )
                        
                        // Chinese Button (Right)
                        LanguageButton(
                            language: .chinese,
                            isSelected: selectedLanguage == .chinese,
                            action: {
                                withAnimation(.spring()) {
                                    selectedLanguage = .chinese
                                }
                                hapticFeedback()
                                confirmSelection(.chinese)
                            }
                        )
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                isAnimating = true
            }
        }
    }
    
    private func confirmSelection(_ language: Language) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            languageManager.setLanguage(language)
            withAnimation(.easeInOut(duration: 0.3)) {
                showLanguageSelection = false
            }
        }
    }
    
    private func hapticFeedback() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }
}

struct LanguageButton: View {
    let language: Language
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 15) {
                // Flag or Icon
                Text(language == .chinese ? "🇨🇳" : "🇺🇸")
                    .font(.system(size: 60))
                
                // Language Name
                VStack(spacing: 5) {
                    Text(language == .chinese ? "中文" : "English")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(language == .chinese ? "简体中文" : "English")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 180)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Theme.primaryColor : Color.white.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(isSelected ? Theme.primaryColor : Color.white.opacity(0.3), lineWidth: 2)
                    )
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
        }
    }
}

#Preview {
    LanguageSelectionView(showLanguageSelection: .constant(true))
}