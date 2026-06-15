---
theme: seriph
background: https://cover.sli.dev
title: 极简 TODO — iOS 待办事项应用
info: |
  ## 极简 TODO
  基于 SwiftUI + SwiftData + MVVM 的 iOS 待办事项管理应用
  项目演示 · 约 5 分钟
class: text-center
transition: slide-left
mdc: true
---

# 极简 TODO

### 基于 SwiftUI + SwiftData 的 iOS 待办事项应用

<div class="pt-8 opacity-80">
  纯本地持久化 · 离线可用 · MVVM 架构
</div>

<div class="abs-br m-6 text-sm opacity-60">
  学号 6476019 · 项目任务 #9
</div>

---
layout: two-cols
---

# 项目任务与目标

被分配任务（ID 末位 9）：

> 创建一个**带本地保存功能**的基础表单应用：文本输入 + 保存按钮，数据持久化到本地，启动时加载显示。

::right::

<div class="pl-6 pt-12">

在此基础上构建一款**极简 TODO**：

- ✅ 任务的增、删、改、查
- 🏷️ 标题 / 备注 / 优先级 / 截止日期
- ☑️ 完成状态标记
- 💾 本地持久化，重启不丢失
- 📵 完全离线，零网络依赖

</div>

---

# 技术选型：为什么是 SwiftData？

<div class="grid grid-cols-3 gap-4 pt-6 text-sm">

<div class="p-4 rounded border border-gray-500">

### UserDefaults
任务要求的示例方案

❌ 只适合**轻量键值**
❌ 无法管理结构化、可查询的任务集合

</div>

<div class="p-4 rounded border border-gray-500">

### Core Data
传统重型方案

⚠️ 模板代码冗长
⚠️ 需 `NSManagedObject` 桥接

</div>

<div class="p-4 rounded border border-green-500">

### SwiftData ✅
WWDC23 现代方案

✅ `@Model` 宏声明，代码极简
✅ 与 SwiftUI 深度集成（`@Query`）
✅ 原生类型 + 自动轻量迁移

</div>

</div>

<div class="pt-8 text-center opacity-80">
技术栈：<b>SwiftUI</b> · <b>SwiftData</b> · <b>MVVM</b> · <b>XCTest</b>
</div>

---
layout: two-cols
---

# 项目架构（MVVM）

```text
spark-ios-todo/
├─ App/          应用入口与容器配置
├─ Models/       TodoItem · Priority
├─ ViewModels/   业务逻辑（CRUD/排序）
├─ Views/        列表 / 详情 / 表单 / 设置
├─ Utilities/    日期格式化 · 种子数据
└─ Tests/        XCTest 单元测试
```

::right::

<div class="pl-6">

**分层职责**

- **Model** — `@Model` 数据 + 持久化
- **ViewModel** — `@Observable`，承载 CRUD 与排序，**可单测**
- **View** — SwiftUI 声明式，`@Query` 响应式渲染

<div class="pt-4 text-sm opacity-80">
关注点分离 · 数据驱动 UI
</div>

</div>

---

# 核心代码：数据模型

```swift {all|1-2|4-11|13}
@Model
final class TodoItem {
    var id: UUID
    var title: String
    var notes: String
    var priority: Priority      // 枚举直接存储
    var dueDate: Date?          // 可选截止日期
    var isCompleted: Bool
    var createdAt: Date
    // init 提供合理默认值 ...
}

enum Priority: Int, Codable, CaseIterable { case low, medium, high }
```

<div class="pt-2 text-sm opacity-80">
一个 <code>@Model</code> 宏即完成建表与持久化映射，无需任何样板代码。
</div>

---

# 核心代码：业务逻辑与持久化

<div class="grid grid-cols-2 gap-4 text-sm">

<div>

**ViewModel 封装 CRUD（可测试）**

```swift
@Observable
final class TodoFormViewModel {
    var title: String
    var isValid: Bool {
      !title.trimmingCharacters(
        in: .whitespacesAndNewlines).isEmpty
    }
    func save(in ctx: ModelContext) -> Bool {
        guard isValid else { return false }
        ctx.insert(TodoItem(title: title, ...))
        try? ctx.save()
        return true
    }
}
```

</div>

<div>

**View 用 @Query 响应式读取**

```swift
struct TodoListView: View {
  @Query private var items: [TodoItem]

  var body: some View {
    List(viewModel.sorted(items)) { item in
      TodoRowView(item: item) {
        viewModel.toggleCompletion(item)
      }
    }
  }
}
```

数据变化 → UI 自动刷新

</div>

</div>

---
layout: center
class: text-center
---

# 功能演示

<div class="grid grid-cols-2 gap-8 pt-4 text-left max-w-2xl mx-auto">

<div>

📋 **任务列表**
未完成优先 · 按优先级 / 截止日期排序

➕ **新建 / 编辑**
表单输入标题、备注、优先级、截止日期

</div>

<div>

☑️ **勾选完成 · 左滑删除**
逾期日期标红提示

⚙️ **设置页**
版本信息 · 一键清空 · 首次启动预置示例

</div>

</div>

<div class="pt-8 opacity-70 text-sm">（现场切换到模拟器演示完整交互流程）</div>

---

# 质量保障：单元测试

<div class="grid grid-cols-2 gap-6">

<div>

使用 **XCTest** + **内存版 ModelContainer** 隔离测试：

- `TodoItemTests` — 模型默认值
- `PriorityTests` — 枚举与排序
- `TodoListViewModelTests` — 增删改 / 排序
- `TodoFormViewModelTests` — 校验 / 新建 / 编辑

</div>

<div class="flex items-center justify-center">

<div class="text-center">
<div class="text-6xl font-bold text-green-400">17 / 17</div>
<div class="pt-2 opacity-80">测试全部通过 ✅</div>
</div>

</div>

</div>

---

# 挑战与解决

<div class="space-y-4 pt-2">

<div class="p-3 rounded border border-gray-500">

**① SwiftData 学习曲线** — 框架较新、资料有限
→ 研读 Apple 官方文档与 WWDC23，逐步实践 `@Model` / `@Query`

</div>

<div class="p-3 rounded border border-gray-500">

**② 测试中 SwiftData 崩溃** — 在内存容器上 fetch/save 触发 `EXC_BREAKPOINT`
→ 根因：辅助函数返回 `mainContext` 后局部 `ModelContainer` 被释放、store 销毁
→ 改为返回容器并由测试类持有保活，全部转绿

</div>

<div class="p-3 rounded border border-gray-500">

**③ SwiftUI 多设备适配** → 自适应布局组件 + 模拟器多机型验证

</div>

</div>

---
layout: center
class: text-center
---

# 总结

<div class="pt-4 text-left max-w-xl mx-auto space-y-3">

- 🎯 完整实现 **CRUD + 本地持久化**，离线完全可用
- 🧱 **MVVM** 分层，逻辑可单测，View 简洁
- ⚡ 实践 **SwiftData / SwiftUI** 现代框架，体会数据驱动 UI
- 🧪 17 项测试守护核心逻辑

</div>

<div class="pt-10 text-2xl">
谢谢！欢迎提问 🙋
</div>
