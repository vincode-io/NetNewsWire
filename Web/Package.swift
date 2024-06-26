// swift-tools-version: 5.10

import PackageDescription

let package = Package(
	name: "Web",
	platforms: [.macOS(.v14), .iOS(.v17)],
	products: [
		.library(
			name: "Web",
			targets: ["Web"]),
	],
	targets: [
		.target(
			name: "Web",
			dependencies: [],
			resources: [.copy("UTS46/uts46")],
			swiftSettings: [
				.define("SWIFT_PACKAGE"),
				.enableExperimentalFeature("StrictConcurrency")
			]
		),
		.testTarget(
			name: "WebTests",
			dependencies: ["Web"]),
	]
)
