//
//  testView.swift
//  ParPals
//
//  Created by Hayden Romick on 10/21/24.
//

import SwiftUI
import FirebaseDatabase

struct TestView: View {
    @State private var buttonText = "Press Me"
    @ObservedObject var vm: ViewModel
    
    var scorecardID:String = "B0C10E8E-F3BD-44EC-905A-37D259FF91BB"
    var currentHole:Int = 3
    var currentScore:Int = 4
    @State private var partyID: String = ""
    func observer(partyID: String) -> Void{
        print("Loading Observers... \n")
        let ref = Database.database().reference().child("parties").child(partyID).child("players")
        //Child Added Observer
        ref.observe(.childAdded, with: {
            (snapshot) in
            /*
             Snapshot on adding player outputs as following, [playerID]: [scorecardID],[username] so as a singular partyPlayer struct
             Snap (Vu2G3XCfs1e6zLJ5XMedQaKosQa2) {
                 scorecardID = B3B;
                 username = Test;
             }
             */
            //Parse to a PartyPlayer
            let data = snapshot.value as? [String:Any]
            //Optional(["scorecardID": B3B, "username": Test])
            Task {
                let player = await PartyPlayer.create(username: data!["username"] as! String, scorecardID: data!["scorecardID"] as! String)
                if vm.party!.players.contains(player){
                    print("Player already exists in party")
                } else{
                    print("Adding player to party: \(player.username)")
                    vm.party!.players.append(player)
                    print("Current party: \(vm.party)")
                }
                print(vm.party)
            }
            
        })
            //Child removed Observer
            ref.observe(.childRemoved, with: {
                (snapshot) in
                
                let data = snapshot.value as? [String:Any]
                let username = data?["username"] as? String
                let scorecardID = data?["scorecardID"] as? String
                Task {
                    let player = await PartyPlayer.create(username: username!, scorecardID: scorecardID!)
                    if vm.party!.players.contains(player){
                        vm.party!.players = vm.party!.players.filter { $0 != player}
                        print("Removed user from party")
                        print("Updated Party: \(vm.party)")
                    }
                    else{
                        print("Player not in partyPlayer list")
                    }
                }
            })
    }
    
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
                            print(vm.party!.players[index].scorecard)
                        } else {
                        print("Player not found in the party")
                    }
                        
                    }
                })
            }
        }
    }

    
    var body: some View {
        var scorecardID = "B0C10E8E-F3BD-44EC-905A-37D259FF91BB"
        VStack {
            Text(buttonText)
                .padding()
            Button(action: {
                Task{
                    PartyManager.shared.createParty(player: vm.profile!, courseName: "Castle Bay") { ID in vm.currentPartyID = ID
                        
                    }
                }
            }){
                Text("Create Party")
            }
            Button(action: {
                PartyManager.shared.joinParty(partyID: vm.currentPartyID, profile: vm.profile!) { party in
                    vm.party = party
                }
            }){
                Text("Join party")
            }
            Button(action: {
                var partyID = "1zKFYi"
                // Action to test something
                buttonText = "call Observer"
                observer(partyID: partyID)
            }) {
                Text("call Observer")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            Button(action: {
                
                // Action to test something
                buttonText = "call scorecard Observer"
                PartyManager.shared.leaveParty(player: vm.profile!, party: vm.party!)
            }) {
                Text("Delete Party")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
}

#Preview {
    TestView(vm: {
        let rv = ViewModel()
        
        // login with an account that has prfile
        rv.username = "testguy420@gmail.com"
        rv.password = "thisisatest"
        rv.login()
        print(rv.errorMessage)
        return rv
    }())
}
