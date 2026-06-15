//
//  SampleData.swift
//  spark-ios-todo
//
//  首次启动时插入示例任务
//

import Foundation
import SwiftData

enum SampleData {
    /// UserDefaults 标记键，确保示例数据只插入一次。
    private static let seededKey = "hasSeededSampleData"

    /// 若尚未插入过示例数据，则插入若干条演示任务。
    @MainActor
    static func seedIfNeeded(_ context: ModelContext) {
        let defaults = UserDefaults.standard
        guard !defaults.bool(forKey: seededKey) else { return }

        for item in makeSamples() {
            context.insert(item)
        }
        try? context.save()
        defaults.set(true, forKey: seededKey)
    }

    /// 构造示例任务列表（不同优先级与截止日期）。
    static func makeSamples() -> [TodoItem] {
        let calendar = Calendar.current
        let now = Date()
        return [
            TodoItem(
                title: "欢迎使用极简 TODO",
                notes: "点击右上角「+」新建任务，左滑可删除，点击圆圈标记完成。",
                priority: .high,
                dueDate: calendar.date(byAdding: .day, value: 1, to: now)
            ),
            TodoItem(
                title: "阅读 SwiftData 官方文档",
                notes: "了解 @Model 与 @Query 的用法。",
                priority: .medium,
                dueDate: calendar.date(byAdding: .day, value: 3, to: now)
            ),
            TodoItem(
                title: "购买牛奶和鸡蛋",
                priority: .low
            ),
            TodoItem(
                title: "已完成的示例任务",
                notes: "这是一个已经标记完成的任务。",
                priority: .low,
                isCompleted: true
            )
        ]
    }
}
