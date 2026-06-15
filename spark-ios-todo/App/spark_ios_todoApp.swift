//
//  spark_ios_todoApp.swift
//  spark-ios-todo
//
//  应用入口与 SwiftData 容器配置
//

import SwiftUI
import SwiftData

@main
struct spark_ios_todoApp: App {
    let sharedModelContainer: ModelContainer

    init() {
        let schema = Schema([TodoItem.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            sharedModelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("无法创建 ModelContainer: \(error)")
        }
        // 首次启动插入示例数据
        SampleData.seedIfNeeded(sharedModelContainer.mainContext)
    }

    var body: some Scene {
        WindowGroup {
            TodoListView()
        }
        .modelContainer(sharedModelContainer)
    }
}
