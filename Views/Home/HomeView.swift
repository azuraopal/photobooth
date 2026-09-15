import SwiftUI

struct HomeView: View {
    @Environment(AppState.self) var appState
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            PurikuraBackground()
            
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            HStack(spacing: 6) {
                                Text("SnapBooth")
                                    .font(.snapDisplayFallback)
                                    .foregroundColor(.primaryAccent)
                                Image(systemName: "sparkles")
                                    .foregroundColor(.secondaryAccent)
                                    .font(.title3)
                            }
                            Text("Purikura Memories & 3D Frames")
                                .font(.snapCaptionFallback)
                                .foregroundColor(.textPrimary.opacity(0.6))
                        }
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [.primaryAccent.opacity(0.3), .cardPink], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 44, height: 44)
                            
                            Text(String(appState.currentUser?.name.prefix(1) ?? "N").uppercased())
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.primaryAccent)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 6) {
                            Image(systemName: "rectangle.3.group.fill")
                                .foregroundColor(.primaryAccent)
                            Text("PILIH FORMAT STRIP FOTO")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundColor(.primaryAccent)
                        }
                        .padding(.horizontal, 4)
                        
                        HStack(spacing: 8) {
                            ForEach(StripFormat.allCases) { format in
                                Button(action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        appState.selectedFormat = format
                                    }
                                }) {
                                    VStack(spacing: 6) {
                                        Image(systemName: formatIcon(for: format))
                                            .font(.system(size: 18, weight: .bold))
                                        
                                        Text(formatShortName(for: format))
                                            .font(.system(size: 12, weight: .bold, design: .rounded))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        appState.selectedFormat == format ?
                                        LinearGradient(colors: [.primaryAccent, Color(red: 1.0, green: 0.35, blue: 0.6)], startPoint: .topLeading, endPoint: .bottomTrailing) :
                                        LinearGradient(colors: [Color.white.opacity(0.6), Color.white.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    )
                                    .foregroundColor(appState.selectedFormat == format ? .white : .textPrimary)
                                    .cornerRadius(18)
                                    .shadow(color: appState.selectedFormat == format ? Color.primaryAccent.opacity(0.4) : Color.clear, radius: 6)
                                }
                            }
                        }
                    }
                    .padding(16)
                    .telegramLiquidGlass(cornerRadius: 24)
                    .padding(.horizontal)
                    
                    ZStack {
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 56, height: 56)
                                    .shadow(color: appState.selectedFrame.accentColor.opacity(0.35), radius: 6)
                                
                                Image(systemName: appState.selectedFrame.iconName)
                                    .font(.title)
                                    .foregroundColor(appState.selectedFrame.accentColor)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text("BINGKAI 3D AKTIF")
                                        .font(.system(size: 11, weight: .bold, design: .rounded))
                                        .foregroundColor(.primaryAccent)
                                    Spacer()
                                    Text(appState.selectedFrame.badgeText)
                                        .font(.system(size: 10, weight: .bold, design: .rounded))
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 3)
                                        .background(Color.white)
                                        .cornerRadius(8)
                                }
                                Text(appState.selectedFrame.name)
                                    .font(.snapHeadlineFallback)
                                    .foregroundColor(.textPrimary)
                                Text(appState.selectedFrame.description)
                                    .font(.system(size: 11, weight: .medium, design: .rounded))
                                    .foregroundColor(.textPrimary.opacity(0.7))
                                    .lineLimit(1)
                            }
                        }
                        .padding(16)
                    }
                    .telegramLiquidGlass(cornerRadius: 24)
                    .padding(.horizontal)
                    
                    PrimaryButton(title: "Mulai Foto Purikura 3D", icon: .camera) {
                        appState.navigationPath.append("CameraBoothView")
                    }
                    .padding(.horizontal, 24)
                    
                    HStack {
                        Text("Galeri Sesi Foto Terbaru")
                            .font(.snapHeadlineFallback)
                            .foregroundColor(.textPrimary)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 6)
                    
                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(appState.sessions) { session in
                            PhotoCard(
                                title: session.frameStyle,
                                dateString: session.formattedDate,
                                color: session.frameColor.opacity(0.3)
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private func formatIcon(for format: StripFormat) -> String {
        switch format {
        case .fourCut: return "rectangle.split.3x1.fill"
        case .square: return "square.grid.2x2.fill"
        case .singleBig: return "rectangle.portrait.fill"
        }
    }
    
    private func formatShortName(for format: StripFormat) -> String {
        switch format {
        case .fourCut: return "4-Cut"
        case .square: return "2x2 Grid"
        case .singleBig: return "1-Poster"
        }
    }
}
