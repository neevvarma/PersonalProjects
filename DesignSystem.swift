import SwiftUI

// MARK: - Custom Colors
struct AppColors {
    static let deepMaroon = Color(hex: "4A071C")
    static let richGold = Color(hex: "D4AF37")
    static let softGold = Color(hex: "F4E4BC")
    static let nightBlack = Color(hex: "0A0A0A")
    static let charcoal = Color(hex: "1E1E1E")
    
    // Gradients
    static let maroonGradient = LinearGradient(
        colors: [deepMaroon, nightBlack],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let goldGradient = LinearGradient(
        colors: [richGold, softGold],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Card Styles
struct GlassCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white.opacity(0.05))
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.white.opacity(0.05))
                            .blur(radius: 10)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(AppColors.richGold.opacity(0.3), lineWidth: 0.5)
            )
            .shadow(color: AppColors.richGold.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

struct PremiumCard: ViewModifier {
    @State private var isAnimating = false
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(AppColors.charcoal)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(AppColors.richGold, lineWidth: 1)
                    )
                    .shadow(color: AppColors.richGold.opacity(0.3), radius: isAnimating ? 15 : 10, x: 0, y: 0)
            )
            .onAppear {
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                    isAnimating = true
                }
            }
    }
}

// MARK: - Helper Extensions
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension View {
    func glassCard() -> some View {
        modifier(GlassCard())
    }
    
    func premiumCard() -> some View {
        modifier(PremiumCard())
    }
}
