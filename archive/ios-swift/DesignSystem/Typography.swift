import SwiftUI



extension Font {
    static var snapDisplay: Font {
        .custom("Fredoka-Bold", size: 32, relativeTo: .largeTitle)
    }
    static var snapHeadline: Font {
        .custom("Fredoka-Medium", size: 22, relativeTo: .headline)
    }
    static var snapBody: Font {
        .custom("Quicksand-Regular", size: 16, relativeTo: .body)
    }
    static var snapCaption: Font {
        .custom("Quicksand-Medium", size: 13, relativeTo: .caption)
    }
    
    static var snapDisplayFallback: Font { .system(.largeTitle, design: .rounded).bold() }
    static var snapHeadlineFallback: Font { .system(.headline, design: .rounded).bold() }
    static var snapBodyFallback: Font { .system(.body, design: .rounded) }
    static var snapCaptionFallback: Font { .system(.caption, design: .rounded) }
}
