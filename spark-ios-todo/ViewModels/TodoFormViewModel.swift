//
//  TodoFormViewModel.swift
//  spark-ios-todo
//
//  新建 / 编辑任务表单的业务逻辑
//

import Foundation
import SwiftData

/// 表单视图模型，支持「新建」与「编辑」两种模式。
@Observable
final class TodoFormViewModel {
    /// 正在编辑的既有任务；为 nil 表示新建模式。
    private let editingItem: TodoItem?

    var title: String
    var notes: String
    var priority: Priority
    var hasDueDate: Bool
    var dueDate: Date

    /// 是否为编辑模式。
    var isEditing: Bool { editingItem != nil }

    /// 标题去除首尾空白后非空即视为有效。
    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// 新建模式初始化。
    init() {
        self.editingItem = nil
        self.title = ""
        self.notes = ""
        self.priority = .medium
        self.hasDueDate = false
        self.dueDate = Date()
    }

    /// 编辑模式初始化，预填既有任务字段。
    init(item: TodoItem) {
        self.editingItem = item
        self.title = item.title
        self.notes = item.notes
        self.priority = item.priority
        self.hasDueDate = item.dueDate != nil
        self.dueDate = item.dueDate ?? Date()
    }

    /// 保存表单：编辑模式更新既有对象，新建模式插入新对象。
    /// - Returns: 是否保存成功（标题无效时返回 false）。
    @discardableResult
    func save(in modelContext: ModelContext) -> Bool {
        guard isValid else { return false }

        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        let resolvedDueDate = hasDueDate ? dueDate : nil

        if let item = editingItem {
            item.title = trimmedTitle
            item.notes = trimmedNotes
            item.priority = priority
            item.dueDate = resolvedDueDate
        } else {
            let newItem = TodoItem(
                title: trimmedTitle,
                notes: trimmedNotes,
                priority: priority,
                dueDate: resolvedDueDate
            )
            modelContext.insert(newItem)
        }

        try? modelContext.save()
        return true
    }
}
