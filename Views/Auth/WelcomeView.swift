import SwiftUI

struct WelcomeView: View {
    @Environment(AppState.self) var appState
    @State private var navigateToSignUp = false
    @State private var navigateToLogin = false
    @State private var showGoogleAccountPicker = false
    
    var body: some View {
        ZStack {
            PurikuraBackground()
            
            VStack(spacing: 24) {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.primaryAccent.opacity(0.2), Color.cardPink],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 140, height: 140)
                        .shadow(color: Color.primaryAccent.opacity(0.2), radius: 12, x: 0, y: 6)
                    
                    Image(systemName: "camera.fill")
                        .font(.system(size: 58, weight: .bold, design: .rounded))
                        .foregroundColor(.primaryAccent)
                    
                    Image(systemName: "sparkle")
                        .font(.system(size: 24))
                        .foregroundColor(.secondaryAccent)
                        .offset(x: 45, y: -45)
                }
                
                VStack(spacing: 10) {
                    HStack(spacing: 6) {
                        Text("SnapBooth")
                            .font(.snapDisplayFallback)
                            .foregroundColor(.primaryAccent)
                        Image(systemName: "sparkles")
                            .foregroundColor(.secondaryAccent)
                            .font(.title2)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "heart.fill")
                            .font(.caption)
                            .foregroundColor(.primaryAccent)
                        Text("Cute Purikura Photobooth in your pocket")
                            .font(.snapBodyFallback)
                            .foregroundColor(.textPrimary.opacity(0.75))
                        Image(systemName: "heart.fill")
                            .font(.caption)
                            .foregroundColor(.primaryAccent)
                    }
                }
                
                Spacer()
                
                VStack(spacing: 14) {
                    PrimaryButton(title: "Continue with Google", icon: .profile, backgroundColor: .tertiaryAccent) {
                        showGoogleAccountPicker = true
                    }
                    
                    PrimaryButton(title: "Continue with Email", icon: .profile, backgroundColor: .primaryAccent) {
                        navigateToSignUp = true
                    }
                    
                    Button("Already have an account? Log In") {
                        navigateToLogin = true
                    }
                    .font(.snapCaptionFallback)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryAccent)
                    .padding(.top, 8)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
            }
        }
        .navigationDestination(isPresented: $navigateToSignUp) { SignUpView() }
        .navigationDestination(isPresented: $navigateToLogin) { LoginView() }
        .sheet(isPresented: $showGoogleAccountPicker) {
            GoogleAccountPickerSheet()
        }
    }
}

struct GoogleAccountPickerSheet: View {
    @Environment(AppState.self) var appState
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Capsule()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 5)
                .padding(.top, 10)
            
            HStack {
                Image(systemName: "g.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                Text("Sign in with Google")
                    .font(.headline)
            }
            .padding(.top, 10)
            
            Text("Choose an account to continue to SnapBooth")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            VStack(spacing: 12) {
                Button(action: {
                    dismiss()
                    appState.login(email: "user.google@snapbooth.app", name: "Nopal Purikura", provider: .google)
                }) {
                    HStack(spacing: 14) {
                        Circle()
                            .fill(Color.pink.opacity(0.2))
                            .frame(width: 40, height: 40)
                            .overlay(Text("N").bold().foregroundColor(.primaryAccent))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Nopal Purikura")
                                .font(.body)
                                .bold()
                                .foregroundColor(.primary)
                            Text("user.google@snapbooth.app")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(16)
                }
                
                Button(action: {
                    dismiss()
                    appState.login(email: "user.google@gmail.com", name: "Google Fan User", provider: .google)
                }) {
                    HStack(spacing: 14) {
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 40, height: 40)
                            .overlay(Text("G").bold().foregroundColor(.blue))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Google Fan User")
                                .font(.body)
                                .bold()
                                .foregroundColor(.primary)
                            Text("user.google@gmail.com")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(16)
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .presentationDetents([.height(340)])
    }
}
