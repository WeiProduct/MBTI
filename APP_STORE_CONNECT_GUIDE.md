# App Store Connect 详细配置指南

## 📱 准备工作

### 1. Xcode 项目配置

#### Bundle Identifier
```
com.yourcompany.aimbti
```

#### 版本信息
- Version: 1.0.0
- Build: 1

#### Deployment Target
- iOS 16.0

#### Device Support
- iPhone
- iPad (可选)

### 2. 必需的图标文件

在 Xcode 中配置以下图标：

```
AppIcon.appiconset/
├── Icon-20@2x.png (40x40)
├── Icon-20@3x.png (60x60)
├── Icon-29@2x.png (58x58)
├── Icon-29@3x.png (87x87)
├── Icon-40@2x.png (80x80)
├── Icon-40@3x.png (120x120)
├── Icon-60@2x.png (120x120)
├── Icon-60@3x.png (180x180)
└── Icon-1024.png (1024x1024) - App Store
```

## 🔧 Xcode 构建和上传

### Step 1: 选择正确的 Scheme
1. 选择 `AIMBTI` scheme
2. 选择 `Any iOS Device` 作为目标设备

### Step 2: 更新版本号
1. 选择项目导航器中的 AIMBTI
2. 在 General 标签中更新：
   - Version: 1.0.0
   - Build: 1

### Step 3: Archive 应用
1. Product → Archive
2. 等待构建完成
3. 在 Organizer 中查看 archive

### Step 4: 上传到 App Store Connect
1. 在 Organizer 中选择 archive
2. 点击 "Distribute App"
3. 选择 "App Store Connect"
4. 选择 "Upload"
5. 遵循向导完成上传

## 📝 App Store Connect 配置

### 1. 创建新 App

登录 [App Store Connect](https://appstoreconnect.apple.com) 并创建新 App：

- **平台**: iOS
- **名称**: AIMBTI
- **主要语言**: 简体中文
- **Bundle ID**: com.yourcompany.aimbti
- **SKU**: AIMBTI001

### 2. App 信息配置

#### 基本信息
- **类别**: 生活
- **次要类别**: 教育

#### 年龄分级
选择 "4+" 并确认以下内容均为"无"：
- 卡通或幻想暴力
- 现实暴力
- 成人/性暗示题材
- 亵渎或低俗幽默
- 恐怖/惊悚题材
- 医药/医疗信息
- 赌博模拟

### 3. 定价和销售范围

- **价格**: 免费
- **销售范围**: 选择所有地区

### 4. App 隐私

#### 隐私政策 URL
```
https://weiproduct.github.io/MBTI/privacy-policy.html
```

#### 数据收集
选择 "不收集数据"

### 5. 版本信息

#### 应用预览和截屏

需要上传以下尺寸的截图：

**iPhone 6.7" 显示屏（必需）**
- 1290 x 2796 像素
- 至少 2 张

**iPhone 6.5" 显示屏（推荐）**
- 1242 x 2688 像素

**iPad Pro 12.9"（如支持 iPad）**
- 2048 x 2732 像素

#### 描述信息

**描述**（4000字符限制）：
```
见 APP_STORE_SUBMISSION_GUIDE.md 中的描述
```

**关键词**（100字符限制）：
```
MBTI,性格测试,人格测试,personality test,AI顾问,心理测试,16personalities,性格分析
```

**新功能**（4000字符限制）：
```
全新发布！
• 专业MBTI人格测试
• AI个人顾问功能
• 详细的人格分析报告
• 支持中英文双语
```

**宣传文本**（170字符限制）：
```
通过AI驱动的MBTI测试，深入了解您的人格类型，获得个性化的发展建议。
```

**支持 URL**：
```
https://github.com/WeiProduct/MBTI/issues
```

**营销 URL**（可选）：
```
https://weiproduct.github.io/MBTI/
```

### 6. 审核信息

#### 联系信息
- 名字：[您的名字]
- 姓氏：[您的姓氏]
- 电话：[您的电话]
- 邮箱：[您的邮箱]

#### 演示账户
选择"不需要登录"

#### 备注
```
AIMBTI 是一款MBTI人格测试应用，所有功能均可离线使用。
AI顾问功能通过安全代理访问OpenAI API，不收集用户个人信息。
测试结果仅供参考，不提供医疗建议。
```

## 🎯 提交前检查清单

- [ ] App 图标已配置
- [ ] Launch Screen 已设置
- [ ] 版本号和构建号已更新
- [ ] 已移除所有调试代码
- [ ] 已测试所有主要功能
- [ ] 已准备所有截图
- [ ] 隐私政策链接可访问
- [ ] 服务条款链接可访问
- [ ] App Store Connect 信息填写完整

## 🚀 提交审核

1. 在 App Store Connect 中完成所有必填信息
2. 上传构建版本
3. 选择要提交的构建版本
4. 点击"提交以供审核"
5. 确认所有信息无误
6. 提交

## ⏱ 审核时间

- 通常需要 24-48 小时
- 首次提交可能需要更长时间
- 节假日期间可能延长

## 📞 处理审核反馈

如果被拒绝：
1. 仔细阅读审核团队的反馈
2. 根据反馈修改问题
3. 在"解决方案中心"回复说明
4. 重新提交审核

## 🎉 发布

审核通过后：
1. 可以选择立即发布或定时发布
2. 发布后通常需要几小时在 App Store 显示
3. 监控用户反馈和崩溃报告

祝您上架成功！