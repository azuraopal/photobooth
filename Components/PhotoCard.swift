import SwiftUI

struct PhotoCard: View {
    let title: String
    let dateString: String
    var color: Color = .cardPink
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(color)
                    .aspectRatio(3/4, contentMode: .fit)
                
                VStack(spacing: 6) {
                    SnapIcon(type: .camera, color: .primaryAccent, size: 32)
                    Text("Your Photo Here")
                        .font(.snapCaptionFallback)
                        .foregroundColor(.textPrimary.opacity(0.7))
                }
            }
            Text(title)
                .font(.snapBodyFallback)
                .bold()
                .foregroundColor(.textPrimary)
                .lineLimit(1)
            Text(dateString)
                .font(.snapCaptionFallback)
                .foregroundColor(.textPrimary.opacity(0.6))
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}
