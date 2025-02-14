import SwiftUI

struct TeamLogoView: View {
    let teamName: String
    let imageName: String
    
    var body: some View {
        VStack(alignment: .center) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100) // Fixed size for consistency
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.gold, lineWidth: 2)
                )
                .shadow(color: .gold.opacity(0.3), radius: 5)
            
            Text(teamName)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.gold)
                .padding(.top, 5)
                .multilineTextAlignment(.center) // Center align text
                .frame(width: 120) // Fixed width for text to ensure alignment
                .lineLimit(2) // Allow 2 lines for longer team names
        }
        .frame(width: 120, height: 150) // Fixed frame for entire view
    }
}

struct TeamLogoView_Previews: PreviewProvider {
    static var previews: some View {
        TeamLogoView(teamName: "Team Name", imageName: "team1_logo")
            .background(Color.black) // For preview visibility
    }
}
