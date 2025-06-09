import SwiftUI
import SimpleRoute

protocol Auth {
    var isAuthenticated: Bool { get }
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

struct InitialView: View {
    @StateObject var router = Router()
    
    var body: some View {
        NavigationStack(path: $router.routes) {
            VStack {
                Text("Welcome to the App")
            }
            .navigationDestination(for: AnyRoute.self) { route in
                route.destination
            }
        }
    }
}
