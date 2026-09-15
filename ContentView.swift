import SwiftUI

struct ContentView: View {
    @State private var authVM = AuthViewModel()
    
    var body: some View {
        Group {
            if authVM.isAuthenticated {
                MainTabView()
            } else {
                WelcomeView()
            }
        }
        .environment(authVM)
    }
}

#Preview {
    ContentView()
}
