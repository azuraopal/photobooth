import SwiftUI

struct OTPInputField: View {
    let numberOfFields: Int = 6
    @Binding var otp: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            TextField("", text: $otp)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .focused($isFocused)
                .opacity(0.01)
                .onChange(of: otp) { oldValue, newValue in
                    if newValue.count > numberOfFields {
                        otp = String(newValue.prefix(numberOfFields))
                    }
                }
            
            HStack(spacing: 10) {
                ForEach(0..<numberOfFields, id: \.self) { index in
                    let digit = getDigit(at: index)
                    Text(digit)
                        .font(.title.bold())
                        .foregroundColor(.primaryAccent)
                        .frame(width: 45, height: 55)
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    (otp.count == index || (otp.count == numberOfFields && index == numberOfFields - 1)) ? Color.primaryAccent : Color.primaryAccent.opacity(0.3),
                                    lineWidth: 2
                                )
                        )
                }
            }
        }
        .onTapGesture {
            isFocused = true
        }
        .onAppear {
            isFocused = true
        }
    }
    
    private func getDigit(at index: Int) -> String {
        if index < otp.count {
            let start = otp.index(otp.startIndex, offsetBy: index)
            return String(otp[start])
        }
        return ""
    }
}
