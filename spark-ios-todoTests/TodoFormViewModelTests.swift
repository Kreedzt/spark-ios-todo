//
//  TodoFormViewModelTests.swift
//  spark-ios-todoTests
//

import XCTest
import SwiftData
@testable import spark_ios_todo

@MainActor
final class TodoFormViewModelTests: XCTestCase {

    private var container: ModelContainer!
    private var context: ModelContext { container.mainContext }

    override func setUpWithError() throws {
        container = try TestSupport.makeInMemoryContainer()
    }

    override func tearDownWithError() throws {
        container = nil
    }

    func testValidation() {
        let vm = TodoFormViewModel()
        XCTAssertFalse(vm.isValid)
        vm.title = "   "
        XCTAssertFalse(vm.isValid)
        vm.title = "买菜"
        XCTAssertTrue(vm.isValid)
    }

    func testSaveNewItem() throws {
        let vm = TodoFormViewModel()
        vm.title = "  新任务  "
        vm.notes = "备注"
        vm.priority = .high
        vm.hasDueDate = false

        XCTAssertTrue(vm.save(in: context))

        let items = try context.fetch(FetchDescriptor<TodoItem>())
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items.first?.title, "新任务") // 已去除首尾空白
        XCTAssertEqual(items.first?.priority, .high)
        XCTAssertNil(items.first?.dueDate)
    }

    func testSaveInvalidItemFails() throws {
        let vm = TodoFormViewModel()
        vm.title = ""
        XCTAssertFalse(vm.save(in: context))
        let items = try context.fetch(FetchDescriptor<TodoItem>())
        XCTAssertTrue(items.isEmpty)
    }

    func testEditExistingItem() throws {
        let item = TodoItem(title: "原标题", priority: .low)
        context.insert(item)

        let vm = TodoFormViewModel(item: item)
        XCTAssertTrue(vm.isEditing)
        XCTAssertEqual(vm.title, "原标题")

        vm.title = "新标题"
        vm.priority = .high
        XCTAssertTrue(vm.save(in: context))

        XCTAssertEqual(item.title, "新标题")
        XCTAssertEqual(item.priority, .high)

        // 编辑不应新增对象
        let items = try context.fetch(FetchDescriptor<TodoItem>())
        XCTAssertEqual(items.count, 1)
    }

    func testDueDateToggle() throws {
        let vm = TodoFormViewModel()
        vm.title = "带日期"
        vm.hasDueDate = true
        let due = Date()
        vm.dueDate = due
        XCTAssertTrue(vm.save(in: context))

        let item = try context.fetch(FetchDescriptor<TodoItem>()).first
        XCTAssertEqual(item?.dueDate, due)
    }
}
