// The Swift Programming Language
// https://docs.swift.org/swift-book

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
