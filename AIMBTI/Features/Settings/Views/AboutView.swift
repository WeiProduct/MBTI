import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                AppInfo()
                
                AppDescription()
                
                Features()
                
                ContactSection()
                
                Footer()
            }
            .padding(.vertical)
        }
        .background(Theme.backgroundColor)
        .navigationTitle("关于我们")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                        Text("返回")
                    }
                    .foregroundColor(Theme.textPrimary)
                }
            }
        }
    }
}

struct AppInfo: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 60))
                .foregroundColor(Theme.primaryColor)
            
            Text("MBTI人格测试")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Theme.textPrimary)
            
            Text("版本 2.1.0")
                .font(.system(size: 16))
                .foregroundColor(Theme.textSecondary)
        }
        .padding()
    }
}

struct AppDescription: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("应用简介")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            Text("专业的MBTI人格类型测试应用，基于心理学理论，帮助用户深入了解自己的性格特征、优势劣势，以及在职场和人际关系中的表现。")
                .font(.system(size: 15))
                .foregroundColor(Theme.textSecondary)
                .lineSpacing(5)
        }
        .padding()
        .cardStyle()
        .padding(.horizontal)
    }
}

struct Features: View {
    let features = [
        "科学的MBTI人格测试",
        "详细的性格分析报告",
        "16种人格类型解读",
        "职业发展建议",
        "人际关系指导"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("核心功能")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            VStack(alignment: .leading, spacing: 10) {
                ForEach(features, id: \.self) { feature in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Theme.primaryColor)
                        
                        Text(feature)
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
}

struct ContactSection: View {
    var body: some View {
        VStack(spacing: 0) {
            ContactRow(
                icon: "star.fill",
                title: "给我们评分",
                action: {}
            )
            
            Divider().padding(.leading, 50)
            
            ContactRow(
                icon: "square.and.arrow.up",
                title: "推荐给朋友",
                action: {}
            )
            
            Divider().padding(.leading, 50)
            
            ContactRow(
                icon: "envelope.fill",
                title: "联系我们",
                action: {}
            )
        }
        .cardStyle()
        .padding(.horizontal)
    }
}

struct ContactRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(Theme.primaryColor)
                    .frame(width: 30)
                
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(Theme.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(Color.gray.opacity(0.5))
            }
            .padding(.vertical, 15)
            .padding(.horizontal)
        }
    }
}

struct Footer: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("© 2024 MBTI人格测试 版权所有")
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)
            
            Text("专业 · 科学 · 可信赖")
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)
        }
        .padding(.top, 20)
    }
}

#Preview {
    NavigationView {
        AboutView()
    }
}