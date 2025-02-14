import SwiftUI

// Color extensions
extension Color {
    static let maroon = Color(red: 0.5, green: 0.0, blue: 0.0)
    static let gold = Color(red: 1.0, green: 0.84, blue: 0.0)
}

// Shimmering effect for text and elements
struct ShimmeringEffect: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .clear, location: 0),
                            .init(color: .white.opacity(0.5), location: 0.3),
                            .init(color: .white.opacity(0.5), location: 0.7),
                            .init(color: .clear, location: 1)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 2)
                    .offset(x: -geometry.size.width)
                    .offset(x: phase * geometry.size.width)
                    .blendMode(.overlay)
                }
            )
            .onAppear {
                withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

// Casino-style card effect
struct CasinoCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.black.opacity(0.7))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gold, lineWidth: 2)
                            .shadow(color: Color.gold.opacity(0.5), radius: 5)
                    )
            )
            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

// Glowing text effect
struct GlowingText: ViewModifier {
    let color: Color
    let radius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .shadow(color: color, radius: radius / 2)
            .shadow(color: color, radius: radius / 2)
            .shadow(color: color, radius: radius / 2)
    }
}

// Background pattern
struct CasinoBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.maroon.opacity(0.8), Color.black]),
                startPoint: .top,
                endPoint: .bottom
            )
            
            GeometryReader { geometry in
                Path { path in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    let spacing: CGFloat = 40
                    
                    for x in stride(from: 0, through: width, by: spacing) {
                        for y in stride(from: 0, through: height, by: spacing) {
                            let rect = CGRect(x: x, y: y, width: 2, height: 2)
                            path.addEllipse(in: rect)
                        }
                    }
                }
                .fill(Color.gold.opacity(0.3))
            }
        }
        .ignoresSafeArea()
    }
}

// Animated button press
struct PressableButton: ViewModifier {
    @State private var isPressed = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
            .onTapGesture {
                isPressed = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isPressed = false
                }
            }
    }
}

// Convenience extensions
extension View {
    func shimmer() -> some View {
        modifier(ShimmeringEffect())
    }
    
    func casinoCard() -> some View {
        modifier(CasinoCardStyle())
    }
    
    func glowingText(color: Color = Color.gold, radius: CGFloat = 5) -> some View {
        modifier(GlowingText(color: color, radius: radius))
    }
    
    func pressableButton() -> some View {
        modifier(PressableButton())
    }
}

// Custom navigation bar appearance
struct CasinoNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(
                Color.black.opacity(0.8),
                for: .navigationBar
            )
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

// Custom tab bar style
class CasinoTabBarAppearance {
    static func configure() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        
        let goldColor = UIColor(red: 212/255, green: 175/255, blue: 55/255, alpha: 1.0)
        
        // Normal state
        appearance.stackedLayoutAppearance.normal.iconColor = .lightGray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 12, weight: .medium)
        ]
        
        // Selected state
        appearance.stackedLayoutAppearance.selected.iconColor = goldColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: goldColor,
            .font: UIFont.systemFont(ofSize: 12, weight: .semibold)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
