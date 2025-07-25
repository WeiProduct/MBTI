import Foundation
import SwiftUI
import SwiftData

class PersonalityTypesViewModel: ObservableObject {
    @Published var selectedCategory: String
    @Published var searchText = ""
    @Published var userMBTIType: MBTIType?
    
    var categories: [String] {
        let language = LanguageManager.shared.currentLanguage
        if language == .chinese {
            return ["全部", "分析师", "外交官", "守护者", "探险家"]
        } else {
            return ["All", "Analysts", "Diplomats", "Sentinels", "Explorers"]
        }
    }
    
    init() {
        let language = LanguageManager.shared.currentLanguage
        self.selectedCategory = language == .chinese ? "全部" : "All"
    }
    
    var filteredTypes: [MBTIType] {
        let allTypes = MBTIType.allCases
        let language = LanguageManager.shared.currentLanguage
        let allCategoryName = language == .chinese ? "全部" : "All"
        
        var filtered = allTypes
        
        if selectedCategory != allCategoryName {
            filtered = filtered.filter { $0.category == selectedCategory }
            DLog("Filtering by category: \(selectedCategory), found \(filtered.count) types", category: "UI")
            if filtered.isEmpty {
                // Log available categories for debugging
                let availableCategories = Set(allTypes.map { $0.category })
                DLog("Available categories: \(availableCategories)", category: "UI")
            }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.rawValue.lowercased().contains(searchText.lowercased()) ||
                $0.title.contains(searchText) ||
                $0.subtitle.lowercased().contains(searchText.lowercased())
            }
        }
        
        return filtered
    }
    
    var groupedTypes: [(String, [MBTIType])] {
        let language = LanguageManager.shared.currentLanguage
        let allCategoryName = language == .chinese ? "全部" : "All"
        
        if selectedCategory == allCategoryName {
            let grouped = Dictionary(grouping: filteredTypes) { $0.category }
            return grouped.sorted { $0.key < $1.key }.map { ($0.key, $0.value) }
        } else {
            return [(selectedCategory, filteredTypes)]
        }
    }
    
    // Load the most recent test result
    func loadUserMBTIType(from context: ModelContext) {
        let descriptor = FetchDescriptor<TestResult>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        
        do {
            let results = try context.fetch(descriptor)
            if let latestResult = results.first {
                userMBTIType = MBTIType(rawValue: latestResult.mbtiType)
                DLog("Loaded user MBTI type: \(latestResult.mbtiType)", category: "Profile")
            } else {
                DLog("No test results found", category: "Profile")
            }
        } catch {
            ELog("Failed to load test results: \(error)", category: "Profile")
        }
    }
}