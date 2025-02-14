import SwiftUI
import WebKit

struct LivestreamView: View {
    @State private var videoID: String = ""
    @State private var showAdminView = false
    @State private var isAdminAuthenticated = false
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            // Background with animated pattern
            AppColors.maroonGradient
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                ZStack {
                    // Animated circles
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(AppColors.richGold.opacity(0.1))
                            .frame(width: geometry.size.width * 0.8)
                            .blur(radius: 50)
                            .offset(x: geometry.size.width * 0.2 * CGFloat(index),
                                    y: geometry.size.height * 0.1 * CGFloat(index))
                    }
                }
            }
            
            VStack(spacing: 30) {
                // Enhanced Title
                Text("Awaazein Live")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(AppColors.richGold)
                    .shadow(color: AppColors.richGold.opacity(0.5), radius: 10)
                    .padding(.top, 40)
                    .onLongPress(minimumDuration: 3) {
                        showAdminView = true
                    }
                
                // Livestream Container
                VStack {
                    if !videoID.isEmpty {
                        EnhancedYouTubePlayer(videoID: videoID, isLoading: $isLoading)
                            .frame(maxWidth: .infinity)
                            .frame(height: UIScreen.main.bounds.width * 9/16)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(AppColors.richGold, lineWidth: 2)
                            )
                            .shadow(color: AppColors.richGold.opacity(0.3), radius: 15)
                    } else {
                        Text("No livestream available")
                            .foregroundColor(AppColors.softGold)
                    }
                    
                    if isLoading {
                        LoadingView()
                            .frame(height: 200)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.black.opacity(0.4))
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(AppColors.richGold.opacity(0.5), lineWidth: 1)
                        )
                )
                .padding()
                
                // Status message
                Text(isLoading ? "Connecting to livestream..." : "Live Now")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColors.softGold)
                    .opacity(0.8)
                
                Spacer()
            }
        }
        .onAppear {
            updateVideoID()
        }
        .onReceive(NotificationCenter.default.publisher(for: .livestreamLinkUpdated)) { _ in
            updateVideoID()
        }
        .sheet(isPresented: $showAdminView) {
            if !isAdminAuthenticated {
                AdminAuthView(isAuthenticated: $isAdminAuthenticated)
            } else {
                AdminLivestreamView(isAuthenticated: $isAdminAuthenticated)
            }
        }
    }
    
    private func updateVideoID() {
        let storedLink = SecureStorageManager.shared.getLivestreamLink() ?? ""
        if !storedLink.isEmpty {
            videoID = storedLink
            isLoading = false
        }
    }
}

struct EnhancedYouTubePlayer: UIViewRepresentable {
    let videoID: String
    @Binding var isLoading: Bool
    
    func makeUIView(context: Context) -> WKWebView {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.scrollView.isScrollEnabled = false
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let embedHTML = """
            <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <style>
                    body { margin: 0; background-color: black; }
                    .video-container { position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; }
                    .video-container iframe { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
                </style>
            </head>
            <body>
                <div class="video-container">
                    <iframe width="100%" height="100%"
                        src="https://www.youtube.com/embed/\(videoID)?autoplay=1&playsinline=1"
                        frameborder="0"
                        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                        allowfullscreen>
                    </iframe>
                </div>
            </body>
            </html>
        """
        webView.loadHTMLString(embedHTML, baseURL: nil)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: EnhancedYouTubePlayer
        
        init(_ parent: EnhancedYouTubePlayer) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }
    }
}

// LoadingView remains the same as in your existing code
struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(AppColors.richGold.opacity(0.3), lineWidth: 4)
                .frame(width: 50, height: 50)
            
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(AppColors.richGold, lineWidth: 4)
                .frame(width: 50, height: 50)
                .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
                .onAppear {
                    isAnimating = true
                }
        }
    }
}
