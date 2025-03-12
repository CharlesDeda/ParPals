import SwiftUI

struct ProfileView: View {
    /// View model for managing app state and data
    @ObservedObject var vm: ViewModel
    
    /// State variables to track which scorecard index to pass along
    @State private var scReady = false
    @State private var scIndex = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: vm.green)
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(Color(hex: vm.white))
                    .opacity(0.8)
                
                VStack(spacing: 20) {
                    Spacer()
                    ProfileHeader(vm: vm)
                    Form {
                        Section(header:
                            HStack {
                                Text("Scorecard History")
                                Spacer()
                                Text("Total Score")
                        }) {
                            // Check if the user has any scorecards from previous games
                            if let previousScores = vm.profile?.previousScores, !previousScores.isEmpty {
                                
                                let sortedScores = previousScores.sorted { $0.date > $1.date }
                                // Gotta love bubble sort
                                /// For each scorecard, display the course name and location
                                ForEach(sortedScores.indices, id: \.self) { index in
                                    if sortedScores[index].playerID == vm.profile?.id {
                                        Button {
                                            vm.scorecardIndex = index
                                            print(vm.scorecardIndex)
                                            scReady = true
                                        } label: {
                                            let strdate = sortedScores[index].date
                                            let scdate = String(strdate.prefix(10))
                                            HStack {
                                                Text("\(sortedScores[index].courseName): \(scdate)")
                                                // Meow meow meow meow meow meow meow meow meow meow meow meow meow meow meow meow meow
                                                Spacer()
                                                Text("\(sortedScores[index].totalScore)")
                                            }
                                        }
                                    }
                                }
                            } else {
                                Text("No Scorecards Found")
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
//                    .borderStyle(.roundedRectangle)
                    .foregroundStyle(.black)
                }
                
                .toolbar {
                    NavigationLink {
                        SettingsView(vm: vm)
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.largeTitle)
                            .imageScale(.small)
                    }
                }
                .navigationTitle("Profile")
            }
        }
//        .tint(.white)
        .navigationDestination(isPresented: $scReady) {
            /// Pass along view model and scorecard index to the next screen
            SCHistoryView(vm: vm)
        }
    }
}

struct ProfileHeader: View{
    @ObservedObject var vm: ViewModel
    
    var body: some View{
        HStack {
            Image(.golfball1)
                .resizable()
                .frame(width: 125, height: 125)
                .aspectRatio(contentMode: .fit)
                .padding()
            
            VStack(alignment: .leading) {
                /// Check if the user is logged in and display their information
                if let player = vm.profile {
                    Text("Username: \(player.username)")
                    Text("Age: \(player.age)")
                    Text("Handicap: \(vm.calcHandicap())")
                } else {
                    Text("Loading user Data")
                }
            }
            .padding(.leading, 20)
            Spacer()
        }
        .padding(.top)
    }
}

#Preview {
    ProfileView(vm: ViewModel())
}
