import SwiftUI

struct ForgotPasswordView: View {
    @State private var email = ""
    @State private var navigateToOTP = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Reset Password")
                .font(.snapDisplayFallback)
                .foregroundColor(.primaryAccent)
            
            Text("Enter your email address to receive a recovery code.")
                .font(.snapBodyFallback)
                .foregroundColor(.textPrimary.opacity(0.7))
                .multilineTextAlignment(.center)
            
            SnapTextField(placeholder: "Email Address", text: $email, icon: "envelope.fill")
            
            PrimaryButton(title: "Send Reset Code", isDisabled: email.isEmpty) {
                navigateToOTP = true
            }
            
            Spacer()
        }
        .padding(24)
        .background(Color.snapBackground.ignoresSafeArea())
        .navigationDestination(isPresented: $navigateToOTP) { OTPView(flow: .passwordReset) }
    }
}
