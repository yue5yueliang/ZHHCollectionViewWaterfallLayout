//
//  WaterfallItem.swift
//  ZHHCollectionViewWaterfallLayout_Example
//
//  Created by 桃色三岁 on 11/07/2026.
//  Copyright (c) 2026 桃色三岁. All rights reserved.
//

import UIKit

/// 瀑布流单条数据模型，描述一个 Cell 的展示内容与布局参考尺寸
struct WaterfallItem {
    /// 唯一标识
    let id: Int
    /// 主标题
    let title: String
    /// 副标题（Demo 中用于展示高度信息）
    let subtitle: String
    /// Cell 背景色
    let color: UIColor
    /// 用于布局计算的参考尺寸（按宽高比缩放）
    let size: CGSize
}

/// 瀑布流分区数据模型，描述一个 Section 的标题、列数与条目列表
struct WaterfallSection {
    /// 分区标题，展示在 Header 中
    let title: String
    /// 该分区列数
    let columnCount: Int
    /// 分区内的条目数据
    let items: [WaterfallItem]
}
