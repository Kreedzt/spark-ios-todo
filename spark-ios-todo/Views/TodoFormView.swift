//
//  TodoFormView.swift
//  spark-ios-todo
//
//  新建 / 编辑任务表单
//

import SwiftUI
import SwiftData

struct TodoFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: TodoFormViewModel

    /// 新建模式。
    init() {
        _viewModel = State(initialValue: TodoFormViewModel())
    }

    /// 编辑模式。
    init(item: TodoItem) {
        _viewModel = State(initialValue: TodoFormViewModel(item: item))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("标题") {
                    TextField("输入任务标题", text: $viewModel.title)
                }

                Section("备注") {
                    TextField("添加备注（可选）", text: $viewModel.notes, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section("优先级") {
                    Picker("优先级", selection: $viewModel.priority) {
                        ForEach(Priority.allCases) { priority in
                            Label(priority.displayName, systemImage: priority.systemImage)
                                .tag(priority)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("截止日期") {
                    Toggle("设置截止日期", isOn: $viewModel.hasDueDate.animation())
                    if viewModel.hasDueDate {
                        DatePicker(
                            "截止日期",
                            selection: $viewModel.dueDate,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                    }
                }
            }
            .navigationTitle(viewModel.isEditing ? "编辑任务" : "新建任务")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        if viewModel.save(in: modelContext) {
                            dismiss()
                        }
                    }
                    .disabled(!viewModel.isValid)
                }
            }
        }
    }
}

#Preview("新建") {
    TodoFormView()
        .modelContainer(for: TodoItem.self, inMemory: true)
}
