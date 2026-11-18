import SwiftUI

struct RootView: View {
    @State private var appState = AppState()
    
    var body: some View {
        ZStack {
            if appState.isAuthenticated {
                MainTabView()
                    .transition(.asymmetric(insertion: .scale(scale: 0.95).combined(with: .opacity), removal: .opacity))
            } else {
                NavigationStack {
                    WelcomeView()
                }
                .transition(.opacity)
            }
            
            if appState.isLoggingIn {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.primaryAccent)
                        
                        Text("Logging into SnapBooth...")
                            .font(.snapHeadlineFallback)
                            .foregroundColor(.textPrimary)
                        
                        Text("Preparing Purikura Magic ✨")
                            .font(.snapCaptionFallback)
                            .foregroundColor(.primaryAccent)
                    }
                    .padding(30)
                    .background(Color.white)
                    .cornerRadius(24)
                    .shadow(radius: 20)
                    .transition(.scale.combined(with: .opacity))
                }
                .zIndex(99)
            }
        }
        .environment(appState)
    }
}
