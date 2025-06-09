// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import Foundation

protocol Route: Hashable, Identifiable {
    associatedtype Destination: View
    var destination: Destination { get }
}

@Observable
class Router {
    var routes: [any Route] = []
}

struct RouterKey: EnvironmentKey {
    nonisolated(unsafe) static let defaultValue: Router = Router()
}

extension EnvironmentValues {
    var router: Router {
        get { self[RouterKey.self] }
        set { self[RouterKey.self] = newValue }
    }
}
