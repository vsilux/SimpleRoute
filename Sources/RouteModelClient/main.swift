import RouteModel
import SwiftUI

protocol Route: Hashable, Identifiable {
    associatedtype Destination: View
    
    var destination: Destination { get }
}

protocol Auth {
    var isAuthenticated: Bool { get }
}

@RouteModel
struct HomeRoute: Route {
    var id: String { "home" }
    var auth: any Auth
    
    @ViewBuilder
    var destination: some View {
        Text("Home")
    }
}


struct HomeView: View {
    var body: some View {
        Text("Home")
    }
}

struct LoginView: View {
    var body: some View {
        Text("Login")
    }
}
