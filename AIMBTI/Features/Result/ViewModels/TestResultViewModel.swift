import Foundation
import SwiftUI
import SwiftData

class TestResultViewModel: ObservableObject {
    @Published var isSaving = false
    @Published var showDetailedAnalysis = false
    @Published var saveSuccess = false
    @Published var saveError: String?
    
    func saveResult(mbtiType: MBTIType, dimensionScores: [String: Double], modelContext: ModelContext) {
        DLog("Save result button clicked", category: "Database")
        isSaving = true
        saveError = nil
        
        let result = TestResult(mbtiType: mbtiType, scores: dimensionScores)
        modelContext.insert(result)
        
        do {
            try modelContext.save()
            ILog("Successfully saved test result: \(mbtiType.rawValue)", category: "Database")
            isSaving = false
            saveSuccess = true
            
            // Hide success message after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.saveSuccess = false
            }
        } catch {
            ELog("Failed to save result: \(error.localizedDescription)", category: "Database")
            saveError = error.localizedDescription
            isSaving = false
        }
    }
    
    func getPersonalityTraits(from scores: [String: Double]) -> [PersonalityTrait] {
        var traits: [PersonalityTrait] = []
        
        let eScore = scores["E"] ?? 0
        let iScore = scores["I"] ?? 0
        traits.append(PersonalityTrait(
            dimension: eScore > iScore ? "外向型" : "内向型",
            percentage: max(eScore, iScore),
            label: "E/I"
        ))
        
        let nScore = scores["N"] ?? 0
        let sScore = scores["S"] ?? 0
        traits.append(PersonalityTrait(
            dimension: nScore > sScore ? "直觉型" : "感觉型",
            percentage: max(nScore, sScore),
            label: "N/S"
        ))
        
        let tScore = scores["T"] ?? 0
        let fScore = scores["F"] ?? 0
        traits.append(PersonalityTrait(
            dimension: tScore > fScore ? "思考型" : "情感型",
            percentage: max(tScore, fScore),
            label: "T/F"
        ))
        
        let jScore = scores["J"] ?? 0
        let pScore = scores["P"] ?? 0
        traits.append(PersonalityTrait(
            dimension: jScore > pScore ? "判断型" : "感知型",
            percentage: max(jScore, pScore),
            label: "J/P"
        ))
        
        return traits
    }
}