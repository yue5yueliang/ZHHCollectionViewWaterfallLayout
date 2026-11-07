//
//  WaterfallViewController.swift
//  ZHHCollectionViewWaterfallLayout_Example
//
//  Created by 桃色三岁 on 11/07/2026.
//  Copyright (c) 2026 桃色三岁. All rights reserved.
//

import UIKit
import ZHHCollectionViewWaterfallLayout

/// 瀑布流 Demo 页面（View 层），通过 ViewModel 获取数据并驱动布局
final class WaterfallViewController: UIViewController {

    /// 页面对应的 ViewModel
    private let viewModel: WaterfallViewModel

    /// 瀑布流布局对象，配置列间距、行间距、内边距与填充方向
    private lazy var layout: ZHHCollectionViewWaterfallLayout = {
        let layout = ZHHCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        layout.itemRenderDirection = .shortestFirst
        return layout
    }()

    /// 瀑布流列表视图
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        // 注册 Cell / Header / Footer
        collectionView.register(WaterfallCell.self, forCellWithReuseIdentifier: WaterfallCell.reuseIdentifier)
        collectionView.register(WaterfallHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WaterfallHeaderView.reuseIdentifier)
        collectionView.register(WaterfallFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: WaterfallFooterView.reuseIdentifier)
        return collectionView
    }()

    /// 使用 ViewModel 初始化页面
    /// - Parameter viewModel: 瀑布流数据与布局配置来源
    init(viewModel: WaterfallViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Waterfall Demo"
        view.backgroundColor = .systemBackground
        setupCollectionView()
        bindViewModel()
    }

    /// 将 CollectionView 铺满安全区域
    private func setupCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    /// 从 ViewModel 加载数据并刷新列表
    private func bindViewModel() {
        viewModel.loadData()
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension WaterfallViewController: UICollectionViewDataSource {

    /// 返回分区数量
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfSections
    }

    /// 返回指定分区的条目数量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems(in: section)
    }

    /// 配置并返回条目 Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WaterfallCell.reuseIdentifier, for: indexPath) as? WaterfallCell else {
            return UICollectionViewCell()
        }

        if let item = viewModel.item(at: indexPath) {
            cell.configure(with: item)
        }
        return cell
    }

    /// 配置并返回分区 Header / Footer
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: WaterfallHeaderView.reuseIdentifier, for: indexPath) as! WaterfallHeaderView
            header.configure(title: viewModel.section(at: indexPath.section)?.title ?? "")
            return header
        }

        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: WaterfallFooterView.reuseIdentifier, for: indexPath) as! WaterfallFooterView
        let count = viewModel.numberOfItems(in: indexPath.section)
        footer.configure(title: "共 \(count) 项")
        return footer
    }
}

// MARK: - ZHHCollectionViewDelegateWaterfallLayout

extension WaterfallViewController: ZHHCollectionViewDelegateWaterfallLayout {

    /// 返回指定条目的参考尺寸（布局会按列宽等比缩放高度）
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        viewModel.sizeForItem(at: indexPath)
    }

    /// 返回分区头部高度
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForHeaderIn section: Int) -> CGFloat {
        44
    }

    /// 返回分区尾部高度
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForFooterIn section: Int) -> CGFloat {
        36
    }

    /// 返回分区内边距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetsFor section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
    }

    /// 返回分区内条目的最小垂直间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingFor section: Int) -> CGFloat {
        10
    }

    /// 返回指定分区的列数
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountFor section: Int) -> Int {
        viewModel.columnCount(for: section)
    }
}
