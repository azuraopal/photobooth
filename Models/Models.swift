import SwiftUI

enum OTPFlow {
    case signUp
    case passwordReset
}

enum AuthProvider: String, Codable {
    case google
    case email
}

enum StripFormat: String, Codable, CaseIterable, Identifiable {
    case fourCut = "4-Cut Classic"
    case square = "2x2 Grid"
    case singleBig = "1-Photo Poster"
    
    var id: String { rawValue }
}

struct FrameTemplate: Identifiable, Hashable {
    let id: String
    let name: String
    let category: String
    let accentColor: Color
    let iconName: String
    let badgeText: String
    let description: String
}

struct User: Identifiable, Codable {
    let id: String
    var name: String
    var username: String
    let email: String
    let authProvider: AuthProvider
    var profileImageURL: String?
}

struct PhotoSession: Identifiable {
    let id: UUID
    let date: Date
    let frameStyle: String
    let frameColor: Color
    let images: [UIImage]
    let stripFormat: StripFormat
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
