# AIMBTI - MBTI人格测试iOS应用

基于SwiftUI和极简MVVM架构的MBTI人格测试应用，支持16种人格类型测试、分析和管理。

## 项目结构

```
AIMBTI/
├── App/                        # 应用入口和主要配置
│   └── MainTabView.swift      # 主标签页视图
├── Core/                      # 核心功能模块
│   ├── Models/               # 数据模型
│   │   └── MBTIModels.swift # MBTI相关模型定义
│   ├── Services/             # 业务服务
│   │   └── TestService.swift # 测试服务逻辑
│   ├── Protocols/            # 协议定义
│   │   └── ViewModelProtocol.swift
│   └── Utilities/            # 工具类
│       └── Theme.swift       # 主题和样式定义
├── Features/                  # 功能模块（每个模块独立）
│   ├── Welcome/              # 欢迎页
│   ├── Test/                 # 测试功能
│   ├── Result/               # 结果展示
│   ├── PersonalityTypes/     # 人格类型浏览
│   ├── History/              # 历史记录
│   ├── Profile/              # 个人中心
│   └── Settings/             # 设置
└── Resources/                # 资源文件
```

## 功能模块

每个功能模块都采用MVVM架构，包含：
- **Views**: 视图层，负责UI展示
- **ViewModels**: 视图模型层，处理业务逻辑
- **Models**: 模型层（如需要）

### 已实现功能

1. **欢迎页** - 应用启动引导页面
2. **MBTI测试** - 60道题的完整测试流程
3. **结果展示** - 测试结果分析和详细报告
4. **人格类型浏览** - 16种人格类型介绍
5. **历史记录** - 测试记录管理和统计
6. **个人中心** - 用户信息和成就展示
7. **设置** - 应用设置和隐私管理

### 技术栈

- **SwiftUI** - UI框架
- **SwiftData** - 数据持久化
- **MVVM** - 架构模式
- **Combine** - 响应式编程

## 使用说明

1. 打开Xcode项目文件 `AIMBTI.xcodeproj`
2. 选择目标设备或模拟器
3. 点击运行按钮编译并运行应用

## 架构特点

- **模块化设计**: 每个功能完全独立，便于维护和扩展
- **极简MVVM**: 简化的MVVM实现，避免过度设计
- **统一主题**: 全局主题管理，保持UI一致性
- **数据持久化**: 使用SwiftData保存测试结果

## 扩展指南

添加新功能模块：
1. 在Features文件夹下创建新模块文件夹
2. 创建Views和ViewModels子文件夹
3. 实现视图和视图模型
4. 在MainTabView中添加新标签（如需要）

## 注意事项

- 注册、登录和社区功能暂未实现
- 测试题目可在TestService中修改和扩展
- 主题颜色可在Theme.swift中调整