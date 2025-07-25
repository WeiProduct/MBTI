import Foundation
import SwiftUI

enum Language: String, CaseIterable {
    case chinese = "zh-Hans"
    case english = "en"
    
    var displayName: String {
        switch self {
        case .chinese: return "中文"
        case .english: return "English"
        }
    }
    
    var locale: Locale {
        Locale(identifier: rawValue)
    }
}

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @AppStorage("appLanguage") private var storedLanguage: String = ""
    @Published var currentLanguage: Language = .chinese
    
    private init() {
        if storedLanguage.isEmpty {
            // First time launch
            currentLanguage = .chinese
        } else {
            currentLanguage = Language(rawValue: storedLanguage) ?? .chinese
        }
    }
    
    func setLanguage(_ language: Language) {
        currentLanguage = language
        storedLanguage = language.rawValue
        UserDefaults.standard.set([language.rawValue], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
    
    var isFirstLaunch: Bool {
        storedLanguage.isEmpty
    }
}