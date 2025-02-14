import SwiftUI

@main
struct AwaazeinApp: App {
    init() {
        // IMPORTANT: Run ONLY ONCE to set initial password
        // Then comment out or remove this line
        SecureStorageManager.shared.setAdminCredentials(password: "Audi@06032003")
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
