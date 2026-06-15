//
//  TodoListViewModel.swift
//  spark-ios-todo
//
//  任务列表的业务逻辑
//

import Foundation
import SwiftData

/// 负责列表页的 CRUD 操作与排序逻辑。
@Observable
final class TodoListViewModel {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    /// 切换任务完成状态。
    func toggleCompletion(_ item: TodoItem) {
        item.isCompleted.toggle()
        save()
    }

    /// 删除指定任务。
    func delete(_ item: TodoItem) {
        modelContext.delete(item)
        save()
    }

    /// 按列表中的索引删除（用于 onDelete）。
    func delete(at offsets: IndexSet, in items: [TodoItem]) {
        for index in offsets {
            modelContext.delete(items[index])
        }
        save()
    }

    /// 排序：未完成在前；其次按优先级（高在前）；再按截止日期（早在前，无日期排后）。
    func sorted(_ items: [TodoItem]) -> [TodoItem] {
        items.sorted { lhs, rhs in
            if lhs.isCompleted != rhs.isCompleted {
                return !lhs.isCompleted
            }
            if lhs.priority != rhs.priority {
                return lhs.priority.rawValue > rhs.priority.rawValue
            }
            switch (lhs.dueDate, rhs.dueDate) {
            case let (l?, r?): return l < r
            case (_?, nil): return true
            case (nil, _?): return false
            case (nil, nil): return lhs.createdAt > rhs.createdAt
            }
        }
    }

    private func save() {
        try? modelContext.save()
    }
}
