//
//  TodoDetailView.swift
//  spark-ios-todo
//
//  任务详情页
//

import SwiftUI
import SwiftData

struct TodoDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var item: TodoItem

    @State private var isEditing = false

    var body: some View {
        List {
            Section {
                HStack {
                    Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .foregroundStyle(item.isCompleted ? Color.accentColor : .secondary)
                    Text(item.title)
                        .font(.title3)
                        .strikethrough(item.isCompleted)
                }
            }

            if !item.notes.isEmpty {
                Section("备注") {
                    Text(item.notes)
                }
            }

            Section("详情") {
                LabeledContent("优先级") {
                    Label(item.priority.displayName, systemImage: item.priority.systemImage)
                        .foregroundStyle(item.priority.color)
                }
                if let dueDate = item.dueDate {
                    LabeledContent("截止日期") {
                        Text(dueDate.fullDescription)
                            .foregroundStyle(
                                !item.isCompleted && dueDate.isOverdue ? .red : .primary
                            )
                    }
                }
                LabeledContent("创建时间", value: item.createdAt.fullDescription)
                LabeledContent("状态", value: item.isCompleted ? "已完成" : "进行中")
            }

            Section {
                Button {
                    item.isCompleted.toggle()
                    try? modelContext.save()
                } label: {
                    Label(
                        item.isCompleted ? "标记为未完成" : "标记为已完成",
                        systemImage: item.isCompleted ? "arrow.uturn.backward.circle" : "checkmark.circle"
                    )
                }
            }
        }
        .navigationTitle("任务详情")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("编辑") { isEditing = true }
            }
        }
        .sheet(isPresented: $isEditing) {
            TodoFormView(item: item)
        }
    }
}

#Preview {
    NavigationStack {
        TodoDetailView(item: TodoItem(title: "示例任务", notes: "一些备注", priority: .high, dueDate: Date()))
    }
    .modelContainer(for: TodoItem.self, inMemory: true)
}
