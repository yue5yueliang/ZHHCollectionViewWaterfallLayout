//
//  WaterfallSupplementaryView.swift
//  ZHHCollectionViewWaterfallLayout_Example
//
//  Created by 桃色三岁 on 11/07/2026.
//  Copyright (c) 2026 桃色三岁. All rights reserved.
//

import UIKit

/// 瀑布流分区头部视图，用于展示分区标题
final class WaterfallHeaderView: UICollectionReusableView {

    /// Header 复用标识
    static let reuseIdentifier = "WaterfallHeaderView"

    /// 分区标题标签
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 配置头部标题
    /// - Parameter title: 分区标题文案
    func configure(title: String) {
        titleLabel.text = title
    }
}

/// 瀑布流分区尾部视图，用于展示分区摘要信息
final class WaterfallFooterView: UICollectionReusableView {

    /// Footer 复用标识
    static let reuseIdentifier = "WaterfallFooterView"

    /// 摘要文案标签
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 配置尾部文案
    /// - Parameter title: 摘要文案
    func configure(title: String) {
        titleLabel.text = title
    }
}
