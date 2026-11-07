// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "ZHHCollectionViewWaterfallLayout",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "ZHHCollectionViewWaterfallLayout", targets: ["ZHHCollectionViewWaterfallLayout"])
    ],
    targets: [
        .target(
            name: "ZHHCollectionViewWaterfallLayout",
            path: "ZHHCollectionViewWaterfallLayout",
            exclude: ["Assets"],
            sources: ["Classes"],
            resources: [
                .process("PrivacyInfo.xcprivacy")
            ]
        )
    ]
)
