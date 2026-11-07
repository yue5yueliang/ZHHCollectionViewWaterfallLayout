# ZHHCollectionViewWaterfallLayout

纯 Swift 瀑布流布局，基于 `UICollectionViewLayout`。支持多列、多分区、Header / Footer，以及按分区动态配置列数、间距与 item 尺寸。

要求 iOS 15.0+，Swift 5.5+。

## 特性

- 多列瀑布流，默认最短列优先填充（`shortestFirst`）
- 支持 `leftToRight` / `rightToLeft` 填充方向
- 多 Section，可分别指定列数、内边距、行间距
- 支持 Section Header / Footer 高度配置
- 通过 `ZHHCollectionViewDelegateWaterfallLayout` 动态返回 item 尺寸

## 示例

```bash
cd Example
pod install
open ZHHCollectionViewWaterfallLayout.xcworkspace
```

Example 为 SceneDelegate + MVVM 纯代码 Demo，可直接查看双列 / 三列分区效果。

## 安装

### CocoaPods

```ruby
pod 'ZHHCollectionViewWaterfallLayout'
```

本地开发：

```ruby
pod 'ZHHCollectionViewWaterfallLayout', :path => '../'
```

也可直接依赖 git 标签：

```ruby
pod 'ZHHCollectionViewWaterfallLayout', :git => 'https://github.com/yue5yueliang/ZHHCollectionViewWaterfallLayout.git', :tag => '1.0.0'
```

### Swift Package Manager

仓库已提供 `Package.swift`，产品名是 `ZHHCollectionViewWaterfallLayout`。打好语义化 tag 后即可被 SPM 解析，无需额外上传。

本地用 Xcode 查看包时，请打开根目录的 `Package.swift`（不要打开仓库文件夹，以免进到 CocoaPods 工程）。

**Xcode**

1. File → Add Package Dependencies…
2. 填入：`https://github.com/yue5yueliang/ZHHCollectionViewWaterfallLayout.git`
3. 规则选 Up to Next Major（或 Exact `1.0.0`）
4. 把产品 `ZHHCollectionViewWaterfallLayout` 加到目标

**Package.swift**

```swift
dependencies: [
    .package(url: "https://github.com/yue5yueliang/ZHHCollectionViewWaterfallLayout.git", from: "1.0.0")
]
```

在 target 里引用：

```swift
.product(name: "ZHHCollectionViewWaterfallLayout", package: "ZHHCollectionViewWaterfallLayout")
```

## 最小示例

```swift
import UIKit
import ZHHCollectionViewWaterfallLayout

let layout = ZHHCollectionViewWaterfallLayout()
layout.minimumColumnSpacing = 10
layout.minimumInteritemSpacing = 10
layout.sectionInset = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
layout.itemRenderDirection = .shortestFirst

let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
collectionView.dataSource = self
collectionView.delegate = self
```

实现代理，返回尺寸与列数：

```swift
extension ViewController: ZHHCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 返回参考尺寸；布局会按列宽等比缩放高度
        items[indexPath.item].size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountFor section: Int) -> Int {
        section == 0 ? 2 : 3
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForHeaderIn section: Int) -> CGFloat {
        44
    }
}
```

## Author

桃色三岁, 136769890@qq.com

## License

ZHHCollectionViewWaterfallLayout is available under the MIT license. See the LICENSE file for more info.
