# Refds Router

[![CI](https://github.com/rafaelesantos/refds-router/actions/workflows/swift.yml/badge.svg)](https://github.com/rafaelesantos/refds-router/actions/workflows/swift.yml)

Refds Router is a library that simplifies the implementation of the router design pattern in SwiftUI applications. The router pattern is essential for managing navigation between different screens or views in an iOS application. This library provides a simple and flexible framework for managing the navigation flow in your SwiftUI app.

## Key Features

- [X] Navigation management between SwiftUI views in a declarative manner.
- [X] Support for stack-based navigation and modal presentation.
- [X] Simple and easy-to-use interface.

## Installation

Add this project to your `Package.swift` file.

```swift
import PackageDescription

let package = Package(
    dependencies: [
        .package(url: "https://github.com/rafaelesantos/refds-router.git", branch: "main")
    ],
    targets: [
        .target(
            name: "YourProject",
            dependencies: [
                .product(
                    name: "RefdsRouter",
                    package: "refds-router"),
            ]),
    ]
)
```
