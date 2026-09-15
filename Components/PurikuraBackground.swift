import SwiftUI

struct PurikuraBackground: View {
    @State private var animateBubbles = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 255/255, green: 245/255, blue: 248/255),
                    Color(red: 255/255, green: 251/255, blue: 240/255),
                    Color(red: 240/255, green: 249/255, blue: 255/255)
                ],
                startPoint: animateBubbles ? .topLeading : .bottomLeading,
                endPoint: animateBubbles ? .bottomTrailing : .topTrailing
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: animateBubbles)
            
            GeometryReader { proxy in
                ZStack {
                    Circle()
                        .fill(Color.primaryAccent.opacity(0.12))
                        .frame(width: 180, height: 180)
                        .blur(radius: 20)
                        .offset(x: animateBubbles ? -40 : -10, y: animateBubbles ? 50 : 100)
                    
                    Circle()
                        .fill(Color.tertiaryAccent.opacity(0.15))
                        .frame(width: 220, height: 220)
                        .blur(radius: 25)
                        .offset(x: proxy.size.width - (animateBubbles ? 120 : 80), y: animateBubbles ? 180 : 120)
                    
                    Circle()
                        .fill(Color.secondaryAccent.opacity(0.18))
                        .frame(width: 140, height: 140)
                        .blur(radius: 15)
                        .offset(x: proxy.size.width * 0.3, y: proxy.size.height - (animateBubbles ? 180 : 220))
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primaryAccent.opacity(0.25))
                        .offset(x: 40, y: 140)
                        .scaleEffect(animateBubbles ? 1.2 : 0.9)
                    
                    Image(systemName: "heart.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.primaryAccent.opacity(0.2))
                        .offset(x: proxy.size.width - 60, y: proxy.size.height * 0.4)
                        .rotationEffect(.degrees(animateBubbles ? 15 : -10))
                    
                    Image(systemName: "star.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.secondaryAccent.opacity(0.3))
                        .offset(x: 50, y: proxy.size.height - 140)
                        .scaleEffect(animateBubbles ? 1.1 : 0.8)
                }
            }
        }
        .onAppear {
            animateBubbles = true
        }
    }
}
