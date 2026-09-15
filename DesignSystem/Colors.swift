import SwiftUI

extension Color {
    static let snapBackground = Color(red: 255/255, green: 251/255, blue: 245/255)
    static let primaryAccent = Color(red: 255/255, green: 111/255, blue: 165/255)
    static let secondaryAccent = Color(red: 255/255, green: 210/255, blue: 63/255)
    static let tertiaryAccent = Color(red: 79/255, green: 195/255, blue: 224/255)
    static let textPrimary = Color(red: 43/255, green: 33/255, blue: 24/255)
    static let cardPink = Color(red: 255/255, green: 227/255, blue: 238/255)
    
    static let primaryAccentPressed = primaryAccent.opacity(0.8)
    static let primaryAccentDisabled = primaryAccent.opacity(0.4)
}
