import SwiftUI

struct CameraBoothView: View {
    @Environment(AppState.self) var appState
    @State private var cameraVM = CameraViewModel()
    @State private var countdown = 0
    @State private var isFlashing = false
    @State private var simulatedCameraColorToggle = false
    
    var body: some View {
        ZStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                LinearGradient(
                    colors: cameraVM.cameraPosition == .front ? 
                        [Color.purple.opacity(0.4), Color.pink.opacity(0.3)] : 
                        [Color.blue.opacity(0.4), Color.teal.opacity(0.3)],
                    startPoint: simulatedCameraColorToggle ? .topLeading : .bottomLeading,
                    endPoint: simulatedCameraColorToggle ? .bottomTrailing : .topTrailing
                )
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: simulatedCameraColorToggle)
                .onAppear { simulatedCameraColorToggle.toggle() }
                
                VStack {
                    Spacer()
                    Divider().background(Color.white.opacity(0.3))
                    Spacer()
                    Divider().background(Color.white.opacity(0.3))
                    Spacer()
                }
                HStack {
                    Spacer()
                    Divider().background(Color.white.opacity(0.3))
                    Spacer()
                    Divider().background(Color.white.opacity(0.3))
                    Spacer()
                }
                
                VStack(spacing: 8) {
                    Image(systemName: cameraVM.cameraPosition == .front ? "person.fill.viewfinder" : "camera.metering.matrix")
                        .font(.system(size: 60))
                        .foregroundColor(.white.opacity(0.8))
                    Text(cameraVM.cameraPosition == .front ? "Front Camera Active" : "Rear Camera Active")
                        .font(.snapBodyFallback)
                        .foregroundColor(.white.opacity(0.9))
                }
            }
            
            if countdown > 0 {
                Text("\(countdown)")
                    .font(.system(size: 110, weight: .bold, design: .rounded))
                    .foregroundColor(.secondaryAccent)
                    .shadow(radius: 10)
            }
            
            if isFlashing {
                Color.white.ignoresSafeArea()
                    .transition(.opacity)
            }
            
            VStack {
                HStack {
                    Button(action: {
                        appState.resetBoothFlow()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                    .contentShape(Rectangle())
                    .zIndex(10)
                    
                    Spacer()
                    StepDots(currentStep: 1, totalSteps: 4)
                    Spacer()
                    
                    Button(action: { cameraVM.toggleCamera() }) {
                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Spacer()
                
                HStack(spacing: 36) {
                    Button(action: { cameraVM.toggleFlash() }) {
                        Image(systemName: cameraVM.isFlashOn ? "bolt.fill" : "bolt.slash.fill")
                            .font(.title2)
                            .foregroundColor(cameraVM.isFlashOn ? .yellow : .white)
                            .frame(width: 44, height: 44)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                    
                    Button(action: startCountdown) {
                        Circle()
                            .stroke(Color.white, lineWidth: 4)
                            .frame(width: 72, height: 72)
                            .overlay(Circle().fill(Color.primaryAccent).padding(6))
                            .shadow(color: Color.primaryAccent.opacity(0.5), radius: 10)
                    }
                    
                    Button(cameraVM.isFourCutMode ? "4-Cut" : "Single") {
                        cameraVM.isFourCutMode.toggle()
                    }
                    .font(.snapCaptionFallback)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(16)
                }
                .padding(.bottom, 110)
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
    
    private func startCountdown() {
        countdown = 3
        Task { @MainActor in
            for _ in 0..<3 {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                if countdown > 1 {
                    countdown -= 1
                } else {
                    countdown = 0
                    triggerFlashAndCapture()
                    break
                }
            }
        }
    }
    
    private func triggerFlashAndCapture() {
        withAnimation(.easeOut(duration: 0.15)) { isFlashing = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            isFlashing = false
            appState.capturedImages = (0..<4).map { _ in UIImage() }
            appState.navigationPath.append("ChooseFrameView")
        }
    }
}
