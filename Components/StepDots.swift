import SwiftUI

struct StepDots: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(1...totalSteps, id: \.self) { step in
                Circle()
                    .fill(step == currentStep ? Color.primaryAccent : Color.primaryAccent.opacity(0.3))
                    .frame(width: step == currentStep ? 10 : 7, height: step == currentStep ? 10 : 7)
                    .animation(.spring(response: 0.3), value: currentStep)
            }
        }
    }
}
