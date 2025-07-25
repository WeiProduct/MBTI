import SwiftUI

struct TypeDetailView: View {
    let mbtiType: MBTIType
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    TypeHeader(mbtiType: mbtiType)
                    
                    TypeDescription(mbtiType: mbtiType)
                    
                    TypeCharacteristics(mbtiType: mbtiType)
                    
                    TypeCompatibility(mbtiType: mbtiType)
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("关闭")
                    }
                    .buttonStyle(SecondaryButtonStyle())
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .background(Theme.backgroundColor)
            .navigationTitle("\(mbtiType.rawValue) - \(mbtiType.title)")
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

struct TypeHeader: View {
    let mbtiType: MBTIType
    
    var body: some View {
        VStack(spacing: 15) {
            Text(mbtiType.rawValue)
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(Theme.secondaryColor)
            
            Text(mbtiType.title)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(Theme.primaryColor)
            
            Text(mbtiType.category)
                .font(.system(size: 16))
                .foregroundColor(Theme.textSecondary)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(Theme.primaryColor.opacity(0.1))
                .cornerRadius(15)
        }
        .padding()
    }
}

struct TypeDescription: View {
    let mbtiType: MBTIType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("类型描述")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            Text(mbtiType.subtitle)
                .font(.system(size: 15))
                .foregroundColor(Theme.textSecondary)
                .lineSpacing(5)
        }
        .padding()
        .cardStyle()
        .padding(.horizontal)
    }
}

struct TypeCharacteristics: View {
    let mbtiType: MBTIType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("性格特点")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            VStack(alignment: .leading, spacing: 10) {
                ForEach(getCharacteristics(for: mbtiType), id: \.self) { characteristic in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Theme.primaryColor)
                            .font(.system(size: 14))
                        Text(characteristic)
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
    
    func getCharacteristics(for type: MBTIType) -> [String] {
        switch type {
        case .ENFP:
            return ["充满热情和创造力", "善于激励他人", "灵活适应变化", "富有同理心"]
        case .INTJ:
            return ["独立思考", "战略规划能力强", "追求效率", "高标准要求"]
        case .ISFJ:
            return ["忠诚可靠", "关心他人", "注重细节", "责任心强"]
        case .ESTP:
            return ["实际务实", "行动导向", "喜欢冒险", "善于解决问题"]
        default:
            return ["具有独特的思维方式", "在特定领域表现突出", "有自己的价值观体系"]
        }
    }
}

struct TypeCompatibility: View {
    let mbtiType: MBTIType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("类型匹配")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            VStack(spacing: 12) {
                CompatibilityRow(
                    title: "最佳配对",
                    types: getBestMatches(for: mbtiType),
                    color: Theme.successColor
                )
                
                CompatibilityRow(
                    title: "良好配对",
                    types: getGoodMatches(for: mbtiType),
                    color: Theme.primaryColor
                )
            }
        }
        .padding()
        .cardStyle()
        .padding(.horizontal)
    }
    
    func getBestMatches(for type: MBTIType) -> [String] {
        switch type {
        case .ENFP: return ["INTJ", "INFJ"]
        case .INTJ: return ["ENFP", "ENTP"]
        case .ISFJ: return ["ESTP", "ESFP"]
        case .ESTP: return ["ISFJ", "ISTJ"]
        default: return ["ENFJ", "INFJ"]
        }
    }
    
    func getGoodMatches(for type: MBTIType) -> [String] {
        switch type {
        case .ENFP: return ["ENFJ", "INFP", "ENTP"]
        case .INTJ: return ["ENTJ", "INTP", "INFJ"]
        case .ISFJ: return ["ESFJ", "ISFP", "ISTJ"]
        case .ESTP: return ["ESTJ", "ISTP", "ESFP"]
        default: return ["ENFP", "INFP", "ENTP"]
        }
    }
}

struct CompatibilityRow: View {
    let title: String
    let types: [String]
    let color: Color
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(Theme.textSecondary)
                .frame(width: 80, alignment: .leading)
            
            HStack(spacing: 8) {
                ForEach(types, id: \.self) { type in
                    Text(type)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(color)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(color.opacity(0.1))
                        .cornerRadius(12)
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    TypeDetailView(mbtiType: .ENFP)
}