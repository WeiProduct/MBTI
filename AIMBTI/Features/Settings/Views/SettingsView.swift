import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var showingClearCacheAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    NotificationSettings(viewModel: viewModel)
                    
                    PrivacySettings(viewModel: viewModel)
                    
                    AppSettings(
                        viewModel: viewModel,
                        showingClearCacheAlert: $showingClearCacheAlert
                    )
                    
                    SupportSection()
                }
                .padding(.vertical)
            }
            .background(Theme.backgroundColor)
            .navigationTitle("设置")
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
            .alert("清除缓存", isPresented: $showingClearCacheAlert) {
                Button("取消", role: .cancel) {}
                Button("确认清除", role: .destructive) {
                    viewModel.clearCache()
                }
            } message: {
                Text("确定要清除所有缓存数据吗？")
            }
        }
    }
}

struct NotificationSettings: View {
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("通知设置")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            VStack(spacing: 0) {
                SettingToggle(
                    icon: "bell.fill",
                    title: "每日贴士推送",
                    isOn: $viewModel.dailyTipsEnabled
                )
                
                Divider().padding(.leading, 50)
                
                SettingToggle(
                    icon: "envelope.fill",
                    title: "测试提醒",
                    isOn: $viewModel.testRemindersEnabled
                )
            }
        }
        .padding()
        .cardStyle()
        .padding(.horizontal)
    }
}

struct PrivacySettings: View {
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("隐私设置")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            VStack(spacing: 0) {
                SettingToggle(
                    icon: "eye.slash.fill",
                    title: "匿名模式",
                    isOn: $viewModel.anonymousMode
                )
                
                Divider().padding(.leading, 50)
                
                SettingToggle(
                    icon: "square.and.arrow.up.fill",
                    title: "允许分享结果",
                    isOn: $viewModel.shareResultsEnabled
                )
            }
        }
        .padding()
        .cardStyle()
        .padding(.horizontal)
    }
}

struct AppSettings: View {
    @ObservedObject var viewModel: SettingsViewModel
    @Binding var showingClearCacheAlert: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("应用设置")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            VStack(spacing: 0) {
                SettingRow(
                    icon: "paintpalette.fill",
                    title: "主题颜色",
                    value: viewModel.themeColor
                )
                
                Divider().padding(.leading, 50)
                
                SettingRow(
                    icon: "globe",
                    title: "语言",
                    value: viewModel.appLanguage
                )
                
                Divider().padding(.leading, 50)
                
                Button(action: {
                    showingClearCacheAlert = true
                }) {
                    HStack {
                        Image(systemName: "trash.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Theme.primaryColor)
                            .frame(width: 30)
                        
                        Text("清除缓存")
                            .font(.system(size: 16))
                            .foregroundColor(Theme.textPrimary)
                        
                        Spacer()
                        
                        Text(viewModel.getCacheSize())
                            .font(.system(size: 14))
                            .foregroundColor(Theme.textSecondary)
                    }
                    .padding(.vertical, 15)
                    .padding(.horizontal)
                }
            }
        }
        .padding()
        .cardStyle()
        .padding(.horizontal)
    }
}

struct SupportSection: View {
    var body: some View {
        VStack(spacing: 0) {
            NavigationLink(destination: EmptyView()) {
                SettingRow(
                    icon: "questionmark.circle.fill",
                    title: "帮助与反馈",
                    showChevron: true
                )
            }
            
            Divider().padding(.leading, 50)
            
            NavigationLink(destination: EmptyView()) {
                SettingRow(
                    icon: "shield.fill",
                    title: "隐私政策",
                    showChevron: true
                )
            }
            
            Divider().padding(.leading, 50)
            
            NavigationLink(destination: AboutView()) {
                SettingRow(
                    icon: "info.circle.fill",
                    title: "关于我们",
                    showChevron: true
                )
            }
            
            #if DEBUG
            Divider().padding(.leading, 50)
            
            NavigationLink(destination: DeveloperSettingsView()) {
                SettingRow(
                    icon: "hammer.fill",
                    title: "Developer Settings",
                    showChevron: true
                )
            }
            #endif
        }
        .cardStyle()
        .padding(.horizontal)
    }
}

struct SettingToggle: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Theme.primaryColor)
                .frame(width: 30)
            
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(Theme.textPrimary)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(Theme.primaryColor)
        }
        .padding(.vertical, 15)
        .padding(.horizontal)
    }
}

struct SettingRow: View {
    let icon: String
    let title: String
    var value: String = ""
    var showChevron: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Theme.primaryColor)
                .frame(width: 30)
            
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(Theme.textPrimary)
            
            Spacer()
            
            if !value.isEmpty {
                Text(value)
                    .font(.system(size: 14))
                    .foregroundColor(Theme.textSecondary)
            }
            
            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(Color.gray.opacity(0.5))
            }
        }
        .padding(.vertical, 15)
        .padding(.horizontal)
    }
}

#Preview {
    SettingsView()
}