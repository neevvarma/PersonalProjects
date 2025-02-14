import SwiftUI

// Admin Authentication View
struct AdminAuthView: View {
    @State private var password = ""
    @State private var showError = false
    @Binding var isAuthenticated: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            // Background gradient
            AppColors.maroonGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header with dismiss button
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(AppColors.richGold)
                            .padding()
                            .background(Color.black.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
                .padding(.top)
                .padding(.horizontal)
                
                // Title
                Text("Admin Access")
                    .font(.largeTitle)
                    .foregroundColor(AppColors.richGold)
                
                // Password Field
                SecureField("Enter Admin Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                
                // Login Button
                Button(action: authenticate) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding()
                        .background(AppColors.richGold)
                        .cornerRadius(10)
                }
                
                // Error Message
                if showError {
                    Text("Invalid Credentials")
                        .foregroundColor(.red)
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
    private func authenticate() {
        if SecureStorageManager.shared.validateAdminCredentials(password: password) {
            isAuthenticated = true
        } else {
            showError = true
            password = ""
        }
    }
}

// Admin Livestream Management View
struct AdminLivestreamView: View {
    @State private var livestreamLink = ""
    @State private var showSuccessMessage = false
    @Binding var isAuthenticated: Bool
    
    var body: some View {
        ZStack {
            AppColors.maroonGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Livestream Link Management")
                    .font(.title)
                    .foregroundColor(AppColors.richGold)
                
                TextField("Enter YouTube Livestream Link", text: $livestreamLink)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                
                Button(action: updateLink) {
                    Text("Update Livestream Link")
                        .foregroundColor(.white)
                        .padding()
                        .background(AppColors.richGold)
                        .cornerRadius(10)
                }
                
                if showSuccessMessage {
                    Text("Livestream Link Updated Successfully")
                        .foregroundColor(AppColors.softGold)
                }
                
                Button(action: logout) {
                    Text("Logout")
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .padding()
        }
    }
    
    private func updateLink() {
        guard !livestreamLink.isEmpty else { return }
        
        // Extract YouTube video ID from various link formats
        let videoID = extractYouTubeVideoID(from: livestreamLink)
        
        print("Original Link: \(livestreamLink)")
        print("Extracted Video ID: \(videoID ?? "No ID found")")
        
        if let extractedID = videoID {
            SecureStorageManager.shared.updateLivestreamLink(extractedID)
            showSuccessMessage = true
            
            // Hide success message after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                showSuccessMessage = false
            }
        } else {
            // Show an error message if no video ID could be extracted
            print("Failed to extract video ID from the link")
        }
    }
    
    private func extractYouTubeVideoID(from link: String) -> String? {
        // Remove any whitespace
        let cleanedLink = link.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Handle different YouTube link formats
        let patterns = [
            // Standard watch URL with or without https
            "(?:https?:\\/\\/)?(?:www\\.)?youtube\\.com\\/watch\\?v=([^&\\s]+)",
            
            // Shortened youtu.be links with or without parameters
            "(?:https?:\\/\\/)?(?:www\\.)?youtu\\.be\\/([^?&\\s]+)(?:\\?.*)?",
            
            // Embed links
            "(?:https?:\\/\\/)?(?:www\\.)?youtube\\.com\\/embed\\/([^?&\\s]+)",
            
            // More flexible pattern for youtu.be links
            "youtu\\.be\\/([^\\?&\\s]+)"
        ]
        
        for pattern in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: []),
               let match = regex.firstMatch(in: cleanedLink, options: [], range: NSRange(location: 0, length: cleanedLink.utf16.count)) {
                
                let nsString = cleanedLink as NSString
                let videoIDRange = match.range(at: 1)
                
                if videoIDRange.location != NSNotFound {
                    let extractedID = nsString.substring(with: videoIDRange)
                    print("Extracted ID: \(extractedID)")
                    return extractedID
                }
            }
        }
        
        return nil
    }
    
    private func logout() {
        isAuthenticated = false
    }
}
