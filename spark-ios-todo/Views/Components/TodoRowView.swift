//
//  TodoRowView.swift
//  spark-ios-todo
//
//  任务列表行
//

import SwiftUI

struct TodoRowView: View {
    let item: TodoItem
    /// 点击复选圆圈的回调。
    let onToggle: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(item.isCompleted ? Color.accentColor : .secondary)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.body)
                    .strikethrough(item.isCompleted)
                    .foregroundStyle(item.isCompleted ? .secondary : .primary)

                HStack(spacing: 8) {
                    Label(item.priority.displayName, systemImage: item.priority.systemImage)
                        .font(.caption)
                        .foregroundStyle(item.priority.color)

                    if let dueDate = item.dueDate {
                        Label(dueDate.relativeDescription, systemImage: "calendar")
                            .font(.caption)
                            .foregroundStyle(
                                !item.isCompleted && dueDate.isOverdue ? .red : .secondary
                            )
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        TodoRowView(item: TodoItem(title: "示例任务", priority: .high, dueDate: Date()), onToggle: {})
        TodoRowView(item: TodoItem(title: "已完成任务", isCompleted: true), onToggle: {})
    }
}
