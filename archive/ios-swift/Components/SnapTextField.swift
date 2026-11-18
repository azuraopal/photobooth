import SwiftUI

struct SnapTextField: View {
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var icon: String? = nil
    var autoCapitalization: TextInputAutocapitalization = .never
    var keyboardType: UIKeyboardType = .default
    var isAutocorrectionDisabled: Bool = true
    
    var body: some View {
        HStack(spacing: 12) {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(.textPrimary.opacity(0.6))
            }
            if isSecure {
                SecureField(placeholder, text: $text)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
            } else {
                TextField(placeholder, text: $text)
                    .textInputAutocapitalization(autoCapitalization)
                    .keyboardType(keyboardType)
                    .autocorrectionDisabled(isAutocorrectionDisabled)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.primaryAccent.opacity(0.3), lineWidth: 1.5)
        )
    }
}
