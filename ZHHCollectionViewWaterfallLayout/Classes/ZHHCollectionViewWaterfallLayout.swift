//
//  ZHHCollectionViewWaterfallLayout.swift
//  ZHHYueYeExample
//
//  Created by 桃色三岁 on 2018/6/23.
//  Copyright © 2025 桃色三岁. All rights reserved.
//

import UIKit

// MARK: - 瀑布流布局代理协议

/// 自定义瀑布流布局代理协议，继承 UICollectionViewDelegate，提供 item 大小、间距和分区内边距等布局配置。
public protocol ZHHCollectionViewDelegateWaterfallLayout: UICollectionViewDelegate {

    /// 必须实现，返回指定 indexPath 的 cell 大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize

    /// 可选，返回指定分区头部高度
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForHeaderIn section: Int) -> CGFloat

    /// 可选，返回指定分区尾部高度
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForFooterIn section: Int) -> CGFloat

    /// 可选，返回指定分区的内边距（UIEdgeInsets）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetsFor section: Int) -> UIEdgeInsets

    /// 可选，返回指定分区的最小单元格间距（同一行内的最小水平间距）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingFor section: Int) -> CGFloat

    /// 可选，返回指定分区的列数
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountFor section: Int) -> Int
}

// MARK: - 协议扩展，提供默认实现（可选方法）

public extension ZHHCollectionViewDelegateWaterfallLayout {
    
    /// 返回指定分区头部高度，默认 0（表示不显示头部）
    /// - Parameters:
    ///   - collectionView: 所属的 UICollectionView
    ///   - collectionViewLayout: 布局对象
    ///   - section: 分区索引
    /// - Returns: 分区头部高度（CGFloat）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForHeaderIn section: Int) -> CGFloat {
        return 0
    }
    
    /// 返回指定分区尾部高度，默认 0（表示不显示尾部）
    /// - Parameters:
    ///   - collectionView: 所属的 UICollectionView
    ///   - collectionViewLayout: 布局对象
    ///   - section: 分区索引
    /// - Returns: 分区尾部高度（CGFloat）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForFooterIn section: Int) -> CGFloat {
        return 0
    }
    
    /// 返回指定分区的内边距，默认 .zero（无边距）
    /// - Parameters:
    ///   - collectionView: 所属的 UICollectionView
    ///   - collectionViewLayout: 布局对象
    ///   - section: 分区索引
    /// - Returns: 分区内边距（UIEdgeInsets）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetsFor section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    /// 返回指定分区单元格间最小垂直间距，默认 10
    /// - Parameters:
    ///   - collectionView: 所属的 UICollectionView
    ///   - collectionViewLayout: 布局对象
    ///   - section: 分区索引
    /// - Returns: 最小单元格间距（CGFloat）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingFor section: Int) -> CGFloat {
        return 10
    }
    
    /// 返回指定分区列数，默认 2 列
    /// - Parameters:
    ///   - collectionView: 所属的 UICollectionView
    ///   - collectionViewLayout: 布局对象
    ///   - section: 分区索引
    /// - Returns: 分区列数（Int）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountFor section: Int) -> Int {
        return 2
    }
}

extension ZHHCollectionViewWaterfallLayout {
    /// 瀑布流布局中，Item 布局的排列方向
    public enum ItemRenderDirection: Int {
        /// 优先填充当前列高度最短的列（瀑布流经典方式）
        case shortestFirst
        /// 从左向右依次排列
        case leftToRight
        /// 从右向左依次排列
        case rightToLeft
    }
    
    /// 分区内边距的参考来源，决定如何计算布局边距
    public enum SectionInsetReference {
        /// 以 CollectionView 的 contentInset 作为内边距参考
        case contentInset
        /// 以 CollectionView 的 layoutMargins 作为内边距参考
        case layoutMargins
        /// 以安全区域（Safe Area）作为内边距参考
        case safeArea
    }
}


/// 瀑布流布局类，基于 UICollectionViewLayout 自定义实现。
/// 支持多列、多分区，灵活配置间距、内边距及头尾视图高度。
/// 最低支持 iOS 15.0 及以上。
public class ZHHCollectionViewWaterfallLayout: UICollectionViewLayout {

    /// 列数，默认 2 列。设置后自动刷新布局。
    public var columnCount: Int = 2 {
        didSet { invalidateLayout() }
    }
    
    /// 列间距（水平间距），默认10
    public var minimumColumnSpacing: CGFloat = 10 {
        didSet { invalidateLayout() }
    }
    
    /// 行间距（垂直间距），默认10
    public var minimumInteritemSpacing: CGFloat = 10 {
        didSet { invalidateLayout() }
    }
    
    /// 分区头部视图高度，默认0。
    public var headerHeight: CGFloat = 0 {
        didSet { invalidateLayout() }
    }

    /// 分区尾部视图高度，默认0。
    public var footerHeight: CGFloat = 0 {
        didSet { invalidateLayout() }
    }
    
    /// 分区内边距，默认.zero。
    public var sectionInset: UIEdgeInsets = .zero {
        didSet { invalidateLayout() }
    }
    
