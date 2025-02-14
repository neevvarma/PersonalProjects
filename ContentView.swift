import SwiftUI

struct ContentView: View {
    // Target date: March 8th, 2025 at 5:30 PM
    let targetDate: Date = {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        
        var components = DateComponents()
        components.year = 2025
        components.month = 3
        components.day = 8
        components.hour = 17
        components.minute = 30
        components.second = 0
        components.timeZone = TimeZone.current
        
        return calendar.date(from: components) ?? Date()
    }()
    
    @State private var daysRemaining: Int = 0
    @State private var hoursRemaining: Int = 0
    @State private var minutesRemaining: Int = 0
    @State private var secondsRemaining: Int = 0
    
    @State private var currentEvent: String = "Countdown to Awaazein"
    @State private var eventIndex: Int = 0
    @State private var isCountdownActive: Bool = true
    @State private var eventEndDate: Date = Date()
    @State private var isEventComplete: Bool = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let teams: [[TeamData]] = [
        [
            TeamData(name: "UW Awaaz", imageAsset: "team1_logo"),
            TeamData(name: "UMD Anokha", imageAsset: "team2_logo")
        ],
        [
            TeamData(name: "UT Hum", imageAsset: "team3_logo"),
            TeamData(name: "UCD Jhankaar", imageAsset: "team4_logo")
        ],
        [
            TeamData(name: "UCB Dil Se", imageAsset: "team5_logo"),
            TeamData(name: "UCLA Naya Zamaana", imageAsset: "team6_logo")
        ],
        [
            TeamData(name: "UH Dhun", imageAsset: "team7_logo"),
            TeamData(name: "TAMU Swaram", imageAsset: "team8_logo")
        ],
        [
            TeamData(name: "SLU Astha", imageAsset: "team9_logo"),
            TeamData(name: "OSU Dhadkan", imageAsset: "team10_logo")
        ]
    ]
    var body: some View {
            ZStack {
                // Layered background
                AppColors.maroonGradient
                    .ignoresSafeArea()
                
                // Animated background patterns
                GeometryReader { geometry in
                    ZStack {
                        // Circles pattern
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(AppColors.richGold.opacity(0.1))
                                .frame(width: geometry.size.width * 0.8)
                                .blur(radius: 50)
                                .offset(x: geometry.size.width * 0.2 * CGFloat(index),
                                        y: geometry.size.height * 0.1 * CGFloat(index))
                        }
                        
                        // Diamond pattern
                        ForEach(0..<5) { index in
                            Rectangle()
                                .fill(AppColors.richGold.opacity(0.05))
                                .frame(width: 100, height: 100)
                                .rotationEffect(.degrees(45))
                                .blur(radius: 20)
                                .offset(x: CGFloat(index) * 100 - 200,
                                        y: CGFloat(index) * 100 - 200)
                        }
                    }
                }
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Title Section
                        Text("AWAAZEIN")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(AppColors.richGold)
                            .padding(.top, 40)
                        
                        // Countdown Section
                        VStack(spacing: 20) {
                            Text(isEventComplete ? "Event Complete" : currentEvent)
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(AppColors.softGold)
                            
                            if !isEventComplete {
                                HStack(spacing: 15) {
                                    TimeCard(value: daysRemaining, unit: "DAYS")
                                    TimeCard(value: hoursRemaining, unit: "HOURS")
                                    TimeCard(value: minutesRemaining, unit: "MINS")
                                    TimeCard(value: secondsRemaining, unit: "SECS")
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding()
                        .glassCard()
                        .padding(.horizontal)
                        
                        // Ticket Purchase Section
                        VStack(spacing: 15) {
                            Text("Purchase Your Tickets")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(AppColors.richGold)
                            
                            Text("Join us for an unforgettable night of South Asian a cappella!")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            
                            Link(destination: URL(string: "https://docs.google.com/forms/d/e/1FAIpQLScEcoALnBK2lwWsu3zrDgW6wndiWBRSwXyctGtLKlWrFbwD-A/viewform?usp=header")!) {
                                HStack {
                                    Image(systemName: "ticket.fill")
                                    Text("Get Tickets")
                                }
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 15)
                                .background(AppColors.richGold)
                                .cornerRadius(25)
                            }
                        }
                        .padding()
                        .glassCard()
                        .padding(.horizontal)
                        
                        // Teams Section
                        VStack(spacing: 25) {
                            Text("Meet the Teams")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(AppColors.richGold)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 20) {
                                ForEach(teams.flatMap { $0 }, id: \.name) { team in
                                    TeamCard(team: team)
                                }
                            }
                        }
                        .padding()
                        .premiumCard()
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 50)
                }
            }
            .onReceive(timer) { _ in
                if isEventComplete {
                    return
                }
                if isCountdownActive {
                    updateTimeRemaining()
                } else {
                    updateEventTimer()
                }
            }
            .onAppear {
                updateTimeRemaining()
            }
        }

    func updateTimeRemaining() {
            let now = Date()
            
            guard targetDate > now else {
                isCountdownActive = false
                startEventSchedule()
                return
            }
            
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day, .hour, .minute, .second], from: now, to: targetDate)

            daysRemaining = components.day ?? 0
            hoursRemaining = components.hour ?? 0
            minutesRemaining = components.minute ?? 0
            secondsRemaining = components.second ?? 0

            if daysRemaining <= 0 && hoursRemaining <= 0 && minutesRemaining <= 0 && secondsRemaining <= 0 {
                isCountdownActive = false
                startEventSchedule()
            }
        }

        func startEventSchedule() {
            currentEvent = "Pre-Show"
            eventEndDate = Calendar.current.date(byAdding: .minute, value: 18, to: Date())!

            DispatchQueue.main.asyncAfter(deadline: .now() + (18 * 60)) {
                startTeamSchedule()
            }
        }

        func startTeamSchedule() {
            let teamNames = ["Team 1", "Team 2", "Team 3", "Team 4", "Team 5", "Team 6", "Team 7", "Team 8", "Team 9", "Team 10"]

            for (index, team) in teamNames.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index * (13 * 60))) {
                    if index == teamNames.count - 1 {
                        currentEvent = "Now Performing: \(team)"
                        eventEndDate = Calendar.current.date(byAdding: .minute, value: 13, to: Date())!
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + (13 * 60)) {
                            isEventComplete = true
                            currentEvent = "Event Complete"
                        }
                    } else {
                        currentEvent = "Now Performing: \(team)"
                        eventEndDate = Calendar.current.date(byAdding: .minute, value: 13, to: Date())!
                    }
                }
            }
        }

        func updateEventTimer() {
            if isEventComplete {
                return
            }
            
            let now = Date()
            let difference = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: now, to: eventEndDate)

            daysRemaining = difference.day ?? 0
            hoursRemaining = difference.hour ?? 0
            minutesRemaining = difference.minute ?? 0
            secondsRemaining = difference.second ?? 0

            if daysRemaining <= 0 && hoursRemaining <= 0 && minutesRemaining <= 0 && secondsRemaining <= 0 {
                eventEndDate = Calendar.current.date(byAdding: .minute, value: 13, to: Date())!
            }
        }
    }

struct TimeCard: View {
    let value: Int
    let unit: String
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 8) {
            Text("\(value)")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(AppColors.richGold)
            
            Text(unit)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(AppColors.softGold)
        }
        .frame(width: 70, height: 90)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(AppColors.richGold.opacity(0.5), lineWidth: 1)
                )
        )
        .scaleEffect(isAnimating ? 1 : 0.9)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                isAnimating = true
            }
        }
    }
}

struct TeamCard: View {
    let team: TeamData
    @State private var isHovered = false
    
    var body: some View {
        VStack {
            Image(team.imageAsset)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(AppColors.richGold, lineWidth: 2)
                )
                .shadow(color: AppColors.richGold.opacity(0.5), radius: isHovered ? 10 : 5)
            
            Text(team.name)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppColors.softGold)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .glassCard()
        .scaleEffect(isHovered ? 1.05 : 1)
        .animation(.spring(response: 0.3), value: isHovered)
        .onTapGesture {
            withAnimation {
                isHovered.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    isHovered = false
                }
            }
        }
    }
}

struct TeamData: Hashable {
    let name: String
    let imageAsset: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
