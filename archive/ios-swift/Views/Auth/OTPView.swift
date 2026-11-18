import Combine
import SwiftUI

struct OTPView: View {
    let flow: OTPFlow
    var userEmail: String = ""
    var userName: String = ""
    
    @Environment(AppState.self) var appState
    @State private var otp = ""
    @State private var generatedOTP = String(format: "%06d", Int.random(in: 100000...999999))
    @State private var timeRemaining = 45
    @State private var timerActive = true
    @State private var navigateToReset = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            PurikuraBackground()
            
            VStack(spacing: 24) {
                Spacer().frame(height: 10)
                
                HStack(spacing: 6) {
                    Image(systemName: "envelope.badge.shield.halffilled")
                        .font(.title)
                        .foregroundColor(.primaryAccent)
                    Text("Verify OTP")
                        .font(.snapDisplayFallback)
                        .foregroundColor(.primaryAccent)
                }
                
                VStack(spacing: 12) {
                    Text("Enter the 6-digit code sent to your email:")
                        .font(.snapBodyFallback)
                        .foregroundColor(.textPrimary.opacity(0.7))
                        .multilineTextAlignment(.center)
                    
                    Text(userEmail.isEmpty ? "user@snapbooth.app" : userEmail)
                        .font(.snapHeadlineFallback)
                        .foregroundColor(.primaryAccent)
                }
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(Color.white.opacity(0.85))
                .cornerRadius(20)
                
                OTPInputField(otp: $otp)
                    .padding(.vertical, 10)
                
                HStack(spacing: 6) {
                    Image(systemName: "timer")
                        .foregroundColor(.primaryAccent)
                    Text(timeRemaining > 0 ? "Resend code in \(timeRemaining)s" : "Didn't receive code?")
                        .font(.snapCaptionFallback)
                        .foregroundColor(.textPrimary.opacity(0.6))
                }
                
                Button(action: {
                    timeRemaining = 45
                    timerActive = true
                    generatedOTP = String(format: "%06d", Int.random(in: 100000...999999))
                    sendOTPViaSMTP()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.clockwise")
                        Text("Resend Code")
                    }
                }
                .disabled(timeRemaining > 0)
                .font(.snapBodyFallback)
                .bold()
                .foregroundColor(timeRemaining > 0 ? .gray : .primaryAccent)
                
                PrimaryButton(title: "Submit Code", icon: .heart, isDisabled: otp.count < 6) {
                    if flow == .signUp {
                        let displayName = userName.isEmpty ? "Purikura User" : userName
                        let displayEmail = userEmail.isEmpty ? "user@snapbooth.app" : userEmail
                        appState.login(email: displayEmail, name: displayName, provider: .email)
                    } else {
                        navigateToReset = true
                    }
                }
                
                Spacer()
            }
            .padding(24)
        }
        .onAppear {
            sendOTPViaSMTP()
        }
        .onReceive(timer) { _ in
            if timerActive && timeRemaining > 0 {
                timeRemaining -= 1
            } else if timeRemaining == 0 {
                timerActive = false
            }
        }
        .navigationDestination(isPresented: $navigateToReset) { ResetPasswordView() }
    }
    
    private func sendOTPViaSMTP() {
        guard let url = URL(string: "http://localhost:8085/send-otp") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = [
            "email": userEmail.isEmpty ? "user@snapbooth.app" : userEmail,
            "name": userName.isEmpty ? "Purikura Fan" : userName,
            "otp": generatedOTP
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request).resume()
    }
}
