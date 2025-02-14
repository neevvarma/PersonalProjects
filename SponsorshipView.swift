import SwiftUI
import PDFKit
import UIKit

struct SponsorshipView: View {
    @State private var showingPDFViewer = false
    
    var body: some View {
        ZStack {
            // Background gradient matching app theme
            LinearGradient(gradient: Gradient(colors: [Color.maroon, Color.black]),
                          startPoint: .top,
                          endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    // Header
                    Text("Interested in being an\nAwaazein Sponsor?")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.gold)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                    
                    // Introduction
                    SponsorContentSection(content: "Awaazein is a prestigious national South Asian A Cappella competition that has already gained extensive popularity with students, not only at UT Dallas but all over the nation. South Asian A Cappella teams from all over the nation participate in Awaazein hoping for a chance to win the coveted award and advance to the finals. This event will combine efforts from countless South Asian organizations all over UT Dallas.")
                    
                    SponsorContentSection(content: "It is our hope that you would be interested in supporting our mission and helping us reach out to the Asian community in Dallas by abetting us with monetary funds or in-kind donations.")
                    
                    // Benefits section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Why Sponsor Us?")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.gold)
                        
                        SponsorContentSection(content: "By sponsoring a portion of our competition, you will not only help us, but also yourself! In our sponsorship packet you will find a list of advertising promotions that you will receive for different levels of sponsorship.")
                        
                        SponsorContentSection(content: "Advertising with us will help you reach an untapped target audience: Asian college students all over the nation. Because of our access to thousands of college-aged adults, it is highly beneficial for companies like yours to reach out to them and tell them about your business!")
                    }
                    .padding(.vertical, 10)
                    
                    // Impressions section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Reach & Impact")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.gold)
                        
                        SponsorContentSection(content: "Our expected audience for this event is anywhere from 600-1000 people. This means our entrant-level sponsors might receive:")
                        
                        VStack(alignment: .leading, spacing: 10) {
                            SponsorBulletPoint(text: "Space to display a banner (600-1000 impressions)")
                            SponsorBulletPoint(text: "Name announced twice (1200-2000 impressions)")
                            SponsorBulletPoint(text: "Name in event fliers (1800-3000 impressions)")
                        }
                        .padding(.leading)
                        
                        SponsorContentSection(content: "Furthermore, with our extensive online advertising on social media sites and planned live streaming of the show to colleges across the nation, our competition will reach crowds far exceeding the numbers above – nearly 10,000 impressions.")
                    }
                    .padding(.vertical, 10)
                    
                    // Contact section
                    VStack(alignment: .center, spacing: 20) {
                        Text("Get In Touch")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.gold)
                            .frame(maxWidth: .infinity)
                        
                        SponsorContentSection(content: "Your help will be greatly valued by our Awaazein 2025 team. Please help us in reaching out to the desi community through our music and pursuing our mission to spread the arts and culture throughout UT Dallas and the nation.")
                        
                        // Sponsorship Packet Button
                        Button(action: { showingPDFViewer = true }) {
                            HStack {
                                Image(systemName: "doc.fill")
                                Text("View Sponsorship Packet")
                            }
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 25)
                            .padding(.vertical, 12)
                            .background(Color.gold)
                            .cornerRadius(25)
                        }
                        .shadow(color: .gold.opacity(0.3), radius: 10, x: 0, y: 5)
                        
                        // Email Button
                        Link(destination: URL(string: "mailto:AwaazeinExec@gmail.com")!) {
                            HStack {
                                Image(systemName: "envelope.fill")
                                Text("AwaazeinExec@gmail.com")
                            }
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 25)
                            .padding(.vertical, 12)
                            .background(Color.black.opacity(0.7))
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.gold, lineWidth: 2)
                            )
                            .cornerRadius(25)
                        }
                        .shadow(color: .gold.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.vertical, 20)
                }
                .padding()
            }
        }
        .sheet(isPresented: $showingPDFViewer) {
            SponsorPDFViewerSheet(pdfName: "sponsorship_packet_2025")
        }
    }
}

// Helper view for content sections
struct SponsorContentSection: View {
    let content: String
    
    var body: some View {
        Text(content)
            .font(.system(size: 16))
            .foregroundColor(.white)
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(Color.black.opacity(0.3))
            .cornerRadius(10)
    }
}

// Helper view for bullet points
struct SponsorBulletPoint: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text("•")
                .foregroundColor(.gold)
            Text(text)
                .foregroundColor(.white)
        }
    }
}

// Preview
struct SponsorshipView_Previews: PreviewProvider {
    static var previews: some View {
        SponsorshipView()
    }
}
