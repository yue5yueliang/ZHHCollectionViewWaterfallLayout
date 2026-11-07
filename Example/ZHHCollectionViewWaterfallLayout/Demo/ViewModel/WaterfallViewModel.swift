//
//  WaterfallViewModel.swift
//  ZHHCollectionViewWaterfallLayout_Example
//
//  Created by 桃色三岁 on 11/07/2026.
//  Copyright (c) 2026 桃色三岁. All rights reserved.
//

import UIKit

/// 瀑布流 Demo 的 ViewModel，负责生成示例数据，并向 View 层提供查询接口
final class WaterfallViewModel {

    /// 分区数据源，外部只读
    private(set) var sections: [WaterfallSection] = []

    /// 分区数量
    var numberOfSections: Int {
        sections.count
    }

    /// 返回指定分区的条目数量
    /// - Parameter section: 分区索引
    /// - Returns: 条目数量；索引非法时返回 0
    func numberOfItems(in section: Int) -> Int {
        guard sections.indices.contains(section) else { return 0 }
        return sections[section].items.count
    }

    /// 返回指定分区模型
    /// - Parameter index: 分区索引
    /// - Returns: 分区模型；索引非法时返回 nil
    func section(at index: Int) -> WaterfallSection? {
        guard sections.indices.contains(index) else { return nil }
        return sections[index]
    }

    /// 返回指定位置的条目模型
    /// - Parameter indexPath: 条目索引
    /// - Returns: 条目模型；索引非法时返回 nil
    func item(at indexPath: IndexPath) -> WaterfallItem? {
        guard let section = section(at: indexPath.section),
              section.items.indices.contains(indexPath.item) else {
            return nil
        }
        return section.items[indexPath.item]
    }

    /// 返回指定分区的列数
    /// - Parameter section: 分区索引
    /// - Returns: 列数；找不到分区时默认 2
    func columnCount(for section: Int) -> Int {
        self.section(at: section)?.columnCount ?? 2
    }

    /// 返回指定条目的参考尺寸，供瀑布流布局计算高度
    /// - Parameter indexPath: 条目索引
    /// - Returns: 参考尺寸；找不到条目时返回默认值
    func sizeForItem(at indexPath: IndexPath) -> CGSize {
        item(at: indexPath)?.size ?? CGSize(width: 100, height: 100)
    }

    /// 加载 Demo 示例数据（双列 + 三列两个分区）
    func loadData() {
        sections = [
            makeSection(title: "双列瀑布流", columnCount: 2, startId: 1, count: 12, heightRange: 120...220),
            makeSection(title: "三列瀑布流", columnCount: 3, startId: 100, count: 15, heightRange: 90...180)
        ]
    }

    // MARK: - Private

    /// 构造一个分区的随机示例数据
    /// - Parameters:
    ///   - title: 分区标题
    ///   - columnCount: 列数
    ///   - startId: 条目起始 id
    ///   - count: 条目数量
    ///   - heightRange: 随机高度范围
    /// - Returns: 分区模型
    private func makeSection(title: String, columnCount: Int, startId: Int, count: Int, heightRange: ClosedRange<CGFloat>) -> WaterfallSection {
        // 循环使用的示例色板
        let palette: [UIColor] = [
            UIColor.systemBlue,
            UIColor.systemTeal,
            UIColor.systemIndigo,
            UIColor.systemOrange,
            UIColor.systemPink,
            UIColor.systemGreen,
            UIColor.systemPurple,
            UIColor.systemYellow
        ]

        let items = (0..<count).map { index -> WaterfallItem in
            let id = startId + index
            let height = CGFloat.random(in: heightRange)
            return WaterfallItem(
                id: id,
                title: "Item \(id)",
                subtitle: "\(Int(height))pt",
                color: palette[index % palette.count].withAlphaComponent(0.85),
                size: CGSize(width: 100, height: height)
            )
        }

        return WaterfallSection(title: title, columnCount: columnCount, items: items)
    }
}
