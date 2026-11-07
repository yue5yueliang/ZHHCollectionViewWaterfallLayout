Pod::Spec.new do |s|
  s.name             = 'ZHHCollectionViewWaterfallLayout'
  s.version          = '1.0.0'
  s.summary          = '纯 Swift 瀑布流布局，基于 UICollectionViewLayout，支持多列与多分区。'

  s.description      = <<-DESC
ZHHCollectionViewWaterfallLayout 提供可配置的瀑布流布局：多列、多分区、Header / Footer、
列间距与行间距、分区内边距，以及 shortestFirst / leftToRight / rightToLeft 填充方向。
通过 ZHHCollectionViewDelegateWaterfallLayout 动态指定 item 尺寸与各分区列数。
                       DESC

  s.homepage         = 'https://github.com/yue5yueliang/ZHHCollectionViewWaterfallLayout'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '桃色三岁' => '136769890@qq.com' }
  s.source           = { :git => 'https://github.com/yue5yueliang/ZHHCollectionViewWaterfallLayout.git', :tag => s.version.to_s }

  s.ios.deployment_target = '15.0'
  s.swift_versions = ['5.5']
  s.frameworks = 'UIKit'

  # 隐私清单：不采集、不追踪、无 Required Reason API；resource_bundles 避免覆盖宿主 App 清单
  s.resource_bundles = {
    'ZHHCollectionViewWaterfallLayout' => ['ZHHCollectionViewWaterfallLayout/PrivacyInfo.xcprivacy']
  }

  # 默认 Source subspec：Development Pods 里单独一组源码树
  s.default_subspec = 'Source'

  s.subspec 'Source' do |ss|
    ss.source_files = 'ZHHCollectionViewWaterfallLayout/Classes/**/*'
  end
end
