import SwiftUI
import Charts

struct ComparisonResultView: View {
    let results: [TestResult]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Type changes overview
                    TypeChangeOverview(results: results)
                    
                    // Dimension comparison chart
                    DimensionComparisonChart(results: results)
                    
                    // Detailed dimension changes
                    DimensionChangeDetails(results: results)
                    
                    // Timeline view
                    TimelineView(results: results)
                }
                .padding(.vertical)
            }
            .background(Theme.backgroundColor)
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(doneText) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var navigationTitle: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "测试结果对比" : "Test Results Comparison"
    }
    
    private var doneText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "完成" : "Done"
    }
}

struct TypeChangeOverview: View {
    let results: [TestResult]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(headerText)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(Array(results.enumerated()), id: \.element.id) { index, result in
                        VStack(spacing: 8) {
                            Text(result.mbtiType)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Theme.primaryColor)
                            
                            if let type = MBTIType(rawValue: result.mbtiType) {
                                Text(type.title)
                                    .font(.system(size: 12))
                                    .foregroundColor(Theme.textSecondary)
                            }
                            
                            Text(formatDate(result.date))
                                .font(.system(size: 10))
                                .foregroundColor(Color.gray)
                            
                            if index > 0 && results[index].mbtiType != results[index-1].mbtiType {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .font(.system(size: 12))
                                    .foregroundColor(.orange)
                            }
                        }
                        .padding()
                        .frame(minWidth: 100)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        
                        if index < results.count - 1 {
                            Image(systemName: "arrow.right")
                                .foregroundColor(Color.gray.opacity(0.5))
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
    
    private var headerText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "类型变化历程" : "Type Evolution"
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}

struct DimensionComparisonChart: View {
    let results: [TestResult]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(headerText)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
                .padding(.horizontal)
            
            Chart {
                ForEach(getDimensionData(), id: \.dimension) { data in
                    ForEach(data.values, id: \.date) { value in
                        LineMark(
                            x: .value("Date", value.date),
                            y: .value("Score", value.score)
                        )
                        .foregroundStyle(by: .value("Dimension", data.dimension))
                        .symbol(by: .value("Dimension", data.dimension))
                    }
                }
            }
            .frame(height: 250)
            .padding(.horizontal)
            .chartYScale(domain: 0...100)
            .chartYAxisLabel(yAxisLabel)
            .chartXAxisLabel(xAxisLabel)
        }
        .padding()
        .cardStyle()
        .padding(.horizontal)
    }
    
    private var headerText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "维度趋势分析" : "Dimension Trend Analysis"
    }
    
    private var yAxisLabel: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "得分 (%)" : "Score (%)"
    }
    
    private var xAxisLabel: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "测试日期" : "Test Date"
    }
    
    private func getDimensionData() -> [DimensionData] {
        let dimensions = ["E", "N", "T", "J"]
        return dimensions.map { dimension in
            DimensionData(
                dimension: dimension,
                values: results.map { result in
                    DimensionValue(
                        date: result.date,
                        score: result.scores[dimension] ?? 50
                    )
                }
            )
        }
    }
}

struct DimensionData {
    let dimension: String
    let values: [DimensionValue]
}

struct DimensionValue {
    let date: Date
    let score: Double
}

struct DimensionChangeDetails: View {
    let results: [TestResult]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(headerText)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            ForEach(getDimensionChanges(), id: \.dimension) { change in
                HStack {
                    Text(change.dimensionName)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Theme.textPrimary)
                        .frame(width: 80, alignment: .leading)
                    
                    HStack(spacing: 5) {
                        Text(String(format: "%.0f%%", change.firstScore))
                            .font(.system(size: 14))
                            .foregroundColor(Theme.textSecondary)
                        
                        Image(systemName: change.trend)
                            .font(.system(size: 12))
                            .foregroundColor(change.trendColor)
                        
                        Text(String(format: "%.0f%%", change.lastScore))
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Theme.primaryColor)
                    }
                    
                    Spacer()
                    
                    Text(change.changeDescription)
                        .font(.system(size: 12))
                        .foregroundColor(change.changeColor)
                }
                .padding(.vertical, 8)
                
                Divider()
            }
        }
        .padding()
        .cardStyle()
        .padding(.horizontal)
    }
    
    private var headerText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "维度变化详情" : "Dimension Change Details"
    }
    
    private func getDimensionChanges() -> [DimensionChange] {
        guard let first = results.first,
              let last = results.last else { return [] }
        
        let dimensions = [
            ("E", "外向 Extraversion"),
            ("I", "内向 Introversion"),
            ("N", "直觉 Intuition"),
            ("S", "感觉 Sensing"),
            ("T", "思考 Thinking"),
            ("F", "情感 Feeling"),
            ("J", "判断 Judging"),
            ("P", "感知 Perceiving")
        ]
        
        return dimensions.compactMap { dimension, name in
            guard let firstScore = first.scores[dimension],
                  let lastScore = last.scores[dimension] else { return nil }
            
            let change = lastScore - firstScore
            var trend = "minus"
            var trendColor = Color.gray
            
            if change > 5 {
                trend = "arrow.up"
                trendColor = .green
            } else if change < -5 {
                trend = "arrow.down"
                trendColor = .red
            }
            
            let language = LanguageManager.shared.currentLanguage
            let changeText: String
            if abs(change) < 5 {
                changeText = language == .chinese ? "稳定" : "Stable"
            } else if change > 0 {
                changeText = language == .chinese ? "+\(Int(change))% 增强" : "+\(Int(change))% Increased"
            } else {
                changeText = language == .chinese ? "\(Int(change))% 减弱" : "\(Int(change))% Decreased"
            }
            
            return DimensionChange(
                dimension: dimension,
                dimensionName: name,
                firstScore: firstScore,
                lastScore: lastScore,
                trend: trend,
                trendColor: trendColor,
                changeDescription: changeText,
                changeColor: abs(change) < 5 ? Color.gray : (change > 0 ? .green : .red)
            )
        }
    }
}

struct DimensionChange {
    let dimension: String
    let dimensionName: String
    let firstScore: Double
    let lastScore: Double
    let trend: String
    let trendColor: Color
    let changeDescription: String
    let changeColor: Color
}

struct TimelineView: View {
    let results: [TestResult]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(headerText)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            ForEach(Array(results.enumerated()), id: \.element.id) { index, result in
                HStack(alignment: .top, spacing: 15) {
                    VStack(spacing: 5) {
                        Circle()
                            .fill(Theme.primaryColor)
                            .frame(width: 12, height: 12)
                        
                        if index < results.count - 1 {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 2, height: 40)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(formatDate(result.date))
                            .font(.system(size: 12))
                            .foregroundColor(Theme.textSecondary)
                        
                        Text(result.mbtiType)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Theme.textPrimary)
                        
                        if let type = MBTIType(rawValue: result.mbtiType) {
                            Text(type.title)
                                .font(.system(size: 14))
                                .foregroundColor(Theme.primaryColor)
                        }
                    }
                    
                    Spacer()
                }
            }
        }
        .padding()
        .cardStyle()
        .padding(.horizontal)
    }
    
    private var headerText: String {
        LanguageManager.shared.currentLanguage == .chinese ?
            "测试时间线" : "Test Timeline"
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}