    /// Item 渲染顺序，默认 shortestFirst。
    public var itemRenderDirection: ItemRenderDirection = .shortestFirst {
        didSet { invalidateLayout() }
    }
    
    /// 内边距参考类型，决定 sectionInset 的参考基准，默认 contentInset。
    public var sectionInsetReference: SectionInsetReference = .contentInset {
        didSet { invalidateLayout() }
    }
    
    /// 代理，需实现 ZHHCollectionViewDelegateWaterfallLayout 协议以支持动态布局配置。
    public var delegate: ZHHCollectionViewDelegateWaterfallLayout? {
        return collectionView?.delegate as? ZHHCollectionViewDelegateWaterfallLayout
    }
    
    // MARK: - 布局计算缓存
    
    /// 各分区每列的累计高度数组，用于计算 item 布局位置。
    private var columnHeights: [[CGFloat]] = []
    
    /// 各分区所有 item 的布局属性二维数组。
    private var sectionItemAttributes: [[UICollectionViewLayoutAttributes]] = []
    
    /// 所有 item 布局属性汇总数组。
    private var allItemAttributes: [UICollectionViewLayoutAttributes] = []
    
    /// 头部视图的布局属性字典，key 为 section 索引。
    private var headersAttributes: [Int: UICollectionViewLayoutAttributes] = [:]
    
    /// 尾部视图的布局属性字典，key 为 section 索引。
    private var footersAttributes: [Int: UICollectionViewLayoutAttributes] = [:]
    
    /// 合并矩形区域缓存，用于提高布局查询性能。
    private var unionRects: [CGRect] = []
    
    /// 合并矩形大小，默认合并 20 个 item 的布局区域。
    private let unionSize = 20
    
}

extension ZHHCollectionViewWaterfallLayout {
    /// 准备布局，计算所有item和补充视图的布局属性
    override public func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        let numberOfSections = collectionView.numberOfSections
        guard numberOfSections > 0 else { return }
        
        // 重置缓存
        headersAttributes.removeAll()
        footersAttributes.removeAll()
        unionRects.removeAll()
        allItemAttributes.removeAll()
        sectionItemAttributes.removeAll()
        
        // 初始化每个分区列高数组，初始值为0
        columnHeights = (0..<numberOfSections).map { section in
            let colCount = self.columnCount(forSection: section)
            return Array(repeating: CGFloat(0), count: colCount)
        }
        
        // 用于记录当前布局顶部Y值
        var top: CGFloat = 0
        for section in 0..<numberOfSections {
            layoutSection(section, top: &top)
        }
        
