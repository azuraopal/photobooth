import SwiftUI

struct GalleryView: View {
    @Environment(AppState.self) var appState
    
    var body: some View {
        NavigationStack {
            ZStack {
                PurikuraBackground()
                
                List {
                    Section(header: Text("Recent Sessions (\(appState.sessions.count))").font(.snapHeadlineFallback)) {
                        ForEach(appState.sessions) { session in
                            HStack(spacing: 14) {
                                Circle()
                                    .fill(session.frameColor)
                                    .frame(width: 14, height: 14)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(session.frameStyle)
                                        .font(.snapBodyFallback)
                                        .bold()
                                    Text(session.formattedDate)
                                        .font(.snapCaptionFallback)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                SnapIcon(type: .gallery, color: .primaryAccent, size: 20)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Purikura Gallery")
        }
    }
}
