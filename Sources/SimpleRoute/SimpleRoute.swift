// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import Foundation
import Combine

/// A macro that can be applied to types conforming to `Route`
/// and generates the necessary conformance to `Hashable`
/// and `Equatable` protocols in case of dependancies that
/// doesn't conform to Hashable protocol.
///
/// It adds a `hash(into:)` method and an `==` operator
/// to the type.
///
/// Usage:
///
/// ```swift
/// protocol Auth {
///     func login() async throws
/// }
///
/// @RouteModel
/// struct MyRoute: Route {
///    var id: Identifier { "my_route" }
///    var auth: any Auth
///
///    var destination: some View {
///         Text("My Route")
///    }
/// }
@attached(member, names: named(hash), named(==))
public macro RouteModel() = #externalMacro(module: "RouteModelMacros", type: "RouteModelMacro")

public protocol Route: Hashable, Identifiable {
    associatedtype Destination: View
    var destination: Destination { get }
}

public typealias RouteHandler = (any Route) -> Void

public struct AnyRoute: Route, Hashable {
    private let wrappedRoute: any Route
    private let hashValueProvider: () -> Int
    private let equalsProvider: (AnyRoute) -> Bool
    private let destinationProvider: () -> AnyView
    private let idProvider: () -> AnyHashable
    
    public init<R: Route>(_ route: R) {
        self.wrappedRoute = route
        self.hashValueProvider = { route.hashValue }
        self.equalsProvider = { $0.wrappedRoute.id.hashValue == route.id.hashValue }
        self.destinationProvider = { AnyView(route.destination) }
        self.idProvider = { AnyHashable(route.id) }
    }
    
    public static func == (lhs: AnyRoute, rhs: AnyRoute) -> Bool {
        lhs.equalsProvider(rhs)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(hashValueProvider())
    }
    
    public var destination: AnyView {
        destinationProvider()
    }
    
    public var id: AnyHashable {
        idProvider()
    }
}


public class Router: ObservableObject {
    @Published public var routes: [AnyRoute] = []
    
    public init() {}
    
    public func navigate(to route: any Route) {
        routes.append(AnyRoute(route))
    }
    
    public func pop() {
        _ = routes.popLast()
    }
    
    public func popTo(routeId id: any Hashable) throws {
        guard let index = routes.lastIndex(where: { route in
            route.id.hashValue == id.hashValue
        }) else {
            throw Error.idNotFound
        }
        
        routes.removeSubrange(index..<routes.count)
    }
}

extension Router {
    public enum Error: Swift.Error {
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
