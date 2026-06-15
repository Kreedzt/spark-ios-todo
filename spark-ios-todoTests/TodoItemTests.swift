//
//  TodoItemTests.swift
//  spark-ios-todoTests
//

import XCTest
@testable import spark_ios_todo

final class TodoItemTests: XCTestCase {

    func testDefaultValues() {
        let item = TodoItem(title: "测试任务")
        XCTAssertEqual(item.title, "测试任务")
        XCTAssertEqual(item.notes, "")
        XCTAssertEqual(item.priority, .medium)
        XCTAssertNil(item.dueDate)
        XCTAssertFalse(item.isCompleted)
    }

    func testCustomValues() {
        let due = Date()
        let item = TodoItem(
            title: "完整任务",
            notes: "备注",
            priority: .high,
            dueDate: due,
            isCompleted: true
        )
        XCTAssertEqual(item.notes, "备注")
        XCTAssertEqual(item.priority, .high)
        XCTAssertEqual(item.dueDate, due)
        XCTAssertTrue(item.isCompleted)
    }

    func testUniqueIDs() {
        let a = TodoItem(title: "A")
        let b = TodoItem(title: "B")
        XCTAssertNotEqual(a.id, b.id)
    }
}
