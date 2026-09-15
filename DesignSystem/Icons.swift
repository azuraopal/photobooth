import SwiftUI

enum SnapIconType {
    case camera, heart, gallery, profile, back, close, addSticker, download, print, settings
    
    var sfSymbolName: String {
        switch self {
        case .camera: return "camera.fill"
        case .heart: return "heart.fill"
        case .gallery: return "photo.on.rectangle"
        case .profile: return "person.crop.circle"
        case .back: return "chevron.left"
        case .close: return "xmark"
        case .addSticker: return "face.smiling"
        case .download: return "square.and.arrow.down"
        case .print: return "printer.fill"
        case .settings: return "gearshape.fill"
        }
    }
}

struct SnapIcon: View {
    let type: SnapIconType
    var color: Color = .primaryAccent
    var size: CGFloat = 20
    
    var body: some View {
        Image(systemName: type.sfSymbolName)
            .font(.system(size: size, weight: .semibold, design: .rounded))
            .foregroundColor(color)
    }
}
