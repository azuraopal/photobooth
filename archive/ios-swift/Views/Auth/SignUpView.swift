import SwiftUI

struct SignUpView: View {
    @Environment(AppState.self) var appState
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var navigateToOTP = false
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            PurikuraBackground()
            
            VStack(spacing: 20) {
                Spacer().frame(height: 10)
                
                HStack(spacing: 6) {
                    Image(systemName: "person.badge.plus")
                        .font(.title)
                        .foregroundColor(.primaryAccent)
                    Text("Create Account")
                        .font(.snapDisplayFallback)
                        .foregroundColor(.primaryAccent)
                }
                
                VStack(spacing: 14) {
                    SnapTextField(
                        placeholder: "Full Name",
                        text: $name,
                        icon: "person.fill",
                        autoCapitalization: .words
                    )
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
                    SnapTextField(
                        placeholder: "Confirm Password",
                        text: $confirmPassword,
                        isSecure: true,
                        icon: "lock.shield.fill"
                    )
                }
                .padding(20)
                .background(Color.white.opacity(0.85))
                .cornerRadius(24)
                .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
                
                if !errorMessage.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                        Text(errorMessage)
                            .font(.snapCaptionFallback)
                            .foregroundColor(.red)
                    }
                }
                
                PrimaryButton(title: "Sign Up", icon: .profile) {
                    if name.isEmpty || email.isEmpty || password.isEmpty {
                        errorMessage = "Please fill in all fields"
                    } else if password != confirmPassword {
                        errorMessage = "Passwords do not match"
                    } else {
                        errorMessage = ""
                        navigateToOTP = true
                    }
                }
                .padding(.top, 10)
                
                Spacer()
            }
            .padding(24)
        }
        .navigationDestination(isPresented: $navigateToOTP) { OTPView(flow: .signUp, userEmail: email, userName: name) }
    }
}
