import SwiftUI

struct PrintPreviewView: View {
    @Environment(AppState.self) var appState
    @State private var yOffset: CGFloat = -400
    @State private var selectedSize = "2x6"
    @State private var isSavedToApp = false
    
    let sizes = ["2x6", "4x6", "Mini Wallet"]
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: { appState.navigationPath.removeLast() }) {
                    SnapIcon(type: .back, color: .primaryAccent, size: 22)
                }
                Text("Print & Share")
                    .font(.snapDisplayFallback)
                    .foregroundColor(.primaryAccent)
                Spacer()
                StepDots(currentStep: 4, totalSteps: 4)
                Button(action: { appState.resetBoothFlow() }) {
                    SnapIcon(type: .close, color: .gray, size: 20)
                }
            }
            .padding(.horizontal)
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(appState.selectedFrame.accentColor.opacity(0.3))
                    .frame(width: 200, height: 340)
                    .shadow(radius: 10)
                
                VStack(spacing: 8) {
                    ForEach(0..<4) { _ in
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.white)
                            .frame(width: 170, height: 65)
                            .overlay(
                                Image(systemName: "sparkles")
                                    .foregroundColor(appState.selectedFrame.accentColor)
                            )
                    }
                }
            }
            .offset(y: yOffset)
            .onAppear {
                withAnimation(.easeOut(duration: 0.6)) {
                    yOffset = 0
                }
            }
            
            HStack {
                ForEach(sizes, id: \.self) { size in
                    Button(size) { selectedSize = size }
                        .font(.snapCaptionFallback)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(selectedSize == size ? Color.primaryAccent : Color.gray.opacity(0.2))
                        .foregroundColor(selectedSize == size ? .white : .textPrimary)
                        .cornerRadius(12)
                }
            }
            
            VStack(spacing: 10) {
                PrimaryButton(
                    title: isSavedToApp ? "Saved to App Gallery! ✓" : "Save & Complete Session",
                    icon: .download,
                    backgroundColor: isSavedToApp ? .green : .primaryAccent
                ) {
                    if !isSavedToApp {
                        let newSession = PhotoSession(
                            id: UUID(),
                            date: Date(),
                            frameStyle: appState.selectedFrame.name,
                            frameColor: appState.selectedFrame.accentColor,
                            images: appState.capturedImages,
                            stripFormat: appState.selectedFormat
                        )
                        appState.addSession(session: newSession)
                        isSavedToApp = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            appState.resetBoothFlow()
                        }
                    }
                }
                
                SecondaryButton(title: "Save to Google Drive", icon: .profile) {}
                
                PrimaryButton(title: "Print Photo Strip", icon: .print, backgroundColor: .tertiaryAccent) {
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 12)
        }
        .background(Color.snapBackground.ignoresSafeArea())
        .toolbar(.hidden, for: .tabBar)
    }
}
