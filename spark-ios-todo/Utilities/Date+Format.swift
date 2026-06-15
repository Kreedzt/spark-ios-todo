//
//  Date+Format.swift
//  spark-ios-todo
//
//  日期格式化与判断辅助
//

import Foundation

extension Date {
    /// 相对友好的日期描述：今天 / 明天 / 昨天 / 6月20日（跨年带年份）。
    var relativeDescription: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(self) { return "今天" }
        if calendar.isDateInTomorrow(self) { return "明天" }
        if calendar.isDateInYesterday(self) { return "昨天" }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        if calendar.isDate(self, equalTo: Date(), toGranularity: .year) {
            formatter.dateFormat = "M月d日"
        } else {
            formatter.dateFormat = "yyyy年M月d日"
        }
        return formatter.string(from: self)
    }

    /// 含时间的完整描述，用于详情页。
    var fullDescription: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy年M月d日 HH:mm"
        return formatter.string(from: self)
    }

    /// 是否已逾期（早于当前时刻）。
    var isOverdue: Bool {
        self < Date()
    }
}
