import SwiftUI
import SwiftData

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    @Environment(\.modelContext) private var modelContext
    @State private var showingNewTest = false
    @State private var showingComparison = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if viewModel.testResults.isEmpty {
                    EmptyHistoryView(showingNewTest: $showingNewTest)
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            HistoryStatistics(
                                totalTests: viewModel.testResults.count,
                                mostCommonType: viewModel.getMostCommonType(),
                                uniqueTypes: viewModel.getUniqueTypesCount()
                            )
                            
                            VStack(spacing: 0) {
                                ForEach(viewModel.testResults) { result in
                                    HistoryRow(
                                        result: result,
                                        dateString: viewModel.formatDate(result.date),
                                        onTap: {
                                            viewModel.selectedResult = result
                                            viewModel.showingResult = true
                                        },
                                        onDelete: {
                                            viewModel.deleteResult(result, from: modelContext)
                                        }
                                    )
                                }
                            }
                            .cardStyle()
                            .padding(.horizontal)
                            
                            Button(action: {
                                showingNewTest = true
                            }) {
                                Text(retestButtonText)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .padding(.horizontal)
                            .padding(.bottom)
                        }
                        .padding(.top)
                    }
                }
            }
            .background(Theme.backgroundColor)
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewModel.testResults.count >= 2 {
                        Button(action: {
                            showingComparison = true
                        }) {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .foregroundColor(Theme.primaryColor)
                        }
                    }
                }
            }
            .onAppear {
                viewModel.loadResults(from: modelContext)
            }
            .fullScreenCover(isPresented: $showingNewTest) {
                TestView()
            }
            .sheet(isPresented: $viewModel.showingResult) {
                if let result = viewModel.selectedResult,
                   let mbtiType = MBTIType(rawValue: result.mbtiType) {
                    HistoryDetailView(
                        mbtiType: mbtiType,
                        date: result.date,
                        scores: result.scores
                    )
                }
            }
            .sheet(isPresented: $showingComparison) {
                ComparisonView()
            }
        }
    }
    
    private var navigationTitle: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "测试历史" : "Test History"
    }
    
    private var retestButtonText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "重新测试" : "Test Again"
    }
}

struct EmptyHistoryView: View {
    @Binding var showingNewTest: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "clock")
                .font(.system(size: 80))
                .foregroundColor(Color.gray.opacity(0.3))
            
            Text(emptyTitle)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Theme.textSecondary)
            
            Text(emptyMessage)
                .font(.system(size: 16))
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.center)
                .lineSpacing(5)
            
            Button(action: {
                showingNewTest = true
            }) {
                Text(startTestText)
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal, 60)
            
            Spacer()
        }
    }
    
    private var emptyTitle: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "暂无测试记录" : "No Test Records"
    }
    
    private var emptyMessage: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "完成你的第一次MBTI测试\n开始探索自己的性格类型" :
            "Complete your first MBTI test\nand start exploring your personality type"
    }
    
    private var startTestText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "开始测试" : "Start Test"
    }
}

struct HistoryStatistics: View {
    let totalTests: Int
    let mostCommonType: String?
    let uniqueTypes: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundColor(Theme.primaryColor)
                Text(statisticsTitle)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
            }
            
            HStack(spacing: 20) {
                StatisticItem(
                    value: "\(totalTests)",
                    label: totalTestsLabel,
                    icon: "number"
                )
                
                StatisticItem(
                    value: mostCommonType ?? "--",
                    label: mostCommonTypeLabel,
                    icon: "star.fill"
                )
                
                StatisticItem(
                    value: "\(uniqueTypes)",
                    label: uniqueTypesLabel,
                    icon: "person.3.fill"
                )
            }
        }
        .padding()
        .cardStyle()
        .padding(.horizontal)
    }
    
    private var statisticsTitle: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "测试统计" : "Test Statistics"
    }
    
    private var totalTestsLabel: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "总测试次数" : "Total Tests"
    }
    
    private var mostCommonTypeLabel: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "最常见类型" : "Most Common"
    }
    
    private var uniqueTypesLabel: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "不同类型数" : "Unique Types"
    }
}

struct StatisticItem: View {
    let value: String
    let label: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Theme.primaryColor)
            
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Theme.primaryColor)
            
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct HistoryRow: View {
    let result: TestResult
    let dateString: String
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(result.mbtiType)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Theme.textPrimary)
                    
                    if let type = MBTIType(rawValue: result.mbtiType) {
                        Text(type.title)
                            .font(.system(size: 14))
                            .foregroundColor(Theme.primaryColor)
                    }
                    
                    Text(dateString)
                        .font(.system(size: 12))
                        .foregroundColor(Theme.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(Color.gray.opacity(0.5))
            }
            .padding()
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive, action: onDelete) {
                Label(deleteText, systemImage: "trash")
            }
        }
        .background(Color.white)
        
        Divider()
            .padding(.leading)
    }
    
    private var deleteText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "删除" : "Delete"
    }
}

#Preview {
    HistoryView()
        .modelContainer(for: TestResult.self, inMemory: true)
}