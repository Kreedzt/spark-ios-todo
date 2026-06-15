//
//  EmptyStateView.swift
//  spark-ios-todo
//
//  列表为空时的引导视图
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        ContentUnavailableView {
            Label("还没有任务", systemImage: "checklist")
        } description: {
            Text("点击右上角的「+」创建你的第一个任务。")
        }
    }
}

#Preview {
    EmptyStateView()
}
