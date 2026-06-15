# 极简 TODO

一款基于 **SwiftUI + SwiftData** 的 iOS 待办事项管理应用，采用 **MVVM** 架构。
纯本地持久化、完全离线可用，重启数据不丢失。

## 功能特性

- ✅ 任务的增、删、改、查
- 🏷️ 每条任务支持标题、备注、**优先级**（低/中/高）、**截止日期**
- ☑️ 标记完成状态，列表自动排序（未完成优先 → 优先级 → 截止日期）
- 🔴 逾期截止日期高亮提醒
- 💾 SwiftData 本地持久化，重启不丢失
- 📵 完全离线，零网络依赖
- 🌱 首次启动预置示例任务，便于上手

## 技术栈

| 维度 | 选型 |
| --- | --- |
| UI | SwiftUI |
| 持久化 | SwiftData（`@Model` / `@Query`） |
| 架构 | MVVM（`@Observable` ViewModel） |
| 测试 | XCTest |
| 依赖管理 | Swift Package Manager |

## 项目结构

```text
spark-ios-todo/
├─ App/          应用入口与 SwiftData 容器配置
├─ Models/       TodoItem（@Model）· Priority（枚举）
├─ ViewModels/   TodoListViewModel · TodoFormViewModel（CRUD / 排序）
├─ Views/        列表 / 详情 / 表单 / 设置 + 复用组件
├─ Utilities/    Date+Format（日期格式化）· SampleData（种子数据）
└─ Assets.xcassets

spark-ios-todoTests/   XCTest 单元测试（内存版 ModelContainer 隔离）
scripts/package.sh     项目打包脚本
```

**分层职责**：Model 负责数据与持久化；ViewModel 承载业务逻辑、可单独测试；
View 用 `@Query` 做响应式渲染，保持轻薄。

## 环境要求

- Xcode 16+（项目格式 objectVersion 77）
- iOS 26.5+ 模拟器或真机
- macOS（自带 Swift 工具链）

## 构建与运行

使用 Xcode 打开 `spark-ios-todo.xcodeproj`，选择 iOS 模拟器后直接运行（⌘R）。

命令行构建（若 `xcode-select` 未指向 Xcode，可用 `DEVELOPER_DIR` 临时指定）：

```bash
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
xcodebuild build \
  -project spark-ios-todo.xcodeproj \
  -scheme spark-ios-todo \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

## 运行测试

```bash
xcodebuild test \
  -project spark-ios-todo.xcodeproj \
  -scheme spark-ios-todo \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  -only-testing:spark-ios-todoTests
```

覆盖数据模型、优先级枚举，以及两个 ViewModel 的增删改与排序逻辑，共 17 个用例。