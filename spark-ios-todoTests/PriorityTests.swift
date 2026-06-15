//
//  PriorityTests.swift
//  spark-ios-todoTests
//

import XCTest
@testable import spark_ios_todo

final class PriorityTests: XCTestCase {

    func testAllCases() {
        XCTAssertEqual(Priority.allCases, [.low, .medium, .high])
    }

    func testDisplayNames() {
        XCTAssertEqual(Priority.low.displayName, "低")
        XCTAssertEqual(Priority.medium.displayName, "中")
        XCTAssertEqual(Priority.high.displayName, "高")
    }

    func testRawValueOrdering() {
        XCTAssertLessThan(Priority.low.rawValue, Priority.medium.rawValue)
        XCTAssertLessThan(Priority.medium.rawValue, Priority.high.rawValue)
    }

    func testIdentifiable() {
        XCTAssertEqual(Priority.high.id, Priority.high.rawValue)
    }
}
