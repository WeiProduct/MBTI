import SwiftUI
import SwiftData

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ProfileHeader(
                        userName: viewModel.userName,
                        mbtiType: viewModel.currentMBTIType
                    )
                    
                    ActionButtons(
                        onShare: { viewModel.showShareSheet = true },
                        onExport: { viewModel.showExportSheet = true },
                        onAchievements: { }
                    )
                    
                    DailyTipCard(tip: viewModel.dailyTip)
                    
                    if let bestMatch = viewModel.getBestMatch() {
                        BestMatchCard(
                            matchType: bestMatch.type,
                            compatibility: bestMatch.compatibility
                        )
                    }
                    
                    MenuSection(
                        onSettings: { viewModel.showSettings = true },
                        onAbout: { viewModel.showAbout = true }
                    )
                }
                .padding(.vertical)
            }
            .background(Theme.backgroundColor)
            .navigationTitle("个人中心")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.loadLatestResult(from: modelContext)
            }
            .sheet(isPresented: $viewModel.showSettings) {
                SettingsView()
            }
            .sheet(isPresented: $viewModel.showAbout) {
                AboutView()
            }
            .sheet(isPresented: $viewModel.showShareSheet) {
                ShareSheet(items: [viewModel.getShareText()])
            }
        }
    }
}

struct ProfileHeader: View {
    let userName: String
    let mbtiType: MBTIType?
    
    var body: some View {
        VStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(Theme.primaryColor)
                    .frame(width: 80, height: 80)
                
                Image(systemName: "person.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
            
            Text(userName)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            if let type = mbtiType {
                Text("\(type.rawValue) - \(type.title)")
                    .font(.system(size: 16))
                    .foregroundColor(Theme.textSecondary)
            } else {
                Text("未测试")
                    .font(.system(size: 16))
                    .foregroundColor(Color.gray)
            }
            
            Button(action: {}) {
                Text("编辑资料")
            }
            .buttonStyle(SecondaryButtonStyle())
        }
        .padding(.top)
    }
}

struct ActionButtons: View {
    let onShare: () -> Void
    let onExport: () -> Void
    let onAchievements: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ActionRow(
                icon: "square.and.arrow.up",
                title: "分享我的结果",
                action: onShare
            )
            
            Divider().padding(.leading, 50)
            
            ActionRow(
                icon: "square.and.arrow.down",
                title: "导出测试报告",
                action: onExport
            )
            
            Divider().padding(.leading, 50)
            
            ActionRow(
                icon: "trophy.fill",
                title: "我的成就",
                action: onAchievements
            )
        }
        .cardStyle()
        .padding(.horizontal)
    }
}

struct ActionRow: View {
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

struct DailyTipCard: View {
    let tip: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("每日人格贴士")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            HStack(alignment: .top, spacing: 15) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Theme.primaryColor)
                
                Text(tip)
                    .font(.system(size: 15))
                    .foregroundColor(Theme.textSecondary)
                    .lineSpacing(3)
            }
            .padding()
            .background(Theme.primaryColor.opacity(0.1))
            .cornerRadius(10)
        }
        .padding()
        .cardStyle()
        .padding(.horizontal)
    }
}

struct BestMatchCard: View {
    let matchType: MBTIType
    let compatibility: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("类型匹配")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("最佳配对：\(matchType.rawValue)")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Theme.textPrimary)
                    
                    Text(matchType.title)
                        .font(.system(size: 14))
                        .foregroundColor(Theme.textSecondary)
                }
                
                Spacer()
                
                VStack {
                    Text("\(compatibility)%")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Theme.successColor)
                    
                    Text("匹配度")
                        .font(.system(size: 12))
                        .foregroundColor(Theme.textSecondary)
                }
            }
        }
        .padding()
        .cardStyle()
        .padding(.horizontal)
    }
}

struct MenuSection: View {
    let onSettings: () -> Void
    let onAbout: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            MenuRow(
                icon: "gearshape.fill",
                title: "设置",
                action: onSettings
            )
            
            Divider().padding(.leading, 50)
            
            MenuRow(
                icon: "info.circle.fill",
                title: "关于我们",
                action: onAbout
            )
        }
        .cardStyle()
        .padding(.horizontal)
    }
}

struct MenuRow: View {
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

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    ProfileView()
        .modelContainer(for: TestResult.self, inMemory: true)
}