        buildUnionRects()
    }
    
    /// 布局单个分区，包括头部、items、尾部
    private func layoutSection(_ section: Int, top: inout CGFloat) {
        guard let collectionView = collectionView else { return }

        // 获取分区内间距、列数、item宽度
        let minInteritemSpacing = delegate?.collectionView(collectionView, layout: self, minimumInteritemSpacingFor: section) ?? minimumInteritemSpacing
        let sectionInsets = delegate?.collectionView(collectionView, layout: self, insetsFor: section) ?? sectionInset
        let colCount = columnHeights[section].count
        let itemWidth = self.itemWidth(inSection: section)
        
        // 布局头部视图
        let headerH = delegate?.collectionView(collectionView, layout: self, heightForHeaderIn: section) ?? headerHeight
        if headerH > 0 {
            let indexPath = IndexPath(item: 0, section: section)
            let attr = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
            attr.frame = CGRect(x: 0, y: top, width: collectionView.bounds.width, height: headerH)
            headersAttributes[section] = attr
            allItemAttributes.append(attr)
            top = attr.frame.maxY
        }
        
        top += sectionInsets.top
        columnHeights[section] = Array(repeating: top, count: colCount)
        
        // 布局items
        let itemCount = collectionView.numberOfItems(inSection: section)
        var itemAttrs: [UICollectionViewLayoutAttributes] = []
        for item in 0..<itemCount {
            let indexPath = IndexPath(item: item, section: section)
            let columnIndex = nextColumnIndexForItem(item, inSection: section)
            let xOffset = sectionInsets.left + CGFloat(columnIndex) * (itemWidth + minimumColumnSpacing)
            let yOffset = columnHeights[section][columnIndex]

            // 计算item高度，按宽度比例缩放
            var itemHeight: CGFloat = 0
            if let size = delegate?.collectionView(collectionView, layout: self, sizeForItemAt: indexPath) {
                itemHeight = size.height > 0 ? (size.width > 0 ? floor(size.height * itemWidth / size.width) : size.height) : 0
            }

            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attr.frame = CGRect(x: xOffset, y: yOffset, width: itemWidth, height: itemHeight)
            itemAttrs.append(attr)
            allItemAttributes.append(attr)

            // 更新列高度
            columnHeights[section][columnIndex] = attr.frame.maxY + minInteritemSpacing
        }
        sectionItemAttributes.append(itemAttrs)

        // 布局尾部视图
        let longestCol = longestColumnIndex(inSection: section)
        top = columnHeights[section][longestCol] - minInteritemSpacing + sectionInsets.bottom
        let footerH = delegate?.collectionView(collectionView, layout: self, heightForFooterIn: section) ?? footerHeight
        if footerH > 0 {
            let indexPath = IndexPath(item: 0, section: section)
            let attr = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: indexPath)
            attr.frame = CGRect(x: 0, y: top, width: collectionView.bounds.width, height: footerH)
            footersAttributes[section] = attr
            allItemAttributes.append(attr)
            top = attr.frame.maxY
        }
        
        // 更新分区列高为尾部底部
        columnHeights[section] = Array(repeating: top, count: colCount)
    }
    
    /// 生成unionRects缓存，用于优化layoutAttributesForElements查询性能
    private func buildUnionRects() {
        var idx = 0
        let count = allItemAttributes.count
        unionRects.removeAll()
        while idx < count {
            let rect1 = allItemAttributes[idx].frame
            idx = min(idx + unionSize, count) - 1
            let rect2 = allItemAttributes[idx].frame
            unionRects.append(rect1.union(rect2))
            idx += 1
        }
    }
    
    /// 计算collectionView整体内容尺寸
    override public var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView, collectionView.numberOfSections > 0 else { return .zero }
        var size = collectionView.bounds.size
        size.width = collectionViewContentWidth
        if let lastHeight = columnHeights.last?.first {
            size.height = lastHeight
        }
        return size
    }
    
    /// 返回指定indexPath的item布局属性
    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard indexPath.section < sectionItemAttributes.count else { return nil }
        let items = sectionItemAttributes[indexPath.section]
        guard indexPath.item < items.count else { return nil }
        return items[indexPath.item]
    }
    
    /// 返回指定kind的补充视图布局属性（头部或尾部）
    override public func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == UICollectionView.elementKindSectionHeader {
            return headersAttributes[indexPath.section]
        } else if elementKind == UICollectionView.elementKindSectionFooter {
            return footersAttributes[indexPath.section]
        }
        return nil
    }
    
    /// 返回指定区域内所有布局属性（优化实现，使用unionRects快速过滤）
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard !unionRects.isEmpty else { return nil }
        var begin = 0
        var end = unionRects.count
        if let i = unionRects.firstIndex(where: { rect.intersects($0) }) {
            begin = i * unionSize
        }
        if let i = unionRects.lastIndex(where: { rect.intersects($0) }) {
            end = min((i + 1) * unionSize, allItemAttributes.count)
        }
        return allItemAttributes[begin..<end].filter { rect.intersects($0.frame) }
    }
    
    /// bounds宽度变化时刷新布局
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return newBounds.width != collectionView?.bounds.width
    }
}

extension ZHHCollectionViewWaterfallLayout {
    /// 获取指定分区列数，优先使用代理，否则用默认值
    private func columnCount(forSection section: Int) -> Int {
        delegate?.collectionView(collectionView!, layout: self, columnCountFor: section) ?? columnCount
    }
    
    /// 计算内容宽度，扣除对应内边距，参考sectionInsetReference
    private var collectionViewContentWidth: CGFloat {
        switch sectionInsetReference {
        case .contentInset:
            return collectionView!.bounds.width - collectionView!.contentInset.left - collectionView!.contentInset.right
        case .safeArea:
            return collectionView!.bounds.width - collectionView!.safeAreaInsets.left - collectionView!.safeAreaInsets.right
        case .layoutMargins:
            return collectionView!.bounds.width - collectionView!.layoutMargins.left - collectionView!.layoutMargins.right
        }
    }
    
    /// 计算指定分区内容宽度，扣除分区内边距
    private func collectionViewContentWidth(ofSection section: Int) -> CGFloat {
        let insets = delegate?.collectionView(collectionView!, layout: self, insetsFor: section) ?? sectionInset
        return collectionViewContentWidth - insets.left - insets.right
    }
    
    /// 计算指定分区item宽度
    public func itemWidth(inSection section: Int) -> CGFloat {
        let colCount = columnCount(forSection: section)
        let spacingCount = CGFloat(colCount - 1)
        let width = collectionViewContentWidth(ofSection: section)
        return floor((width - spacingCount * minimumColumnSpacing) / CGFloat(colCount))
    }
    
    /// 获取指定分区最短列索引
    private func shortestColumnIndex(inSection section: Int) -> Int {
        columnHeights[section].enumerated().min(by: { $0.element < $1.element })?.offset ?? 0
    }
    
    /// 获取指定分区最长列索引
    private func longestColumnIndex(inSection section: Int) -> Int {
        columnHeights[section].enumerated().max(by: { $0.element < $1.element })?.offset ?? 0
    }
    
    /// 根据摆放方向计算下一个item应放置的列索引
    private func nextColumnIndexForItem(_ item: Int, inSection section: Int) -> Int {
        let colCount = columnCount(forSection: section)
        switch itemRenderDirection {
        case .shortestFirst:
            return shortestColumnIndex(inSection: section)
        case .leftToRight:
            return item % colCount
        case .rightToLeft:
            return (colCount - 1) - (item % colCount)
        }
    }
}
