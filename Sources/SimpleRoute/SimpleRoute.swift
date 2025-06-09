// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import Foundation

public
protocol Route: Hashable, Identifiable {
    associatedtype Destination: View
    var destination: Destination { get }
}


public
class Router: ObservableObject {
    public
    var routes: [any Route] = []
    
    public
    init() {}
    
    public
    func navigate(to route: any Route) {
        routes.append(route)
    }
    
    public
    func pop() {
        _ = routes.popLast()
    }
    
    public
    func popTo(routeId id: any Hashable) throws {
        guard let index = routes.lastIndex(where: { route in
            route.id.hashValue == id.hashValue
        }) else {
            throw Error.idNotFound
        }
        
        routes.removeSubrange(index..<routes.count)
    }
}

extension Router {
    public
    enum Error: Swift.Error {
        case idNotFound
    }
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
