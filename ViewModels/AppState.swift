import SwiftUI

@MainActor
@Observable
class AppState {
    var isAuthenticated: Bool = false
    var isLoggingIn: Bool = false
    var currentUser: User? = MockData.currentUser
    var sessions: [PhotoSession] = MockData.sampleSessions
    var navigationPath = NavigationPath()
    var selectedTab: Int = 0
    
    var capturedImages: [UIImage] = []
    var selectedFormat: StripFormat = .fourCut
    var selectedFrame: FrameTemplate = MockData.sampleFrames[0]
    
    func login(email: String = "user@snapbooth.app", name: String = "Purikura User", provider: AuthProvider = .email) {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let namePart = cleanName.isEmpty ? "purikura_user" : cleanName.lowercased().replacingOccurrences(of: " ", with: "_")
        let username = "@" + namePart
        
        self.isLoggingIn = true
        
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 600_000_000)
            let newId = "USR-" + String(Int.random(in: 1000...9999))
            let user = User(
                id: newId,
                name: cleanName.isEmpty ? "Purikura User" : cleanName,
                username: username,
                email: email,
                authProvider: provider
            )
            self.currentUser = user
            
            self.syncUserToDatabase(user: user)
            
            self.isLoggingIn = false
            self.isAuthenticated = true
        }
    }
    
    func logout() {
        self.isAuthenticated = false
        self.currentUser = nil
        self.selectedTab = 0
        self.navigationPath = NavigationPath()
    }
    
    func addSession(session: PhotoSession) {
        self.sessions.insert(session, at: 0)
        self.syncSessionToDatabase(session: session)
    }
    
    func resetBoothFlow() {
        self.capturedImages.removeAll()
        self.navigationPath = NavigationPath()
        self.selectedTab = 0
    }
    
    private func syncUserToDatabase(user: User) {
        guard let url = URL(string: "http://localhost:8086/api/users/sync") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "id": user.id,
            "name": user.name,
            "username": user.username,
            "email": user.email,
            "authProvider": user.authProvider.rawValue
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        Task.detached {
            try? await URLSession.shared.data(for: request)
        }
    }
    
    private func syncSessionToDatabase(session: PhotoSession) {
        guard let url = URL(string: "http://localhost:8086/api/sessions/save") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "id": session.id.uuidString,
            "email": currentUser?.email ?? "guest@snapbooth.app",
            "frameStyle": session.frameStyle,
            "frameColorHex": "#FF6FA5",
            "stripFormat": session.stripFormat.rawValue
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        Task.detached {
            try? await URLSession.shared.data(for: request)
        }
    }
}
