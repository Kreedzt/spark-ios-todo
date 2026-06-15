//
//  TodoListViewModelTests.swift
//  spark-ios-todoTests
//

import XCTest
import SwiftData
@testable import spark_ios_todo

@MainActor
final class TodoListViewModelTests: XCTestCase {

    private var container: ModelContainer!
    private var context: ModelContext { container.mainContext }

    override func setUpWithError() throws {
        container = try TestSupport.makeInMemoryContainer()
    }

    override func tearDownWithError() throws {
        container = nil
    }

    func testToggleCompletion() throws {
        let vm = TodoListViewModel(modelContext: context)
        let item = TodoItem(title: "任务")
        context.insert(item)

        vm.toggleCompletion(item)
        XCTAssertTrue(item.isCompleted)
        vm.toggleCompletion(item)
        XCTAssertFalse(item.isCompleted)
    }

    func testDelete() throws {
        let vm = TodoListViewModel(modelContext: context)
        let item = TodoItem(title: "删我")
        context.insert(item)
        try context.save()

        vm.delete(item)
        let items = try context.fetch(FetchDescriptor<TodoItem>())
        XCTAssertTrue(items.isEmpty)
    }

    func testSortingIncompleteFirst() throws {
        let vm = TodoListViewModel(modelContext: context)
        let done = TodoItem(title: "已完成", priority: .high, isCompleted: true)
        let pending = TodoItem(title: "未完成", priority: .low)

        let sorted = vm.sorted([done, pending])
        XCTAssertEqual(sorted.first?.title, "未完成")
    }

    func testSortingByPriority() throws {
        let vm = TodoListViewModel(modelContext: context)
        let low = TodoItem(title: "低", priority: .low)
        let high = TodoItem(title: "高", priority: .high)
        let medium = TodoItem(title: "中", priority: .medium)

        let sorted = vm.sorted([low, high, medium])
        XCTAssertEqual(sorted.map(\.title), ["高", "中", "低"])
    }

    func testSortingByDueDateWithinSamePriority() throws {
        let vm = TodoListViewModel(modelContext: context)
        let now = Date()
        let later = TodoItem(title: "晚", priority: .medium, dueDate: now.addingTimeInterval(3600))
        let sooner = TodoItem(title: "早", priority: .medium, dueDate: now)
        let noDate = TodoItem(title: "无日期", priority: .medium)

        let sorted = vm.sorted([later, noDate, sooner])
        XCTAssertEqual(sorted.map(\.title), ["早", "晚", "无日期"])
    }
}
