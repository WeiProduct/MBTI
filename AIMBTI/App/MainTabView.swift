import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var showWelcome = true
    @State private var showLanguageSelection = false
    @StateObject private var languageManager = LanguageManager.shared
    
    var body: some View {
        Group {
            if showLanguageSelection {
                LanguageSelectionView(showLanguageSelection: $showLanguageSelection)
            } else if showWelcome {
                WelcomeView(showWelcome: $showWelcome)
            } else {
                TabView(selection: $selectedTab) {
                    TestHomeView()
                        .tabItem {
                            Label(LocalizedStrings.shared.get("tab_test"), systemImage: "checkmark.square.fill")
                        }
                        .tag(0)
                    
                    PersonalityTypesView()
                        .tabItem {
                            Label(LocalizedStrings.shared.get("tab_types"), systemImage: "person.3.fill")
                        }
                        .tag(1)
                    
                    PersonalAdvisorView()
                        .tabItem {
                            Label(advisorTabTitle, systemImage: "bubble.left.and.bubble.right.fill")
                        }
                        .tag(2)
                    
                    HistoryView()
                        .tabItem {
                            Label(LocalizedStrings.shared.get("tab_history"), systemImage: "clock.fill")
                        }
                        .tag(3)
                    
                    ProfileView()
                        .tabItem {
                            Label(LocalizedStrings.shared.get("tab_profile"), systemImage: "person.fill")
                        }
                        .tag(4)
                }
                .accentColor(Theme.primaryColor)
            }
        }
        .onAppear {
            if languageManager.isFirstLaunch {
                showLanguageSelection = true
            }
        }
        .withDebugConsole()
        .withDebugMenu()
    }
    
    private var advisorTabTitle: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "顾问" : "Advisor"
    }
}

#Preview {
    MainTabView()
}