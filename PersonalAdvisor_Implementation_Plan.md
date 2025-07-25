# Personal Advisor ChatBox Implementation Plan

## 🎯 目标
在MBTI应用中集成一个智能个人顾问，基于用户的MBTI类型提供个性化建议和指导。

## 🔒 安全要求
- **必须使用代理服务器**保护API密钥
- 不在iOS应用中存储任何API密钥
- 使用之前设置的Vercel代理架构

## 📋 详细TODO列表

### Phase 1: 基础架构设置

#### 1.1 更新Vercel代理服务器
- [ ] 在现有代理项目中添加聊天专用端点
- [ ] 创建 `api/chat.js` 处理聊天请求
- [ ] 添加请求限制和用户验证
- [ ] 支持流式响应（如需要）

#### 1.2 数据模型设计
- [ ] 创建 `ChatMessage` 模型
  - [ ] id: UUID
  - [ ] content: String
  - [ ] role: String (user/assistant/system)
  - [ ] timestamp: Date
  - [ ] sessionId: UUID
- [ ] 创建 `ChatSession` 模型
  - [ ] id: UUID
  - [ ] title: String
  - [ ] createdAt: Date
  - [ ] mbtiType: String (用户的MBTI类型)
  - [ ] messages: [ChatMessage]
- [ ] 使用SwiftData进行持久化

### Phase 2: UI设计与实现

#### 2.1 ChatBox界面设计
- [ ] 创建 `PersonalAdvisorView.swift`
  - [ ] 聊天消息列表
  - [ ] 输入框和发送按钮
  - [ ] 加载状态指示器
  - [ ] 消息气泡样式（区分用户/AI）
- [ ] 创建 `ChatBubbleView.swift`
  - [ ] 支持文本消息
  - [ ] 时间戳显示
  - [ ] 动画效果
- [ ] 创建 `ChatInputView.swift`
  - [ ] 文本输入框
  - [ ] 发送按钮
  - [ ] 字符限制提示

#### 2.2 集成到主界面
- [ ] 在TabView中添加"顾问"标签
- [ ] 添加图标和本地化文本
- [ ] 设置导航结构

### Phase 3: 服务层实现

#### 3.1 创建ChatService
```swift
// ChatService.swift
- [ ] 实现消息发送功能
- [ ] 处理系统提示词（基于MBTI类型）
- [ ] 管理会话上下文
- [ ] 错误处理和重试机制
```

#### 3.2 系统提示词设计
- [ ] 为每种MBTI类型创建个性化提示词
- [ ] 包含类型特征和沟通风格
- [ ] 设置顾问角色和专业领域
- [ ] 支持多语言（中/英）

### Phase 4: 核心功能实现

#### 4.1 基础聊天功能
- [ ] 发送和接收消息
- [ ] 显示打字指示器
- [ ] 消息发送失败处理
- [ ] 自动滚动到最新消息

#### 4.2 会话管理
- [ ] 创建新会话
- [ ] 查看历史会话
- [ ] 删除会话
- [ ] 搜索会话内容

#### 4.3 个性化功能
- [ ] 根据MBTI类型调整AI响应风格
- [ ] 提供类型相关的建议模板
- [ ] 智能问题推荐

### Phase 5: 高级功能

#### 5.1 智能建议系统
- [ ] 快捷问题建议
  - [ ] "职业发展建议"
  - [ ] "人际关系指导"
  - [ ] "个人成长方向"
  - [ ] "今日灵感"
- [ ] 基于对话历史的建议
- [ ] 情境感知回复

#### 5.2 个性化设置
- [ ] AI性格设置（专业/友好/幽默）
- [ ] 回复长度偏好
- [ ] 专注领域选择
- [ ] 通知设置

### Phase 6: 优化与完善

#### 6.1 性能优化
- [ ] 消息缓存机制
- [ ] 分页加载历史消息
- [ ] 减少API调用次数
- [ ] 优化UI渲染

#### 6.2 用户体验
- [ ] 添加引导教程
- [ ] 快捷回复功能
- [ ] 语音输入支持（可选）
- [ ] 导出聊天记录

## 🏗️ 技术实现细节

### 1. 安全的API调用流程
```
iOS App → Vercel Proxy → OpenAI API
       ↓
   (no API key)
```

### 2. 系统提示词示例
```swift
func getSystemPrompt(for mbtiType: MBTIType) -> String {
    let language = LanguageManager.shared.currentLanguage
    
    if language == .chinese {
        return """
        你是一位专业的MBTI个人发展顾问，专门为\(mbtiType.rawValue)类型的用户提供指导。
        
        用户特征：
        \(mbtiType.chineseTraits)
        
        沟通原则：
        1. 使用适合\(mbtiType.rawValue)类型的沟通方式
        2. 提供实用和可执行的建议
        3. 保持专业但友好的语气
        4. 根据用户需求调整回复深度
        """
    } else {
        return """
        You are a professional MBTI personal development advisor, specializing in guidance for \(mbtiType.rawValue) personality types.
        
        User characteristics:
        \(mbtiType.englishTraits)
        
        Communication principles:
        1. Use communication style suitable for \(mbtiType.rawValue) types
        2. Provide practical and actionable advice
        3. Maintain professional yet friendly tone
        4. Adjust response depth based on user needs
        """
    }
}
```

### 3. 消息处理流程
```swift
1. 用户输入消息
2. 添加到本地消息列表（显示发送中）
3. 构建API请求（包含历史上下文）
4. 通过代理发送请求
5. 接收响应
6. 更新UI显示AI回复
7. 保存到数据库
```

## 📱 UI设计规范

### 颜色方案
- 用户消息：主题色背景（紫色）
- AI消息：浅灰色背景
- 系统消息：透明背景，斜体文字

### 布局规范
- 消息间距：8pt
- 气泡内边距：12pt
- 最大宽度：屏幕宽度的80%
- 输入框高度：自适应（最小44pt）

## 🚀 实施优先级

1. **高优先级**（核心功能）
   - 基础聊天界面
   - 消息发送/接收
   - 数据持久化
   - MBTI个性化

2. **中优先级**（增强体验）
   - 会话管理
   - 快捷建议
   - 设置页面

3. **低优先级**（未来扩展）
   - 语音功能
   - 高级分析
   - 数据导出

## ⚠️ 注意事项

1. **安全性**
   - 绝不在客户端存储API密钥
   - 验证所有用户输入
   - 限制请求频率

2. **隐私保护**
   - 聊天记录仅存储在本地
   - 提供清除数据选项
   - 不上传个人信息

3. **用户体验**
   - 快速响应时间
   - 优雅的错误处理
   - 离线消息查看

## 📊 成功指标

- [ ] 平均响应时间 < 3秒
- [ ] 崩溃率 < 0.1%
- [ ] 用户满意度 > 4.5/5
- [ ] 日活跃使用率 > 30%