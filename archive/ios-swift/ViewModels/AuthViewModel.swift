import SwiftUI

@Observable
class AuthViewModel {
    var isAuthenticated: Bool = false
    var currentUser: User? = MockData.currentUser
    
    func login() {
        isAuthenticated = true
    }
    
    func logout() {
        isAuthenticated = false
    }
}
