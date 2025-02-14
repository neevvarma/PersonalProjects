import SwiftUI

struct BoardMembersView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Base background with gradient
                LinearGradient(gradient: Gradient(colors: [AppColors.deepMaroon, Color.black]),
                          startPoint: .top,
                          endPoint: .bottom)
                    .ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Title Section
                        Text("Your Awaazein Board")
                            .font(.custom("Palatino-Bold", size: 36))
                            .foregroundColor(AppColors.richGold)
                            .shadow(color: AppColors.richGold.opacity(0.5), radius: 10)
                            .padding(.top, 20)
                            .padding(.bottom, 15)
                        
                        // Board Members Grid
                        LazyVGrid(columns: [GridItem(.flexible())], spacing: 25) {
                            ForEach(committees) { committee in
                                CommitteeCard(committee: committee)
                            }
                        }
                        .padding(.horizontal, 15)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct CommitteeCard: View {
    let committee: Committee
    @State private var isExpanded = false
    
    var body: some View {
        ZStack {
            // Background with depth and gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    AppColors.deepMaroon.opacity(0.7),
                    AppColors.nightBlack.opacity(0.9)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .cornerRadius(25)
            .shadow(color: AppColors.richGold.opacity(0.2), radius: 10, x: 0, y: 5)
            
            VStack(spacing: 0) {
                // Committee Image Section
                ZStack(alignment: .bottom) {
                    if let image = UIImage(named: committee.groupPhoto) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: isExpanded ? 250 : 200)
                            .background(AppColors.charcoal.opacity(0.3))
                    } else {
                        Rectangle()
                            .fill(AppColors.charcoal)
                            .frame(height: 200)
                            .overlay(
                                Image(systemName: "photo.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(AppColors.richGold)
                            )
                    }
                    
                    // Gradient overlay
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.black.opacity(0),
                            Color.black.opacity(0.7)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: isExpanded ? 250 : 200)
                    
                    // Committee Name
                    HStack {
                        Text(committee.name)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(AppColors.richGold)
                            .padding()
                        
                        Spacer()
                    }
                }
                .frame(height: isExpanded ? 250 : 200)
                
                // Expandable Members Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Team Members")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(AppColors.softGold)
                        .padding(.horizontal)
                    
                    Text(committee.members)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .lineLimit(isExpanded ? nil : 2)
                        .padding(.horizontal)
                }
                .padding(.vertical)
                .background(AppColors.charcoal.opacity(0.5))
            }
            .cornerRadius(25)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(AppColors.richGold.opacity(0.3), lineWidth: 1)
            )
            .onTapGesture {
                withAnimation(.spring()) {
                    isExpanded.toggle()
                }
            }
            .scaleEffect(isExpanded ? 1.05 : 1.0)
            .animation(.spring(), value: isExpanded)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

struct Committee: Identifiable {
    let id = UUID()
    let name: String
    let members: String
    let groupPhoto: String
}

// Sample committees data
let committees = [
    Committee(
        name: "Directors",
        members: "Vennela Jilla and Rhea Joshi",
        groupPhoto: "directors"
    ),
    Committee(
        name: "Assistant Directors",
        members: "Arya Biju and Neev Varma",
        groupPhoto: "asst_directors"
    ),
    Committee(
        name: "Advisor",
        members: "Shreya Ramashesha",
        groupPhoto: "advisor"
    ),
    Committee(
        name: "Tech Advisor",
        members: "Devanshi Verma",
        groupPhoto: "tech"
    ),
    Committee(
        name: "Logistics",
        members: "Hima Patel, Vignesh Bhaskar, and Varsha Janumpally",
        groupPhoto: "log"
    ),
    Committee(
        name: "Registration",
        members: "Anshu Nandhyala, Sindhuja Pathipati, Achal Hammandlu",
        groupPhoto: "reg"
    ),
    Committee(
        name: "Hospitality",
        members: "Shivani Kumar, Pallavi Tumuluru, Kakoli Bhardwaj",
        groupPhoto: "hosp"
    ),
    Committee(
        name: "Sponsorship",
        members: "Sumanasri Godavarti, Dhvani Sharma, Niharika Saravana",
        groupPhoto: "spon"
    ),
    Committee(
        name: "Finance",
        members: "Suraj Sidda, Sumedhasri Annabathini, Svetlana Gundabathula",
        groupPhoto: "fin"
    ),
    Committee(
        name: "Mixer",
        members: "Sivani Yalamanchili, Maria Williams, Khushi Aggarwal",
        groupPhoto: "mixer"
    ),
    Committee(
        name: "Marketing",
        members: "Saniya Hameed, Aari Madireddy, Omisha Cherala",
        groupPhoto: "mark"
    ),
    Committee(
        name: "Graphics",
        members: "Pranav Cherala, Aarushi Mohanty, Rishitha Namburi, Syam Konala",
        groupPhoto: "graph"
    ),
    Committee(
        name: "Liason Coordinators",
        members: "Sneha Maram, Rishul Aggarwal, Rithika Shenoy",
        groupPhoto: "lc"
    ),
    Committee(
        name: "AfterParty",
        members: "Khushi Patel, Shriya Thippana, Venuka Srivastava",
        groupPhoto: "ap"
    )
]

struct BoardMembersView_Previews: PreviewProvider {
    static var previews: some View {
        BoardMembersView()
    }
}
