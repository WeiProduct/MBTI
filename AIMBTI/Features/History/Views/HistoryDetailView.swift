import SwiftUI

struct HistoryDetailView: View {
    let mbtiType: MBTIType
    let date: Date
    let scores: [String: Double]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ResultSummaryCard(
                        mbtiType: mbtiType,
                        date: date
                    )
                    
                    ScoresDetailCard(scores: scores)
                    
                    PersonalityInfoCard(mbtiType: mbtiType)
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("关闭")
                    }
                    .buttonStyle(SecondaryButtonStyle())
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .padding(.top)
            }
            .background(Theme.backgroundColor)
            .navigationTitle("测试详情")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
        }
    }
}

struct ResultSummaryCard: View {
    let mbtiType: MBTIType
    let date: Date
    
    var body: some View {
        VStack(spacing: 15) {
            Text(mbtiType.rawValue)
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
            
            Text(mbtiType.title)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
            
            Text(formatDate(date))
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.vertical, 30)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Theme.secondaryColor, Theme.secondaryColor.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(Theme.cornerRadius)
        .padding(.horizontal)
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "测试时间：yyyy年MM月dd日 HH:mm"
        return formatter.string(from: date)
    }
}

struct ScoresDetailCard: View {
    let scores: [String: Double]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("维度得分")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            VStack(spacing: 20) {
                DimensionScore(
                    leftLabel: "外向 E",
                    rightLabel: "内向 I",
                    leftScore: scores["E"] ?? 0,
                    rightScore: scores["I"] ?? 0
                )
                
                DimensionScore(
                    leftLabel: "直觉 N",
                    rightLabel: "感觉 S",
                    leftScore: scores["N"] ?? 0,
                    rightScore: scores["S"] ?? 0
                )
                
                DimensionScore(
                    leftLabel: "思考 T",
                    rightLabel: "情感 F",
                    leftScore: scores["T"] ?? 0,
                    rightScore: scores["F"] ?? 0
                )
                
                DimensionScore(
                    leftLabel: "判断 J",
                    rightLabel: "感知 P",
                    leftScore: scores["J"] ?? 0,
                    rightScore: scores["P"] ?? 0
                )
            }
        }
        .padding()
        .cardStyle()
        .padding(.horizontal)
    }
}

struct DimensionScore: View {
    let leftLabel: String
    let rightLabel: String
    let leftScore: Double
    let rightScore: Double
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text(leftLabel)
                    .font(.system(size: 14, weight: leftScore > rightScore ? .semibold : .regular))
                    .foregroundColor(leftScore > rightScore ? Theme.primaryColor : Theme.textSecondary)
                
                Spacer()
                
                Text("\(Int(leftScore))% - \(Int(rightScore))%")
                    .font(.system(size: 12))
                    .foregroundColor(Theme.textSecondary)
                
                Spacer()
                
                Text(rightLabel)
                    .font(.system(size: 14, weight: rightScore > leftScore ? .semibold : .regular))
                    .foregroundColor(rightScore > leftScore ? Theme.primaryColor : Theme.textSecondary)
            }
            
            GeometryReader { geometry in
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    HStack(spacing: 0) {
                        Rectangle()
                            .fill(leftScore > rightScore ? Theme.primaryColor : Color.gray.opacity(0.3))
                            .frame(width: geometry.size.width * leftScore / 100, height: 8)
                        
                        Rectangle()
                            .fill(rightScore > leftScore ? Theme.primaryColor : Color.gray.opacity(0.3))
                            .frame(width: geometry.size.width * rightScore / 100, height: 8)
                    }
                    .cornerRadius(4)
                }
            }
            .frame(height: 8)
        }
    }
}

struct PersonalityInfoCard: View {
    let mbtiType: MBTIType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("性格解读")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            Text(mbtiType.subtitle)
                .font(.system(size: 15))
                .foregroundColor(Theme.textSecondary)
                .lineSpacing(5)
            
            Divider()
            
            HStack {
                Label("类型分组", systemImage: "person.3.fill")
                    .font(.system(size: 14))
                    .foregroundColor(Theme.textSecondary)
                
                Spacer()
                
                Text(mbtiType.category)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Theme.primaryColor)
            }
        }
        .padding()
        .cardStyle()
        .padding(.horizontal)
    }
}

#Preview {
    HistoryDetailView(
        mbtiType: .ENFP,
        date: Date(),
        scores: ["E": 78, "I": 22, "N": 85, "S": 15, "F": 65, "T": 35, "P": 60, "J": 40]
    )
}