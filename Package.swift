// swift-tools-version:4.2
// Managed by ice

import PackageDescription

let package = Package(

    name: "SwiftRingBuffer",

    products: [

        .library(name: "SwiftRingBuffer", targets: ["SwiftRingBuffer"]),

    ],

    targets: [

        .target(name: "SwiftRingBuffer", dependencies: []),
        .testTarget(name: "SwiftRingBufferTests", dependencies: ["SwiftRingBuffer"]),

    ]
	
)
