import SwiftUI

struct TelegramLiquidGlassModifier: ViewModifier {
    var cornerRadius: CGFloat = 28
    
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(.ultraThinMaterial)
                    
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.85),
                                    Color.white.opacity(0.55)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white,
                                    Color.primaryAccent.opacity(0.4),
                                    Color.white.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                }
            )
            .shadow(color: Color.black.opacity(0.1), radius: 12, x: 0, y: 5)
    }
}

extension View {
    func telegramLiquidGlass(cornerRadius: CGFloat = 28) -> some View {
        self.modifier(TelegramLiquidGlassModifier(cornerRadius: cornerRadius))
    }
}

struct CustomTelegramTabBar: View {
    @Binding var selectedTab: Int
    
    let tabs: [(icon: String, label: String, tag: Int)] = [
        ("house.fill", "Home", 0),
        ("camera.fill", "Booth", 1),
        ("photo.on.rectangle.fill", "Gallery", 2),
        ("person.crop.circle.fill", "Profile", 3)
    ]
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(tabs, id: \.tag) { tab in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                        selectedTab = tab.tag
                    }
                }) {
                    VStack(spacing: 4) {
                        ZStack {
                            if selectedTab == tab.tag {
                                Capsule()
                                    .fill(
                                        LinearGradient(colors: [.primaryAccent, Color(red: 1.0, green: 0.35, blue: 0.6)], startPoint: .leading, endPoint: .trailing)
                                    )
                                    .frame(height: 36)
                                    .shadow(color: .primaryAccent.opacity(0.4), radius: 6, x: 0, y: 3)
                            }
                            
                            HStack(spacing: 5) {
                                Image(systemName: tab.icon)
                                    .font(.system(size: 15, weight: .bold))
                                
                                if selectedTab == tab.tag {
                                    Text(tab.label)
                                        .font(.system(size: 12, weight: .bold, design: .rounded))
                                        .lineLimit(1)
                                }
                            }
                            .padding(.horizontal, 10)
                            .foregroundColor(selectedTab == tab.tag ? .white : .textPrimary.opacity(0.7))
                        }
                        .frame(height: 36)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .telegramLiquidGlass(cornerRadius: 28)
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }
}

struct MainTabView: View {
    @Environment(AppState.self) var appState
    
    var body: some View {
        @Bindable var appStateBindable = appState
        
        ZStack(alignment: .bottom) {
            TabView(selection: $appStateBindable.selectedTab) {
                NavigationStack(path: $appStateBindable.navigationPath) {
                    HomeView()
                        .navigationDestination(for: String.self) { destination in
                            switch destination {
                            case "CameraBoothView":
                                CameraBoothView()
                            case "ChooseFrameView":
                                ChooseFrameView()
                            case "DecorateStripView":
                                DecorateStripView()
                            case "PrintPreviewView":
                                PrintPreviewView()
                            default:
                                EmptyView()
                            }
                        }
                }
                .tag(0)
                
                NavigationStack(path: $appStateBindable.navigationPath) {
                    CameraBoothView()
                        .navigationDestination(for: String.self) { destination in
                            switch destination {
                            case "ChooseFrameView":
                                ChooseFrameView()
                            case "DecorateStripView":
                                DecorateStripView()
                            case "PrintPreviewView":
                                PrintPreviewView()
                            default:
                                EmptyView()
                            }
                        }
                }
                .tag(1)
                
                GalleryView()
                    .tag(2)
                
                ProfileView()
                    .tag(3)
            }
            .toolbar(.hidden, for: .tabBar)
            
            CustomTelegramTabBar(selectedTab: $appStateBindable.selectedTab)
        }
        .accentColor(.primaryAccent)
    }
}
