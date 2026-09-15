import SwiftUI

struct LoginView: View {
    @Environment(AppState.self) var appState
    @State private var email = ""
    @State private var password = ""
    @State private var navigateToForgot = false
    
    var body: some View {
        ZStack {
            PurikuraBackground()
            
            VStack(spacing: 20) {
                Spacer().frame(height: 10)
                
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .font(.title)
                        .foregroundColor(.primaryAccent)
                    Text("Welcome Back")
                        .font(.snapDisplayFallback)
                        .foregroundColor(.primaryAccent)
                }
                
                VStack(spacing: 14) {
                    SnapTextField(
                        placeholder: "Email Address",
                        text: $email,
                        icon: "envelope.fill",
                        autoCapitalization: .never,
                        keyboardType: .emailAddress
                    )
                    SnapTextField(
                        placeholder: "Password",
                        text: $password,
                        isSecure: true,
                        icon: "lock.fill"
                    )
                    
                    HStack {
                        Spacer()
                        Button("Forgot password?") {
                            navigateToForgot = true
                        }
                        .font(.snapCaptionFallback)
                        .bold()
                        .foregroundColor(.primaryAccent)
                    }
                }
                .padding(20)
                .background(Color.white.opacity(0.85))
                .cornerRadius(24)
                .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
                
                PrimaryButton(title: "Log In", icon: .profile, isDisabled: email.isEmpty || password.isEmpty) {
                    let namePart = email.components(separatedBy: "@").first ?? "User"
                    appState.login(email: email, name: namePart.capitalized, provider: .email)
                }
                .padding(.top, 10)
                
                Spacer()
            }
            .padding(24)
        }
        .navigationDestination(isPresented: $navigateToForgot) { ForgotPasswordView() }
    }
}
