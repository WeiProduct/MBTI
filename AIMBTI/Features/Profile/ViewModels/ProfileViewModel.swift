import Foundation
import SwiftUI
import SwiftData

class ProfileViewModel: ObservableObject {
    @Published var userName: String = "测试用户"
    @Published var currentMBTIType: MBTIType? = nil
    @Published var showSettings = false
    @Published var showAbout = false
    @Published var showShareSheet = false
    @Published var showExportSheet = false
    @Published var dailyTip: String = ""
    
    private let dailyTips: [MBTIType: [String]] = [
        .ENFP: [
            "作为ENFP，今天试着专注完成一项重要任务，你的创造力会让结果超乎想象！",
            "与朋友分享你的新想法，他们的反馈会给你带来意想不到的灵感。",
            "记得给自己一些独处时间，让内心的声音引导你前进。"
        ],
        .INTJ: [
            "今天适合制定长期计划，你的战略思维会帮你看清前进的道路。",
            "试着与他人分享你的想法，团队合作会让你的计划更完善。",
            "不要忘记照顾自己的情绪需求，平衡理性与感性。"
        ]
    ]
    
    private let bestMatches: [MBTIType: (type: MBTIType, compatibility: Int)] = [
        .ENFP: (.INTJ, 95),
        .INTJ: (.ENFP, 95),
        .ISFJ: (.ESTP, 92),
        .ESTP: (.ISFJ, 92)
    ]
    
    func loadLatestResult(from modelContext: ModelContext) {
        let descriptor = FetchDescriptor<TestResult>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        
        do {
            let results = try modelContext.fetch(descriptor)
            if let latestResult = results.first,
               let mbtiType = MBTIType(rawValue: latestResult.mbtiType) {
                currentMBTIType = mbtiType
                updateDailyTip()
            }
        } catch {
            print("Failed to load latest result: \(error)")
        }
    }
    
    func updateDailyTip() {
        guard let type = currentMBTIType,
              let tips = dailyTips[type] else {
            dailyTip = "完成MBTI测试，获取专属于你的每日贴士！"
            return
        }
        
        let randomIndex = Int.random(in: 0..<tips.count)
        dailyTip = tips[randomIndex]
    }
    
    func getBestMatch() -> (type: MBTIType, compatibility: Int)? {
        guard let type = currentMBTIType else { return nil }
        return bestMatches[type] ?? (.ENFJ, 85)
    }
    
    func getShareText() -> String {
        guard let type = currentMBTIType else {
            return "我正在使用MBTI人格测试App，快来发现你的性格类型！"
        }
        
        return """
        我的MBTI人格类型是\(type.rawValue) - \(type.title)
        \(type.subtitle)
        
        快来测试发现你的性格类型吧！
        """
    }
}