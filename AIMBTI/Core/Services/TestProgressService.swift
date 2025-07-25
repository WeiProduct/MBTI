import Foundation
import SwiftData

@MainActor
class TestProgressService {
    static let shared = TestProgressService()
    
    private init() {}
    
    func saveProgress(questionIndex: Int, stage: Int, answers: [Int: String], language: String, context: ModelContext) {
        // Delete any existing progress
        let descriptor = FetchDescriptor<TestProgress>()
        if let existingProgress = try? context.fetch(descriptor) {
            for progress in existingProgress {
                context.delete(progress)
            }
        }
        
        // Save new progress
        let progress = TestProgress(
            currentQuestionIndex: questionIndex,
            currentStage: stage,
            answers: answers,
            language: language
        )
        context.insert(progress)
        
        do {
            try context.save()
        } catch {
            print("Failed to save test progress: \(error)")
        }
    }
    
    func loadProgress(context: ModelContext) -> TestProgress? {
        let descriptor = FetchDescriptor<TestProgress>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        
        do {
            let progress = try context.fetch(descriptor)
            return progress.first
        } catch {
            print("Failed to load test progress: \(error)")
            return nil
        }
    }
    
    func deleteProgress(context: ModelContext) {
        let descriptor = FetchDescriptor<TestProgress>()
        
        do {
            let allProgress = try context.fetch(descriptor)
            for progress in allProgress {
                context.delete(progress)
            }
            try context.save()
        } catch {
            print("Failed to delete test progress: \(error)")
        }
    }
    
    func hasProgress(context: ModelContext) -> Bool {
        let descriptor = FetchDescriptor<TestProgress>()
        
        do {
            let progress = try context.fetch(descriptor)
            return !progress.isEmpty
        } catch {
            return false
        }
    }
}