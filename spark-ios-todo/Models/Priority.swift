//
//  Priority.swift
//  spark-ios-todo
//
//  任务优先级枚举
//

import SwiftUI

/// 任务优先级，按 rawValue 从低到高排序。
enum Priority: Int, Codable, CaseIterable, Identifiable {
    case low = 0
    case medium = 1
    case high = 2

    var id: Int { rawValue }

    /// 中文显示名称
    var displayName: String {
        switch self {
        case .low: return "低"
        case .medium: return "中"
        case .high: return "高"
        }
    }

    /// 标签颜色
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }

    /// 对应 SF Symbol
    var systemImage: String {
        switch self {
        case .low: return "arrow.down.circle"
        case .medium: return "equal.circle"
        case .high: return "exclamationmark.circle"
        }
    }
}
