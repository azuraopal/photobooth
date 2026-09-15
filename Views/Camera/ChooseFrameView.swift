import SwiftUI

struct ChooseFrameView: View {
    @Environment(AppState.self) var appState
    @State private var frames = MockData.sampleFrames
    @State private var selectedFrame: FrameTemplate = MockData.sampleFrames[0]
    @State private var selectedCategory: String = "All"
    @State private var showPhotoPreviewModal: Bool = false
    
    let categories = ["All", "3D Animal", "Purikura"]
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var filteredFrames: [FrameTemplate] {
        if selectedCategory == "All" {
            return frames
        } else {
            return frames.filter { $0.category == selectedCategory }
        }
    }
    
    var body: some View {
        VStack(spacing: 14) {
            HStack {
                Button(action: { appState.navigationPath.removeLast() }) {
                    SnapIcon(type: .back, color: .primaryAccent, size: 22)
                }
                Text("Pilih Bingkai 3D")
                    .font(.snapDisplayFallback)
                    .foregroundColor(.primaryAccent)
                Spacer()
                StepDots(currentStep: 2, totalSteps: 4)
                Button(action: { appState.resetBoothFlow() }) {
                    SnapIcon(type: .close, color: .gray, size: 20)
                }
            }
            .padding(.horizontal)
            .padding(.top, 6)
            
            HStack(spacing: 10) {
                ForEach(categories, id: \.self) { cat in
                    Button(action: { selectedCategory = cat }) {
                        Text(cat)
                            .font(.snapCaptionFallback)
                            .bold()
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(selectedCategory == cat ? Color.primaryAccent : Color.white.opacity(0.8))
                            .foregroundColor(selectedCategory == cat ? .white : .textPrimary)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.04), radius: 4)
                    }
                }
                Spacer()
                
                Button(action: { showPhotoPreviewModal = true }) {
                    HStack(spacing: 4) {
                        Image(systemName: "eye.fill")
                        Text("Preview Hasil Foto")
                    }
                    .font(.snapCaptionFallback)
                    .bold()
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.tertiaryAccent)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                }
            }
            .padding(.horizontal)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(filteredFrames) { frame in
                        ZStack(alignment: .topTrailing) {
                            VStack(spacing: 10) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 18)
                                        .fill(
                                            LinearGradient(
                                                colors: [frame.accentColor.opacity(0.35), frame.accentColor.opacity(0.1)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(height: 150)
                                        .shadow(color: frame.accentColor.opacity(0.2), radius: 6, x: 0, y: 4)
                                    
                                    VStack(spacing: 6) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.white)
                                                .frame(width: 58, height: 58)
                                                .shadow(color: Color.black.opacity(0.1), radius: 4)
                                            
                                            Image(systemName: frame.iconName)
                                                .font(.system(size: 30, weight: .bold))
                                                .foregroundColor(frame.accentColor)
                                        }
                                        
                                        Text(frame.badgeText)
                                            .font(.snapCaptionFallback)
                                            .bold()
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 2)
                                            .background(Color.white.opacity(0.9))
                                            .cornerRadius(10)
                                            .foregroundColor(.textPrimary)
                                    }
                                }
                                
                                VStack(spacing: 2) {
                                    Text(frame.name)
                                        .font(.snapHeadlineFallback)
                                        .foregroundColor(.textPrimary)
                                    
                                    Text(frame.description)
                                        .font(.system(size: 11, weight: .medium, design: .rounded))
                                        .foregroundColor(.textPrimary.opacity(0.65))
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                }
                            }
                            .padding(12)
                            .background(Color.white)
                            .cornerRadius(22)
                            .overlay(
                                RoundedRectangle(cornerRadius: 22)
                                    .stroke(selectedFrame.id == frame.id ? Color.primaryAccent : Color.clear, lineWidth: 3.5)
                            )
                            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
                            .onTapGesture { selectedFrame = frame }
                            
                            if selectedFrame.id == frame.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.primaryAccent)
                                    .padding(10)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
            
            PrimaryButton(title: "Gunakan Bingkai & Hias", icon: .addSticker) {
                appState.selectedFrame = selectedFrame
                appState.navigationPath.append("DecorateStripView")
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 12)
        }
        .background(PurikuraBackground())
        .toolbar(.hidden, for: .tabBar)
        .sheet(isPresented: $showPhotoPreviewModal) {
            PhotoResultPreviewSheet(selectedFrame: selectedFrame)
        }
    }
}


struct PhotoResultPreviewSheet: View {
    let selectedFrame: FrameTemplate
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 18) {
            Capsule()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 5)
                .padding(.top, 10)
            
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(.secondaryAccent)
                Text("Preview Hasil Foto SnapBooth")
                    .font(.snapDisplayFallback)
                    .foregroundColor(.primaryAccent)
                Image(systemName: "sparkles")
                    .foregroundColor(.secondaryAccent)
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        LinearGradient(
                            colors: [selectedFrame.accentColor, selectedFrame.accentColor.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 210, height: 380)
                    .shadow(color: selectedFrame.accentColor.opacity(0.4), radius: 12, x: 0, y: 6)
                
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: selectedFrame.iconName)
                            .font(.title3)
                            .foregroundColor(.white)
                        Text(selectedFrame.name)
                            .font(.snapCaptionFallback)
                            .bold()
                            .foregroundColor(.white)
                    }
                    .padding(.top, 8)
                    
                    ForEach(1...4, id: \.self) { idx in
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(width: 180, height: 72)
                            
                            VStack(spacing: 2) {
                                Image(systemName: "person.crop.rectangle.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(selectedFrame.accentColor)
                                Text("Foto Pose #\(idx)")
                                    .font(.system(size: 9, weight: .bold, design: .rounded))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    Text("♥ SnapBooth Purikura ♥")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.bottom, 6)
                }
            }
            
            PrimaryButton(title: "Tutup Preview", icon: .close, backgroundColor: .gray) {
                dismiss()
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 20)
        }
        .padding()
        .background(Color.white)
    }
}
