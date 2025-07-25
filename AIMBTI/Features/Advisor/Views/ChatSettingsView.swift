import SwiftUI

struct ChatSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var chatService = ChatService.shared
    @State private var settings = ChatSettings()
    @State private var hasChanges = false
    
    var body: some View {
        NavigationView {
            Form {
                // AI Personality Section
                Section {
                    Picker(personalityLabel, selection: $settings.aiPersonality) {
                        ForEach(ChatSettings.AIPersonality.allCases, id: \.self) { personality in
                            Text(personality.localizedTitle).tag(personality)
                        }
                    }
                } header: {
                    Text(personalitySectionHeader)
                } footer: {
                    Text(personalityFooterText)
                }
                
                // Response Length Section
                Section {
                    Picker(responseLengthLabel, selection: $settings.responseLength) {
                        ForEach(ChatSettings.ResponseLength.allCases, id: \.self) { length in
                            Text(length.localizedTitle).tag(length)
                        }
                    }
                } header: {
                    Text(responseLengthSectionHeader)
                }
                
                // Focus Areas Section
                Section {
                    ForEach(ChatSettings.FocusArea.allCases, id: \.self) { area in
                        Toggle(isOn: Binding(
                            get: { settings.focusAreas.contains(area) },
                            set: { isOn in
                                if isOn {
                                    settings.focusAreas.insert(area)
                                } else {
                                    settings.focusAreas.remove(area)
                                }
                                hasChanges = true
                            }
                        )) {
                            Label(area.localizedTitle, systemImage: focusAreaIcon(for: area))
                        }
                    }
                } header: {
                    Text(focusAreasSectionHeader)
                } footer: {
                    Text(focusAreasFooterText)
                }
                
                // About Section
                Section {
                    HStack {
                        Text(versionLabel)
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(Theme.textSecondary)
                    }
                    
                    Link(destination: URL(string: "https://openai.com")!) {
                        HStack {
                            Text(poweredByLabel)
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .foregroundColor(Theme.textSecondary)
                        }
                    }
                    
                    #if DEBUG
                    NavigationLink(destination: APIDebugView()) {
                        HStack {
                            Label("API Debug", systemImage: "wrench.and.screwdriver")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Theme.textSecondary)
                        }
                    }
                    #endif
                } header: {
                    Text(aboutSectionHeader)
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(cancelText) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(saveText) {
                        saveSettings()
                    }
                    .disabled(!hasChanges)
                }
            }
            .onAppear {
                loadCurrentSettings()
            }
            .onChange(of: settings.aiPersonality) { _, _ in hasChanges = true }
            .onChange(of: settings.responseLength) { _, _ in hasChanges = true }
        }
    }
    
    // MARK: - Helper Methods
    
    private func loadCurrentSettings() {
        if let data = UserDefaults.standard.data(forKey: "ChatSettings"),
           let loadedSettings = try? JSONDecoder().decode(ChatSettings.self, from: data) {
            settings = loadedSettings
        }
    }
    
    private func saveSettings() {
        chatService.saveSettings(settings)
        hasChanges = false
        dismiss()
    }
    
    private func focusAreaIcon(for area: ChatSettings.FocusArea) -> String {
        switch area {
        case .career:
            return "briefcase.fill"
        case .relationships:
            return "person.2.fill"
        case .health:
            return "heart.fill"
        case .creativity:
            return "paintbrush.fill"
        case .leadership:
            return "star.fill"
        case .learning:
            return "book.fill"
        }
    }
    
    // MARK: - Localized Strings
    
    private var navigationTitle: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "顾问设置" : "Advisor Settings"
    }
    
    private var cancelText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "取消" : "Cancel"
    }
    
    private var saveText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "保存" : "Save"
    }
    
    private var personalitySectionHeader: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "AI性格" : "AI Personality"
    }
    
    private var personalityLabel: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "对话风格" : "Conversation Style"
    }
    
    private var personalityFooterText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "选择AI顾问的对话风格，影响回复的语气和方式" :
            "Choose your AI advisor's conversation style"
    }
    
    private var responseLengthSectionHeader: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "回复长度" : "Response Length"
    }
    
    private var responseLengthLabel: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "偏好长度" : "Preferred Length"
    }
    
    private var focusAreasSectionHeader: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "专注领域" : "Focus Areas"
    }
    
    private var focusAreasFooterText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "选择您希望AI顾问重点关注的领域" :
            "Select areas you want your AI advisor to focus on"
    }
    
    private var aboutSectionHeader: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "关于" : "About"
    }
    
    private var versionLabel: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "版本" : "Version"
    }
    
    private var poweredByLabel: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "技术支持：OpenAI" : "Powered by OpenAI"
    }
}

#Preview {
    ChatSettingsView()
}