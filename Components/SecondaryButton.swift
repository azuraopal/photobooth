import SwiftUI

struct SecondaryButton: View {
    let title: String
    var icon: SnapIconType? = nil
    var color: Color = .primaryAccent
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let icon = icon {
                    SnapIcon(type: icon, color: color, size: 16)
                }
                Text(title)
                    .font(.snapBodyFallback)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .cornerRadius(20)
        }
    }
}
