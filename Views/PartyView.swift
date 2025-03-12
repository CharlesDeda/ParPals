//
//  PartyView.swift
//  ParPals
//
//  Created by Ethan Barber on 10/17/24.
//

import SwiftUI
import FirebaseDatabase
import SwiftfulLoadingIndicators

struct PartyView: View {
    @ObservedObject var vm: ViewModel
    @State private var partyID: String?
    @State var showAlert = false
    @State var navigateToDashboard = false
    
    private func observer(partyID: String) {
        print("Loading Observers... \n")
        let ref = Database.database().reference().child("parties").child(partyID).child("players")
        
        ref.observe(.childAdded) { snapshot in
            guard
                let data = snapshot.value as? [String: Any],
                let username = data["username"] as? String,
                let scorecardID = data["scorecardID"] as? String
            else { return }
            
            Task {
                let player = await PartyPlayer.create(username: username, scorecardID: scorecardID)
                if vm.party?.players.contains(player) == true {
                    print("Player already exists in party")
                } else {
                    print("Adding player to party: \(player.username)")
                    vm.party?.players.append(player)
                    print("Current party: \(String(describing: vm.party))")
                }
            }
        }
        
        ref.observe(.childRemoved) { snapshot in
            guard
                let data = snapshot.value as? [String: Any],
                let username = data["username"] as? String,
                let scorecardID = data["scorecardID"] as? String
            else { return }
            
            Task {
                let player = await PartyPlayer.create(username: username, scorecardID: scorecardID)
                if vm.party?.players.contains(player) == true {
                    vm.party?.players.removeAll { $0 == player }
                    vm.hasLeft = true
                    print("Removed user from party")
                    print("Updated Party: \(String(describing: vm.party))")
                } else {
                    print("Player not in partyPlayer list")
                    vm.hasLeft = false
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: vm.green)
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(Color(hex: vm.white))
                    .opacity(0.8)
                VStack {
                    headerView
                    
                    if let party = vm.party {
                        partyDetailsView(party: party)
                    } else {
                        LoadingIndicator(animation: .threeBalls, color: .black, size: .medium, speed: .normal)
                            .frame(alignment: .center)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Leave") {
                    showAlert = true
                }
                .foregroundStyle(.blue)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Are you sure you want to leave?"),
                primaryButton: .destructive(Text("Leave")) {
                    navigateToDashboard = true
                    vm.partyJoined = false
                },
                secondaryButton: .cancel()
            )
        }
        .navigationDestination(isPresented: $navigateToDashboard) {
            DashboardView(vm: vm)
        }
        .onAppear {
            Task {
                if vm.partyJoined == false, let player = vm.profile {
                    PartyManager.shared.createParty(player: player, courseName: vm.selectedCourseName.courseName) { newPartyID in
                        self.partyID = newPartyID
                        PartyManager.shared.fetchParty(partyID: newPartyID) { fetchedParty in
                            DispatchQueue.main.async{
                                vm.party = fetchedParty
                                if let partyID = self.partyID {
                                    observer(partyID: partyID)
                                }
                            }
                        }
                    }
                } else if let existingPartyID = vm.party?.partyID {
                    observer(partyID: existingPartyID)
                }
            }
        }
    }
    
    private var headerView: some View {
        VStack {
            Text(vm.selectedCourseName.courseName)
                .fontWeight(.bold)
                .font(.largeTitle)
            
            if let partyID = partyID {
                Text("Party Created! Party ID: \(partyID)")
                    .padding()
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    @ViewBuilder
    private func partyDetailsView(party: Party) -> some View {
        VStack(spacing: 20) {
            Text("Total Players: \(party.players.count)")
            ForEach(0..<(party.players.count + 1) / 2, id: \.self) { index in
                playerRowView(players: party.players, index: index)
            }
            
            NavigationLink(destination: MainTabView(vm: vm)) {
                Text("Start")
                    .frame(width: 250, height: 20)
                    .padding()
                    .background(Color(hex: vm.green))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
    
    @ViewBuilder
    private func playerRowView(players: [PartyPlayer], index: Int) -> some View {
        HStack(spacing: 20) {
            ForEach(0..<2) { column in
                let playerIndex = index * 2 + column
                if playerIndex < players.count {
                    Text(players[playerIndex].username)
                        .font(.system(size: 20, weight: .regular, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal,16)
    }
}

#Preview {
    PartyView(vm: ViewModel())
}
