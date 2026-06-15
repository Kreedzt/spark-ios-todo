//
//  TodoListView.swift
//  spark-ios-todo
//
//  任务列表主页（应用根视图）
//

import SwiftUI
import SwiftData

struct TodoListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [TodoItem]

    @State private var viewModel: TodoListViewModel?
    @State private var isCreating = false
    @State private var isShowingSettings = false

    /// 排序后的任务列表。
    private var sortedItems: [TodoItem] {
        viewModel?.sorted(items) ?? items
    }

    var body: some View {
        NavigationStack {
            Group {
                if items.isEmpty {
                    EmptyStateView()
                } else {
                    list
                }
            }
            .navigationTitle("待办事项")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isShowingSettings = true
                    } label: {
                        Label("设置", systemImage: "gearshape")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isCreating = true
                    } label: {
                        Label("新建任务", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isCreating) {
                TodoFormView()
            }
            .sheet(isPresented: $isShowingSettings) {
                SettingsView()
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = TodoListViewModel(modelContext: modelContext)
            }
        }
    }

    private var list: some View {
        List {
            ForEach(sortedItems) { item in
                NavigationLink {
                    TodoDetailView(item: item)
                } label: {
                    TodoRowView(item: item) {
                        withAnimation { viewModel?.toggleCompletion(item) }
                    }
                }
            }
            .onDelete { offsets in
                viewModel?.delete(at: offsets, in: sortedItems)
            }
        }
    }
}

#Preview {
    TodoListView()
        .modelContainer(for: TodoItem.self, inMemory: true)
}
