import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 1  // This will make it start on the middle tab (Main)
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        
        let goldColor = UIColor(red: 212/255, green: 175/255, blue: 55/255, alpha: 1.0)
        
        appearance.stackedLayoutAppearance.normal.iconColor = .lightGray
        appearance.stackedLayoutAppearance.selected.iconColor = goldColor
        
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.lightGray]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: goldColor]
        
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            LivestreamView()
                .tabItem {
                    Image(systemName: "play.tv")
                        .environment(\.colorScheme, .dark)
                    Text("Livestream")
                }
                .tag(0)
            
            ContentView()
                .tabItem {
                    Image(systemName: "music.note.list")
                        .environment(\.colorScheme, .dark)
                    Text("Main")
                }
                .tag(1)
            
            BoardMembersView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                        .environment(\.colorScheme, .dark)
                    Text("Awz Board")
                }
                .tag(2)
            
            SponsorshipView()
                .tabItem {
                    Image(systemName: "star.fill")
                        .environment(\.colorScheme, .dark)
                    Text("Sponsor")
                }
                .tag(3)
        }
        .accentColor(Color(UIColor(red: 212/255, green: 175/255, blue: 55/255, alpha: 1.0)))
    }
}
