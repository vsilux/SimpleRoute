// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import Foundation

public protocol Route: Hashable, Identifiable {
    associatedtype Destination: View
    var destination: Destination { get }
}

@Observable
public class Router {
    public var routes: [any Route] = []
}

public struct RouterKey: EnvironmentKey {
    public nonisolated(unsafe) static let defaultValue: Router = Router()
}

extension EnvironmentValues {
    public var router: Router {
        get { self[RouterKey.self] }
        set { self[RouterKey.self] = newValue }
    }
}
