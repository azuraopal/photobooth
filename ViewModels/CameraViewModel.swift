import SwiftUI
import AVFoundation

@Observable
class CameraViewModel: NSObject {
    var isFlashOn: Bool = false
    var cameraPosition: AVCaptureDevice.Position = .front
    var isFourCutMode: Bool = true
    var capturedImages: [UIImage] = []
    
    func toggleCamera() {
        cameraPosition = (cameraPosition == .front) ? .back : .front
    }
    
    func toggleFlash() {
        isFlashOn.toggle()
    }
}
