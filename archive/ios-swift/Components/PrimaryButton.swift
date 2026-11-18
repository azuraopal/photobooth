import SwiftUI

struct PrimaryButton: View {
    let title: String
    var icon: SnapIconType? = nil
    var backgroundColor: Color = .primaryAccent
    var foregroundColor: Color = .white
    var isDisabled: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    SnapIcon(type: icon, color: foregroundColor, size: 18)
                }
                Text(title)
                    .font(.snapHeadlineFallback)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(isDisabled ? backgroundColor.opacity(0.4) : backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(25)
            .shadow(color: backgroundColor.opacity(0.3), radius: 6, x: 0, y: 4)
        }
        .disabled(isDisabled)
    }
}
