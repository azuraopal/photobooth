import SwiftUI

struct MockData {
    static let sampleFrames: [FrameTemplate] = [
        FrameTemplate(id: "1", name: "3D Panda Bamboo", category: "3D Animal", accentColor: Color(red: 0.2, green: 0.7, blue: 0.4), iconName: "leaf.fill", badgeText: "3D Popular 🐼", description: "Bingkai 3D Panda lucu dengan aksen bambu segar"),
        FrameTemplate(id: "2", name: "3D Bear Honey", category: "3D Animal", accentColor: Color(red: 0.9, green: 0.6, blue: 0.2), iconName: "pawprint.fill", badgeText: "3D Cute 🐻", description: "Karakter beruang 3D imut dengan toples madu"),
        FrameTemplate(id: "3", name: "3D Bunny Cloud", category: "3D Animal", accentColor: Color(red: 0.9, green: 0.5, blue: 0.7), iconName: "cloud.rainbow.half.fill", badgeText: "3D Soft 🐰", description: "Kelinci 3D melayang di awan pelangi manis"),
        FrameTemplate(id: "4", name: "3D Cat Donut", category: "3D Animal", accentColor: Color(red: 0.95, green: 0.4, blue: 0.5), iconName: "heart.circle.fill", badgeText: "3D Sweet 🐱", description: "Kucing 3D mengintip dari donat strawberry"),
        
        FrameTemplate(id: "5", name: "Sakura Purikura", category: "Purikura", accentColor: Color.primaryAccent, iconName: "sparkles", badgeText: "Kawaii ✨", description: "Efek kilau sakura pink khas photobooth Jepang"),
        FrameTemplate(id: "6", name: "Banana Party", category: "Purikura", accentColor: Color.secondaryAccent, iconName: "sun.max.fill", badgeText: "Vibrant 🍌", description: "Kuning ceria bersemangat dengan stiker bintang"),
        FrameTemplate(id: "7", name: "Sky Dreamer", category: "Purikura", accentColor: Color.tertiaryAccent, iconName: "cloud.fill", badgeText: "Dreamy ☁️", description: "Warna biru langit dengan awan kapas lembut"),
        FrameTemplate(id: "8", name: "Retro Charcoal", category: "Purikura", accentColor: Color.textPrimary, iconName: "moon.stars.fill", badgeText: "Classic 🌙", description: "Gaya monokrom estetis bercahaya bulan")
    ]
    
    static let sampleSessions: [PhotoSession] = [
        PhotoSession(id: UUID(), date: Date(), frameStyle: "3D Panda Bamboo", frameColor: Color(red: 0.2, green: 0.7, blue: 0.4), images: [], stripFormat: .fourCut),
        PhotoSession(id: UUID(), date: Date().addingTimeInterval(-86400 * 2), frameStyle: "Sakura Purikura", frameColor: .primaryAccent, images: [], stripFormat: .square),
        PhotoSession(id: UUID(), date: Date().addingTimeInterval(-86400 * 5), frameStyle: "3D Bear Honey", frameColor: Color(red: 0.9, green: 0.6, blue: 0.2), images: [], stripFormat: .fourCut)
    ]
    
    static let currentUser = User(id: "usr_101", name: "Nopal Supriyadi", username: "@nopal_supriyadi", email: "user@snapbooth.app", authProvider: .email)
}
