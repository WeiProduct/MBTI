import SwiftUI
import SwiftData
import Charts

struct ComparisonView: View {
    @Environment(\.dismiss) var dismiss
    @Query(sort: \TestResult.date, order: .reverse) private var allResults: [TestResult]
    @State private var selectedResults: Set<TestResult> = []
    @State private var showingComparison = false
    
    var body: some View {
        NavigationView {
            VStack {
                if allResults.count < 2 {
                    EmptyComparisonView()
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            Text(instructionText)
                                .font(.system(size: 14))
                                .foregroundColor(Theme.textSecondary)
                                .padding(.horizontal)
                            
                            ForEach(allResults) { result in
                                ComparisonSelectionRow(
                                    result: result,
                                    isSelected: selectedResults.contains(result),
                                    onTap: {
                                        toggleSelection(result)
                                    }
                                )
                            }
                            .padding(.horizontal)
                            
                            if selectedResults.count >= 2 {
                                Button(action: {
                                    showingComparison = true
                                }) {
                                    Text(compareButtonText)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .background(Theme.backgroundColor)
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(cancelText) {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingComparison) {
                if selectedResults.count >= 2 {
                    ComparisonResultView(results: Array(selectedResults).sorted { $0.date < $1.date })
                }
            }
        }
    }
    
    private func toggleSelection(_ result: TestResult) {
        if selectedResults.contains(result) {
            selectedResults.remove(result)
        } else {
            if selectedResults.count < 4 { // Limit to 4 comparisons
                selectedResults.insert(result)
            }
        }
    }
    
    private var instructionText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "选择2-4个测试结果进行对比（已选择 \(selectedResults.count) 个）" :
            "Select 2-4 test results to compare (Selected: \(selectedResults.count))"
    }
    
    private var compareButtonText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "开始对比" : "Start Comparison"
    }
    
    private var navigationTitle: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "选择对比项目" : "Select Items to Compare"
    }
    
    private var cancelText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "取消" : "Cancel"
    }
}

struct EmptyComparisonView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 60))
                .foregroundColor(Color.gray.opacity(0.3))
            
            Text(emptyTitle)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Theme.textSecondary)
            
            Text(emptyMessage)
                .font(.system(size: 14))
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
    
    private var emptyTitle: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "测试记录不足" : "Insufficient Test Records"
    }
    
    private var emptyMessage: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "需要至少2个测试结果才能进行对比分析" :
            "At least 2 test results are required for comparison analysis"
    }
}

struct ComparisonSelectionRow: View {
    let result: TestResult
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Circle()
                    .stroke(isSelected ? Theme.primaryColor : Color.gray.opacity(0.3), lineWidth: 2)
                    .background(
                        Circle()
                            .fill(isSelected ? Theme.primaryColor : Color.clear)
                    )
                    .frame(width: 24, height: 24)
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .opacity(isSelected ? 1 : 0)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(result.mbtiType)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Theme.textPrimary)
                    
                    if let type = MBTIType(rawValue: result.mbtiType) {
                        Text(type.title)
                            .font(.system(size: 14))
                            .foregroundColor(Theme.primaryColor)
                    }
                    
                    Text(formatDate(result.date))
                        .font(.system(size: 12))
                        .foregroundColor(Theme.textSecondary)
                }
                
                Spacer()
            }
            .padding()
            .background(isSelected ? Theme.primaryColor.opacity(0.1) : Color.white)
            .cornerRadius(10)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}