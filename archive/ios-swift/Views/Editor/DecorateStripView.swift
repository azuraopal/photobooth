import SwiftUI

struct DecorateStripView: View {
    @Environment(AppState.self) var appState
    @State private var stickerScale: CGFloat = 1.0
    @State private var stickerOffset: CGSize = .zero
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Button(action: { appState.navigationPath.removeLast() }) {
                    SnapIcon(type: .back, color: .primaryAccent, size: 22)
                }
                Text("Decorate Strip")
                    .font(.snapHeadlineFallback)
                    .foregroundColor(.primaryAccent)
                Spacer()
                StepDots(currentStep: 3, totalSteps: 4)
                Button(action: { appState.resetBoothFlow() }) {
                    SnapIcon(type: .close, color: .gray, size: 20)
                }
            }
            .padding(.horizontal)
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(appState.selectedFrame.accentColor.opacity(0.25))
                    .frame(width: 220, height: 380)
                
                VStack(spacing: 10) {
                    ForEach(0..<4) { index in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                            .frame(width: 190, height: 75)
                            .overlay(
                                Image(systemName: "photo.fill")
                                    .foregroundColor(appState.selectedFrame.accentColor)
                            )
                    }
                }
                
                Image(systemName: "sparkles")
                    .font(.system(size: 40))
                    .foregroundColor(.secondaryAccent)
                    .scaleEffect(stickerScale)
                    .offset(stickerOffset)
                    .gesture(
                        DragGesture().onChanged { value in stickerOffset = value.translation }
                    )
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    SecondaryButton(title: "Stickers", icon: .addSticker) {}
                    SecondaryButton(title: "Filters", icon: .heart) {}
                    SecondaryButton(title: "Text", icon: .profile) {}
                }
                .padding(.horizontal)
            }
            
            PrimaryButton(title: "Continue to Export", icon: .download) {
                appState.navigationPath.append("PrintPreviewView")
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 12)
        }
        .background(Color.snapBackground.ignoresSafeArea())
        .toolbar(.hidden, for: .tabBar)
    }
}
