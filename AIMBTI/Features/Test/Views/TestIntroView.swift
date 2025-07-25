import SwiftUI

struct TestIntroView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var showTest: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                ScrollView {
                    VStack(spacing: 20) {
                        IntroCard(
                            icon: "info.circle",
                            title: "关于MBTI测试",
                            description: "MBTI是目前世界上应用最广泛的人格类型测试工具，帮助你了解自己的性格偏好。",
                            iconColor: Theme.primaryColor
                        )
                        
                        IntroCard(
                            icon: "clock",
                            title: "测试时间",
                            description: "大约需要10-15分钟完成60道题目",
                            iconColor: Theme.primaryColor
                        )
                        
                        IntroCard(
                            icon: "heart",
                            title: "答题建议",
                            items: [
                                "请根据第一直觉选择",
                                "选择更符合你真实想法的选项",
                                "没有标准答案，诚实最重要"
                            ],
                            iconColor: Theme.primaryColor
                        )
                    }
                    .padding()
                }
                
                Button(action: {
                    dismiss()
                    showTest = true
                }) {
                    Text("我已了解，开始答题")
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .background(Theme.backgroundColor)
            .navigationTitle("测试说明")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
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

struct IntroCard: View {
    let icon: String
    let title: String
    var description: String? = nil
    var items: [String]? = nil
    let iconColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(iconColor)
                
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
            }
            
            if let description = description {
                Text(description)
                    .font(.system(size: 15))
                    .foregroundColor(Theme.textSecondary)
                    .lineSpacing(3)
            }
            
            if let items = items {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(items, id: \.self) { item in
                        HStack(alignment: .top, spacing: 10) {
                            Text("•")
                                .foregroundColor(Theme.primaryColor)
                            Text(item)
                                .font(.system(size: 15))
                                .foregroundColor(Theme.textSecondary)
                        }
                    }
                }
                .padding(.leading, 10)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }
}

#Preview {
    TestIntroView(showTest: .constant(false))
}