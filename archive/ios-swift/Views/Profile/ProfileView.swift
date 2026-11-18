import SwiftUI

struct ProfileDetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(.primaryAccent)
                .frame(width: 24)
            
            Text(title)
                .font(.snapBodyFallback)
                .foregroundColor(.textPrimary.opacity(0.7))
            
            Spacer()
            
            Text(value)
                .font(.snapBodyFallback)
                .bold()
                .foregroundColor(.textPrimary)
        }
    }
}

struct ProfileView: View {
    @Environment(AppState.self) var appState
    
    var body: some View {
        NavigationStack {
            ZStack {
                PurikuraBackground()
                
                ScrollView {
                    VStack(spacing: 22) {
                        Spacer().frame(height: 10)
                        
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [.primaryAccent.opacity(0.3), .cardPink], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 105, height: 105)
                                .shadow(color: .primaryAccent.opacity(0.25), radius: 10)
                            
                            Text(String(appState.currentUser?.name.prefix(1) ?? "N").uppercased())
                                .font(.system(size: 46, weight: .bold, design: .rounded))
                                .foregroundColor(.primaryAccent)
                            
                            Image(systemName: "sparkles")
                                .font(.title2)
                                .foregroundColor(.secondaryAccent)
                                .offset(x: 36, y: -36)
                        }
                        
                        VStack(spacing: 6) {
                            Text(appState.currentUser?.name ?? "Nopal Supriyadi")
                                .font(.snapDisplayFallback)
                                .foregroundColor(.textPrimary)
                            
                            Text(appState.currentUser?.username ?? "@nopal_supriyadi")
                                .font(.snapHeadlineFallback)
                                .foregroundColor(.primaryAccent)
                        }
                        
                        VStack(spacing: 18) {
                            HStack {
                                SnapIcon(type: .profile, color: .primaryAccent, size: 22)
                                Text("Informasi Akun")
                                    .font(.snapHeadlineFallback)
                                    .foregroundColor(.textPrimary)
                                Spacer()
                            }
                            .padding(.bottom, 4)
                            
                            Divider()
                            
                            ProfileDetailRow(icon: "person.fill", title: "Full Name", value: appState.currentUser?.name ?? "Nopal Supriyadi")
                            ProfileDetailRow(icon: "at", title: "Username", value: appState.currentUser?.username ?? "@nopal_supriyadi")
                            ProfileDetailRow(icon: "envelope.fill", title: "Email Address", value: appState.currentUser?.email ?? "user@snapbooth.app")
                            ProfileDetailRow(icon: "number", title: "Account ID", value: appState.currentUser?.id ?? "USR-101")
                            ProfileDetailRow(icon: "shield.checkmark.fill", title: "Auth Method", value: appState.currentUser?.authProvider.rawValue.capitalized ?? "Email")
                        }
                        .padding(22)
                        .background(Color.white.opacity(0.92))
                        .cornerRadius(24)
                        .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 5)
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            PrimaryButton(title: "Log Out Account", icon: .close, backgroundColor: .red) {
                                appState.logout()
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 10)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}
