import SwiftUI
import FirebaseDatabaseInternal
import MapKit

struct PlayCourseView: View {
    @ObservedObject var vm: ViewModel
    @State private var showAlert = false
    @State private var navigateToDashboard = false
    //let players = ["Hayden", "Nick", "Ethan", "Zach"]
    private func getPlayerNames() {
        players = vm.party?.players.reduce(into: [:]) { result, player in
                let totalScore = player.scorecard?.holes.reduce(0) { $0 + ($1.score ?? 0) } ?? 0
                result[player.username] = totalScore
            } ?? [:]
    }
    @State var players:[String: Int] = [:]
    
    func scorecardObserver(party: Party){
        
        print("Loading scorecard observer")
        for player in party.players{
            CourseManager.shared.getScorecardPath(scorecardID: player.scorecardID) {
                url in
                let newRef = Database.database().reference(fromURL: url)
                newRef.observe(.childChanged, with: {
                    (snapshot) in
                    print("\(player.username) scorecard has updated")
                    Task {
                        let newScorecard = await ProfileManager.shared.getSingleScorecard(by: player.scorecardID)
                        if let index = vm.party!.players.firstIndex(where: { $0.username == player.username }) {
                            vm.party!.players[index].scorecard = newScorecard
                            getPlayerNames()
                        } else {
                            print("Player not found in the party")
                        }
                        
                    }
                })
                vm.scorecardObserverCalled = true
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    Section {
                        HStack(alignment: .firstTextBaseline) {
                            Text(vm.profile?.username ?? "")
                                .font(.largeTitle)
                                .bold()
                            Text(Date().dayOfTheWeekDescription)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .padding()
                    
                    Section("Current Course") {
                        CourseMapView(vm: vm)
                            .frame(height: 400)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    
                    Section("Scores") {
                        ForEach(players.keys.sorted(), id: \.self){ username in
                            HStack {
                                Text(username)
                                    .font(.body)
                                    .padding(.vertical, 5)
                                Text("\(players[username] ?? 0)")
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .background(Color.clear)

                }
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
        .background(Color(hex: vm.white))
        .scrollContentBackground(.hidden)
        .navigationTitle("Course Map")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Finish") {
                    showAlert = true
                }
                .foregroundStyle(.blue)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Are you sure you want to leave?"),
                primaryButton: .destructive(Text("Leave")) {
//                    print("\(vm.scorecard)")
                    vm.profile!.previousScores.append(vm.scorecard!)
                    vm.selectedTab = .course
                    navigateToDashboard = true
                    vm.partyJoined = false
                    vm.scorecard = nil
//                    print("Updated scorecard \n \(vm.scorecard)")
                    vm.scoredHoles = []
                    vm.selectedHoleID = 1
                },
                secondaryButton: .cancel()
            )
        }
        
        .navigationDestination(isPresented: $navigateToDashboard) {
            DashboardView(vm: vm)
        }.onAppear {
            getPlayerNames()
            if !vm.scorecardSwitch {
                vm.scorecard = PartyManager.shared.scorecard
            }
            if !vm.scorecardObserverCalled {
                scorecardObserver(party: vm.party!)
            }
        }
        .onChange(of: vm.party?.players) { _ in
                getPlayerNames()
            }
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.plain)
        .padding(.horizontal)
    }
}

extension Date {
    var dayOfTheWeekDescription: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: self)
    }
}

#Preview {
    PlayCourseView(vm: ViewModel())
}
