//
//  TodoItem.swift
//  spark-ios-todo
//
//  待办任务数据模型（SwiftData）
//

import Foundation
import SwiftData

/// 一条待办任务。通过 SwiftData 持久化到本地。
@Model
final class TodoItem {
    var id: UUID
    var title: String
    var notes: String
    var priority: Priority
    var dueDate: Date?
    var isCompleted: Bool
    var createdAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        notes: String = "",
        priority: Priority = .medium,
        dueDate: Date? = nil,
        isCompleted: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.notes = notes
        self.priority = priority
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.createdAt = createdAt
    }
}
