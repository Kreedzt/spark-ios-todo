# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概览

SwiftUI + SwiftData 的 iOS 待办应用，MVVM 架构，纯本地持久化、完全离线。详细功能见 README.md。

## 构建与测试

`xcode-select` 可能未指向完整 Xcode（`xcodebuild -list` 返回空即是此情况），命令行操作前先指定：

```bash
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
```

构建：
```bash
xcodebuild build -project spark-ios-todo.xcodeproj -scheme spark-ios-todo \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

运行全部单元测试：
```bash
xcodebuild test -project spark-ios-todo.xcodeproj -scheme spark-ios-todo \
  -destination 'platform=iOS Simulator,name=iPhone 17' -only-testing:spark-ios-todoTests
```

运行单个测试类 / 方法（在上面命令追加更细的 `-only-testing`）：
```bash
-only-testing:spark-ios-todoTests/TodoListViewModelTests
-only-testing:spark-ios-todoTests/TodoListViewModelTests/testSortedPutsIncompleteFirst
```

打包源码（排除构建产物/演示稿，输出到 `dist/`）：`./scripts/package.sh`

## 架构约定（修改代码前必读）

- **数据流方向**：View 通过 `@Query` 直接读取 SwiftData，是唯一的响应式数据源；ViewModel **不**持有或订阅查询结果。新增列表/读取场景时优先用 `@Query`，不要在 ViewModel 里缓存数据。
- **ViewModel 职责**：只做变更（CRUD）与纯计算（排序）。`TodoListView` 在 `onAppear` 惰性创建 `TodoListViewModel(modelContext:)`，因为 `modelContext` 来自 `@Environment`，`init` 时尚不可用。新增依赖 modelContext 的 ViewModel 时沿用此惰性模式。
- **排序逻辑集中在 `TodoListViewModel.sorted(_:)`**：多键排序（未完成优先 → 优先级降序 → 截止日期升序，无日期排后 → createdAt）。改排序规则只改这一处，并同步 `TodoListViewModelTests`。
- **表单的新建/编辑统一在 `TodoFormViewModel`**：可选 `editingItem` 区分模式；`save(in:)` 内部对 title/notes 去首尾空白，标题为空返回 `false`。新增可编辑字段时三处同步：两个 `init`、`save(in:)`。
- **持久化保存**：变更后统一调用 `modelContext.save()`（ViewModel 内 `try? save()`）。
- **示例数据**：`SampleData.seedIfNeeded` 用 `UserDefaults` 键 `hasSeededSampleData` 保证只插入一次，在 App `init` 调用。重置体验需清除该键（或重装）。
- **Priority 是 `Int` 原始值枚举**（low=0/medium=1/high=2），UI 展示（displayName/color/systemImage）封装在枚举内；rawValue 的大小关系被排序直接依赖，不要随意改数值。

## 测试约定

- 单元测试必须用 `TestSupport.makeInMemoryContainer()` 创建内存版 `ModelContainer` 做隔离，**调用方需持有返回的容器引用**，否则容器释放后 `mainContext` 不可用。
- 涉及 `ModelContext` 的测试标注 `@MainActor`。
