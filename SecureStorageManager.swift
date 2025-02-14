import Foundation
import CryptoKit

class SecureStorageManager {
    static let shared = SecureStorageManager()
    private let adminCredentialsKey = "adminCredentialsHash"
    private let livestreamLinkKey = "livestreamLink"
    
    private init() {}
    
    // Hash a password securely
    private func hashPassword(_ password: String) -> String {
        let inputData = Data(password.utf8)
        let hashedData = SHA256.hash(data: inputData)
        return hashedData.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    // Set admin credentials (should be done only once)
    func setAdminCredentials(password: String) {
        let hashedPassword = hashPassword(password)
        UserDefaults.standard.set(hashedPassword, forKey: adminCredentialsKey)
    }
    
    // Validate admin credentials
    func validateAdminCredentials(password: String) -> Bool {
        guard let storedHash = UserDefaults.standard.string(forKey: adminCredentialsKey) else {
            return false
        }
        return storedHash == hashPassword(password)
    }
    
    // Store livestream link
    func updateLivestreamLink(_ link: String) {
        UserDefaults.standard.set(link, forKey: livestreamLinkKey)
        // Post a notification when the link is updated
        NotificationCenter.default.post(name: .livestreamLinkUpdated, object: nil)
    }
    
    // Retrieve livestream link
    func getLivestreamLink() -> String? {
        return UserDefaults.standard.string(forKey: livestreamLinkKey)
    }
}

// Add this extension
extension Notification.Name {
    static let livestreamLinkUpdated = Notification.Name("livestreamLinkUpdated")
}
