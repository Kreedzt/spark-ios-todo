//
//  SettingsView.swift
//  spark-ios-todo
//
//  设置 / 关于页
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var items: [TodoItem]

    @State private var isShowingClearConfirmation = false

    /// 从 Bundle 读取的版本号。
    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }

    var body: some View {
        NavigationStack {
            List {
                Section("关于") {
                    LabeledContent("应用名称", value: "极简 TODO")
                    LabeledContent("版本", value: appVersion)
                    LabeledContent("技术栈", value: "SwiftUI · SwiftData")
                    LabeledContent("任务总数", value: "\(items.count)")
                }

                Section {
                    Button(role: .destructive) {
                        isShowingClearConfirmation = true
                    } label: {
                        Label("清空全部任务", systemImage: "trash")
                    }
                    .disabled(items.isEmpty)
                } footer: {
                    Text("此操作将永久删除所有任务，且无法撤销。")
                }
            }
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") { dismiss() }
                }
            }
            .confirmationDialog(
                "确定要清空全部任务吗？",
                isPresented: $isShowingClearConfirmation,
                titleVisibility: .visible
            ) {
                Button("清空", role: .destructive) { clearAll() }
                Button("取消", role: .cancel) {}
            }
        }
    }

    private func clearAll() {
        for item in items {
            modelContext.delete(item)
        }
        try? modelContext.save()
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: TodoItem.self, inMemory: true)
}
