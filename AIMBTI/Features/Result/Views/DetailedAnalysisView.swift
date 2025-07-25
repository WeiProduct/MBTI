import SwiftUI

struct DetailedAnalysisView: View {
    let mbtiType: MBTIType
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    PersonalitySummary(mbtiType: mbtiType)
                    
                    StrengthsCard(mbtiType: mbtiType)
                    
                    CareerCard(mbtiType: mbtiType)
                    
                    RelationshipCard(mbtiType: mbtiType)
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("返回")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .background(Theme.backgroundColor)
            .navigationTitle("\(mbtiType.rawValue) - \(mbtiType.title)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Theme.textPrimary)
                    }
                }
            }
        }
    }
}

struct PersonalitySummary: View {
    let mbtiType: MBTIType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.white)
                Text("性格概述")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            Text(getPersonalitySummary(for: mbtiType))
                .font(.system(size: 15))
                .foregroundColor(.white)
                .lineSpacing(5)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
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
    
    func getPersonalitySummary(for type: MBTIType) -> String {
        switch type {
        case .ENFP:
            return "ENFP型人格充满激情和创造力，是天生的激励者和创新者。你善于发现可能性，激励他人追求梦想。"
        case .INTJ:
            return "INTJ型人格富有想象力和战略性思维，总是能够制定长远的计划并坚定执行。"
        default:
            return "你拥有独特的性格特征，善于在自己的领域发挥所长。"
        }
    }
}

struct StrengthsCard: View {
    let mbtiType: MBTIType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "hand.thumbsup.fill")
                    .foregroundColor(Theme.successColor)
                Text("主要优势")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                ForEach(getStrengths(for: mbtiType), id: \.self) { strength in
                    HStack(alignment: .top, spacing: 10) {
                        Text("•")
                            .foregroundColor(Theme.primaryColor)
                        Text(strength)
                            .font(.system(size: 15))
                            .foregroundColor(Theme.textSecondary)
                    }
                }
            }
        }
        .padding()
        .cardStyle()
        .padding(.horizontal)
    }
    
    func getStrengths(for type: MBTIType) -> [String] {
        switch type {
        case .ENFP:
            return ["富有创造力和想象力", "善于激励和鼓舞他人", "适应能力强，灵活性高", "对人和事物充满热情"]
        case .INTJ:
            return ["战略思维能力强", "独立自主", "高效且有条理", "追求卓越"]
        default:
            return ["具有独特的才能", "在特定领域表现出色", "有自己的处事方式"]
        }
    }
}

struct CareerCard: View {
    let mbtiType: MBTIType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "briefcase.fill")
                    .foregroundColor(Theme.primaryColor)
                Text("职业建议")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(getCareers(for: mbtiType), id: \.self) { career in
                        Text(career)
                            .font(.system(size: 14))
                            .foregroundColor(Theme.secondaryColor)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Theme.primaryColor, lineWidth: 1.5)
                            )
                    }
                }
            }
        }
        .padding()
        .cardStyle()
        .padding(.horizontal)
    }
    
    func getCareers(for type: MBTIType) -> [String] {
        switch type {
        case .ENFP:
            return ["心理咨询师", "教师", "营销专员", "记者", "创意总监"]
        case .INTJ:
            return ["系统分析师", "科学家", "工程师", "律师", "项目经理"]
        default:
            return ["顾问", "专家", "管理者", "创业者"]
        }
    }
}

struct RelationshipCard: View {
    let mbtiType: MBTIType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(Theme.warningColor)
                Text("人际关系")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
            }
            
            Text(getRelationshipAdvice(for: mbtiType))
                .font(.system(size: 15))
                .foregroundColor(Theme.textSecondary)
                .lineSpacing(5)
        }
        .padding()
        .cardStyle()
        .padding(.horizontal)
    }
    
    func getRelationshipAdvice(for type: MBTIType) -> String {
        switch type {
        case .ENFP:
            return "你在人际关系中表现出色，善于理解他人情感，建立深度连接。但需要注意保持边界，避免过度投入。"
        case .INTJ:
            return "你重视深度和质量的关系，倾向于保持小而精的社交圈。在表达情感方面可能需要更多练习。"
        default:
            return "你有自己独特的社交方式，重要的是找到适合自己的人际交往模式。"
        }
    }
}

#Preview {
    DetailedAnalysisView(mbtiType: .ENFP)
}