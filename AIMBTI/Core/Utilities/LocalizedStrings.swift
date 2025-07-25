import Foundation

struct LocalizedStrings {
    static let shared = LocalizedStrings()
    
    private let strings: [String: [Language: String]] = [
        // App Name
        "app_name": [.chinese: "MBTI人格测试", .english: "MBTI Personality Test"],
        
        // Landing Page
        "choose_language": [.chinese: "选择语言", .english: "Choose Language"],
        "language_selection_title": [.chinese: "请选择您的语言偏好", .english: "Please select your language preference"],
        
        // Welcome Screen
        "discover_yourself": [.chinese: "发现真实的自己", .english: "Discover Your True Self"],
        "professional_mbti": [.chinese: "专业MBTI人格类型测试\n深度解析你的内在世界", .english: "Professional MBTI Personality Test\nDeep Analysis of Your Inner World"],
        "start_test": [.chinese: "开始测试", .english: "Start Test"],
        "have_account": [.chinese: "已有账号？立即登录", .english: "Have an account? Login now"],
        "test_home_subtitle": [.chinese: "通过科学的测试方法\n了解你的性格类型", .english: "Discover your personality type\nthrough scientific testing"],
        "debug_quick_test": [.chinese: "调试：快速完成测试", .english: "Debug: Quick Test"],
        
        // Tab Bar
        "tab_test": [.chinese: "测试", .english: "Test"],
        "tab_types": [.chinese: "类型", .english: "Types"],
        "tab_history": [.chinese: "历史", .english: "History"],
        "tab_profile": [.chinese: "我的", .english: "Profile"],
        "tab_advisor": [.chinese: "顾问", .english: "Advisor"],
        
        // Test Introduction
        "test_instructions": [.chinese: "测试说明", .english: "Test Instructions"],
        "about_mbti": [.chinese: "关于MBTI测试", .english: "About MBTI Test"],
        "about_mbti_desc": [.chinese: "MBTI是目前世界上应用最广泛的人格类型测试工具，帮助你了解自己的性格偏好。", .english: "MBTI is the world's most widely used personality type assessment tool, helping you understand your personality preferences."],
        "test_time": [.chinese: "测试时间", .english: "Test Duration"],
        "test_time_desc": [.chinese: "大约需要10-15分钟完成60道题目", .english: "Approximately 10-15 minutes to complete 60 questions"],
        "test_tips": [.chinese: "答题建议", .english: "Test Tips"],
        "tip_1": [.chinese: "请根据第一直觉选择", .english: "Choose based on your first instinct"],
        "tip_2": [.chinese: "选择更符合你真实想法的选项", .english: "Select options that best reflect your true thoughts"],
        "tip_3": [.chinese: "没有标准答案，诚实最重要", .english: "There are no right answers, honesty is most important"],
        "understand_start": [.chinese: "我已了解，开始答题", .english: "I understand, start the test"],
        
        // Test Screen
        "personality_test": [.chinese: "人格测试", .english: "Personality Test"],
        "question": [.chinese: "题目", .english: "Question"],
        "previous": [.chinese: "上一题", .english: "Previous"],
        "next": [.chinese: "下一题", .english: "Next"],
        "complete_test": [.chinese: "完成测试", .english: "Complete Test"],
        "exit": [.chinese: "退出", .english: "Exit"],
        "random": [.chinese: "随机", .english: "Random"],
        
        // Results
        "test_complete": [.chinese: "测试完成", .english: "Test Complete"],
        "your_type_is": [.chinese: "你的人格类型是", .english: "Your personality type is"],
        "main_traits": [.chinese: "主要特征", .english: "Main Traits"],
        "view_analysis": [.chinese: "查看详细分析", .english: "View Detailed Analysis"],
        "save_result": [.chinese: "保存结果", .english: "Save Result"],
        "done": [.chinese: "完成", .english: "Done"],
        
        // Personality Traits
        "extrovert": [.chinese: "外向型", .english: "Extrovert"],
        "introvert": [.chinese: "内向型", .english: "Introvert"],
        "intuitive": [.chinese: "直觉型", .english: "Intuitive"],
        "sensing": [.chinese: "感觉型", .english: "Sensing"],
        "thinking": [.chinese: "思考型", .english: "Thinking"],
        "feeling": [.chinese: "情感型", .english: "Feeling"],
        "judging": [.chinese: "判断型", .english: "Judging"],
        "perceiving": [.chinese: "感知型", .english: "Perceiving"],
        
        // Analysis
        "personality_overview": [.chinese: "性格概述", .english: "Personality Overview"],
        "strengths": [.chinese: "主要优势", .english: "Key Strengths"],
        "career_advice": [.chinese: "职业建议", .english: "Career Advice"],
        "relationships": [.chinese: "人际关系", .english: "Relationships"],
        "back": [.chinese: "返回", .english: "Back"],
        
        // Types Screen
        "16_types": [.chinese: "16种人格类型", .english: "16 Personality Types"],
        "all": [.chinese: "全部", .english: "All"],
        "analysts": [.chinese: "分析师", .english: "Analysts"],
        "diplomats": [.chinese: "外交官", .english: "Diplomats"],
        "sentinels": [.chinese: "守护者", .english: "Sentinels"],
        "explorers": [.chinese: "探险家", .english: "Explorers"],
        "your_type": [.chinese: "你的类型", .english: "Your Type"],
        "explore_all": [.chinese: "探索所有MBTI类型", .english: "Explore All MBTI Types"],
        
        // History
        "test_history": [.chinese: "测试历史", .english: "Test History"],
        "my_records": [.chinese: "我的测试记录", .english: "My Test Records"],
        "no_records": [.chinese: "暂无测试记录", .english: "No Test Records"],
        "first_test_hint": [.chinese: "完成你的第一次MBTI测试\n开始探索自己的性格类型", .english: "Complete your first MBTI test\nStart exploring your personality type"],
        "test_statistics": [.chinese: "测试统计", .english: "Test Statistics"],
        "total_tests": [.chinese: "总测试次数", .english: "Total Tests"],
        "common_type": [.chinese: "最常见类型", .english: "Most Common Type"],
        "unique_types": [.chinese: "不同类型数", .english: "Unique Types"],
        "retest": [.chinese: "重新测试", .english: "Retake Test"],
        "view": [.chinese: "查看", .english: "View"],
        "delete": [.chinese: "删除", .english: "Delete"],
        
        // Profile
        "personal_center": [.chinese: "个人中心", .english: "Profile"],
        "edit_profile": [.chinese: "编辑资料", .english: "Edit Profile"],
        "share_result": [.chinese: "分享我的结果", .english: "Share My Result"],
        "export_report": [.chinese: "导出测试报告", .english: "Export Test Report"],
        "achievements": [.chinese: "我的成就", .english: "My Achievements"],
        "daily_tip": [.chinese: "每日人格贴士", .english: "Daily Personality Tip"],
        "type_match": [.chinese: "类型匹配", .english: "Type Match"],
        "best_match": [.chinese: "最佳配对", .english: "Best Match"],
        "compatibility": [.chinese: "匹配度", .english: "Compatibility"],
        "untested": [.chinese: "未测试", .english: "Not Tested"],
        
        // Settings
        "settings": [.chinese: "设置", .english: "Settings"],
        "notifications": [.chinese: "通知设置", .english: "Notification Settings"],
        "daily_tips_push": [.chinese: "每日贴士推送", .english: "Daily Tips Push"],
        "test_reminders": [.chinese: "测试提醒", .english: "Test Reminders"],
        "privacy": [.chinese: "隐私设置", .english: "Privacy Settings"],
        "anonymous_mode": [.chinese: "匿名模式", .english: "Anonymous Mode"],
        "share_allowed": [.chinese: "允许分享结果", .english: "Allow Result Sharing"],
        "app_settings": [.chinese: "应用设置", .english: "App Settings"],
        "theme_color": [.chinese: "主题颜色", .english: "Theme Color"],
        "language": [.chinese: "语言", .english: "Language"],
        "clear_cache": [.chinese: "清除缓存", .english: "Clear Cache"],
        "help_feedback": [.chinese: "帮助与反馈", .english: "Help & Feedback"],
        "privacy_policy": [.chinese: "隐私政策", .english: "Privacy Policy"],
        "about_us": [.chinese: "关于我们", .english: "About Us"],
        
        // About
        "app_intro": [.chinese: "应用简介", .english: "App Introduction"],
        "app_desc": [.chinese: "专业的MBTI人格类型测试应用，基于心理学理论，帮助用户深入了解自己的性格特征、优势劣势，以及在职场和人际关系中的表现。", .english: "A professional MBTI personality type testing app based on psychological theory, helping users deeply understand their personality traits, strengths and weaknesses, and performance in career and relationships."],
        "core_features": [.chinese: "核心功能", .english: "Core Features"],
        "feature_1": [.chinese: "科学的MBTI人格测试", .english: "Scientific MBTI Personality Test"],
        "feature_2": [.chinese: "详细的性格分析报告", .english: "Detailed Personality Analysis Report"],
        "feature_3": [.chinese: "16种人格类型解读", .english: "16 Personality Types Interpretation"],
        "feature_4": [.chinese: "职业发展建议", .english: "Career Development Advice"],
        "feature_5": [.chinese: "人际关系指导", .english: "Interpersonal Relationship Guidance"],
        "rate_us": [.chinese: "给我们评分", .english: "Rate Us"],
        "recommend": [.chinese: "推荐给朋友", .english: "Recommend to Friends"],
        "contact_us": [.chinese: "联系我们", .english: "Contact Us"],
        "version": [.chinese: "版本", .english: "Version"],
        "copyright": [.chinese: "© 2024 MBTI人格测试 版权所有", .english: "© 2024 MBTI Personality Test. All rights reserved."],
        "tagline": [.chinese: "专业 · 科学 · 可信赖", .english: "Professional · Scientific · Trustworthy"],
        
        // Common
        "close": [.chinese: "关闭", .english: "Close"],
        "cancel": [.chinese: "取消", .english: "Cancel"],
        "confirm": [.chinese: "确认", .english: "Confirm"],
        "orange": [.chinese: "橙色", .english: "Orange"],
        "chinese_lang": [.chinese: "中文", .english: "Chinese"],
        "english_lang": [.chinese: "英文", .english: "English"]
    ]
    
    func get(_ key: String) -> String {
        let language = LanguageManager.shared.currentLanguage
        return strings[key]?[language] ?? key
    }
}

// Convenience property wrapper for localized strings
@propertyWrapper
struct Localized {
    private let key: String
    
    init(_ key: String) {
        self.key = key
    }
    
    var wrappedValue: String {
        LocalizedStrings.shared.get(key)
    }
}