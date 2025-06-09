import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Implementation of the `RouteModel` macro that can be applied to
/// types conforming to `Route` and generates the necessary conformance
/// to `Hashable` and `Equatable` protocols in case of dependancies that
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
///
public struct RouteModelMacro: MemberMacro {
    enum Error: Swift.Error {
        case message(String)
    }
    
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard declaration.inheritanceClause?.inheritedTypes.contains(where: { $0.type.trimmedDescription == "Route" }) == true else {
            throw Error.message("@RouteConformance can only be applied to types conforming to Route")
        }

        return [
            "func hash(into hasher: inout Hasher) { hasher.combine(id) }",
            "static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }"
        ]
    }
}

@main
struct RouteModelPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        RouteModelMacro.self,
    ]
}
