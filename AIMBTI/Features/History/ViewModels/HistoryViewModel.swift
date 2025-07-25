import Foundation
import SwiftUI
import SwiftData

class HistoryViewModel: ObservableObject {
    @Published var testResults: [TestResult] = []
    @Published var selectedResult: TestResult?
    @Published var showingResult = false
    
    func loadResults(from modelContext: ModelContext) {
        let descriptor = FetchDescriptor<TestResult>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        
        do {
            testResults = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch results: \(error)")
        }
    }
    
    func deleteResult(_ result: TestResult, from modelContext: ModelContext) {
        modelContext.delete(result)
        
        do {
            try modelContext.save()
            loadResults(from: modelContext)
        } catch {
            print("Failed to delete result: \(error)")
        }
    }
    
    func getMostCommonType() -> String? {
        guard !testResults.isEmpty else { return nil }
        
        let typeCounts = testResults.reduce(into: [String: Int]()) { counts, result in
            counts[result.mbtiType, default: 0] += 1
        }
        
        return typeCounts.max(by: { $0.value < $1.value })?.key
    }
    
    func getUniqueTypesCount() -> Int {
        Set(testResults.map { $0.mbtiType }).count
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
}