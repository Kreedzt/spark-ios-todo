//
//  TestSupport.swift
//  spark-ios-todoTests
//
//  测试共享辅助
//

import SwiftData
@testable import spark_ios_todo

enum TestSupport {
    /// 创建隔离的内存版 ModelContainer，避免污染真实数据。
    /// 调用方需持有返回的容器，否则其 mainContext 在容器释放后将不可用。
    @MainActor
    static func makeInMemoryContainer() throws -> ModelContainer {
        let schema = Schema([TodoItem.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        return try ModelContainer(for: schema, configurations: [configuration])
    }
}
