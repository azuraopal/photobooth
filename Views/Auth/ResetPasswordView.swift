import SwiftUI

struct ResetPasswordView: View {
    @Environment(AuthViewModel.self) var authVM
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var isSuccess = false
    
    var body: some View {
        VStack(spacing: 20) {
            if isSuccess {
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 64))
                        .foregroundColor(.green)
                    Text("Password Reset Successful!")
                        .font(.snapHeadlineFallback)
                        .foregroundColor(.textPrimary)
                }
                .transition(.scale)
            } else {
                Text("New Password")
                    .font(.snapDisplayFallback)
                    .foregroundColor(.primaryAccent)
                
                SnapTextField(placeholder: "New Password", text: $newPassword, isSecure: true, icon: "lock.fill")
                SnapTextField(placeholder: "Confirm New Password", text: $confirmPassword, isSecure: true, icon: "lock.shield.fill")
                
                PrimaryButton(title: "Update Password", isDisabled: newPassword.isEmpty || newPassword != confirmPassword) {
                    withAnimation { isSuccess = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        authVM.login()
                    }
                }
            }
            Spacer()
        }
        .padding(24)
        .background(Color.snapBackground.ignoresSafeArea())
    }
}
