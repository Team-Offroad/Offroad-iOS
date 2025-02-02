// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LogPrinter",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "LogPrinter",
            targets: ["LogPrinter"]),
    ],
    
    dependencies: [
        //RxSwift 라이브러리
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0")),
        //RxCocoa 라이브러리
//        .package(url: "https://github.com/ReactiveX/RxSwift/tree/main/RxCocoa", .upToNextMajor(from: "6.0.0")),
        //SnapKit 라이브러리
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.0")),
        //Then 라이브러리
        .package(url: "https://github.com/devxoul/Then.git", .upToNextMajor(from: "3.0.0"))
    ],
    
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "LogPrinter",
            dependencies: [
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                "SnapKit",
                "Then"
            ]
        ),
        .testTarget(
            name: "LogPrinterTests",
            dependencies: ["LogPrinter"]
        ),
    ],
    swiftLanguageModes: [.v5]
)
