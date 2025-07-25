import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    @AppStorage("dailyTipsEnabled") var dailyTipsEnabled = true
    @AppStorage("testRemindersEnabled") var testRemindersEnabled = true
    @AppStorage("anonymousMode") var anonymousMode = false
    @AppStorage("shareResultsEnabled") var shareResultsEnabled = true
    @AppStorage("appLanguage") var appLanguage = "中文"
    @AppStorage("themeColor") var themeColor = "橙色"
    
    func clearCache() {
        URLCache.shared.removeAllCachedResponses()
    }
    
    func getCacheSize() -> String {
        let cacheSize = URLCache.shared.currentDiskUsage
        let formatter = ByteCountFormatter()
        formatter.countStyle = .binary
        return formatter.string(fromByteCount: Int64(cacheSize))
    }
}