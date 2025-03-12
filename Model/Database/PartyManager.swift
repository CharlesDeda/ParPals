//
//  partyEngine.swift
//  ParPals
//
//  Created by Hayden Romick on 10/15/24.
//

import SwiftUI
import Foundation
import FirebaseCore
import FirebaseDatabase

/**
 A manager or a client
 This singleton is responsible for fetching Party data
 */
class PartyManager {
    
    static let shared = PartyManager()
    
 //            self.partyCreated = (self.party != .none)

    init() {}
    
    /// scorecard
    @Published var scorecard: Scorecard? {
        didSet{
            loadingHelper()
        }
    }
    /// helps determine if the page needs to be moved on navigation
    @Published var party: Party? {
        didSet {
            loadingHelper()
        }
    }
    
    @Published var partyFinishedLoading:Bool = false
    
    
    /// helper for determining navigation
    private func loadingHelper(){
        self.partyFinishedLoading = (self.scorecard != nil && self.party != nil)
    }
    
    private func createPartyID(completion: @escaping (String) -> Void)  {
        let ref = Database.database().reference().child("parties")
        
        let partyID = generatePartyID()
        
        ref.child(partyID!).observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                self.createPartyID(completion: completion)
            } else {
                completion(partyID!)
            }
        }
    }
    
    private func generatePartyID() -> String? {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<6).map { _ in characters.randomElement()! })
    }
    
    /**
     Creates party, party will be a 6 character alphanumeric string regardless of when or where it is initialized. It uploads the ID into firebase.
     
     - Parameters:
        - player: player object passed, utilizes the ID of the player to create the host and corresponding partyID
        - courseName: String, case sensitive needs to be passed similarly to course.courseName
        - completion: On successful completion of the party creation it will allow the partyID (String) to be passed and utilized outside of PartyManager during object life
     
     - Note: Only use to create party, and will always need courseName
     
     - Warning: Invalid passing of courseName will make the function no longer work
     */
    func createParty(player: Player, courseName: String, completion: @escaping(String) -> Void) {
        let ref = Database.database().reference().child("parties")
        var pID = ""
        
        createPartyID {
            partyID in
            pID = partyID
            let partyData: [String: Any] = [
                "host": player.id,
                "partyID": pID,
                "courseName": courseName
            ]
            Task{
                do{
                    try await ref.child(pID).setValue(partyData)
                    completion(pID)
                    self.joinParty(partyID: pID, profile: player) { Party in
                            return
                    }
                } catch {
                    print("Faled to add party")
                }
            }
        }
        
        
    }
    
    private func addPlayerToParty(partyID: String, player: Player, scorecardID: String){
        //TODO: Change struct to include course
        let ref = Database.database().reference()
        
        let playersRef = ref.child("parties").child(partyID).child("players").child("\(player.id)")
        
        let playerData: [String:Any] = [
            "username": player.username,
            "scorecardID": scorecardID,
            "totalScore": 0
        ]
        Task {
            do{
                try await playersRef.setValue(playerData)
                print("Player added to party")
            } catch {
                print("Player couldn't be added to party")
            }
        }
    }
  
    /**
     Never use this
     When a user inputs the partyID, this function will go to the reference in firebase and populate all users and all their respective scorecards.
     
     - Parameters:
        - partyID: String, needs to be a string currently present in the parties path of firebase, otherwise it will not work
        - completion: Returns the created PartyStruct, with all users that are currently present and their respective scorecards that are populated with the courseName
     
     - Note:              |||| JSON Structure |||||
     HostID: String
     partyID: String
     players: [String: Any]
     
     - Warning: Only use when joining a party, never after and never before. Outdated because the function joinParty is a thing.
     */
    internal func fetchParty(partyID: String, completion: @escaping (Party) -> Void){
        /*
         This works, don't change
         Use this on first load of Party, use observeParty for changing of children. Wait for this to return then use observeParty
         */
        let ref = Database.database().reference()
        let partyData = ref.child("parties").child("\(partyID)")
        
        partyData.observeSingleEvent(of: .value, with: {
            snapshot  in
            guard let value = snapshot.value as? [String:Any] else{
                print("Couldn't cast snapshot format")
                return
            }
            
            /*
             |||| JSON Structure |||||
             HostID: String
             partyID: String
             players: [String: Any]
             */
            
            let hostID = value["host"] as? String ?? ""
            let partyID = value ["partyID"] as? String ?? ""
            let courseName = value["courseName"] as? String ?? ""
            
            var players: [PartyPlayer] = []
            
            Task{ // This may cause issues
                if let playersDict = value["players"] as? [String: [String:Any]] {
                    // _ is the playerID if needed later on
                    for (_, playerData) in playersDict {
                        if let username = playerData["username"] as? String,
                           let scorecardID = playerData["scorecardID"] as? String{
                            let player = await PartyPlayer.create(username: username, scorecardID: scorecardID)
                            players.append(player)
                        }
                    }
                }
                let party = Party(partyID: partyID, hostID: hostID, courseName: courseName, players: players )
                completion(party)
            }
            

        }) {
            error in
            print("Error fetching data: \(error.localizedDescription)")
        }
    }
    
    /**
     Never use this
     When a user inputs the partyID, this function will go to the reference in firebase and populate all users and all their respective scorecards.
     
     - Parameters:
        - partyID: String, needs to be a string currently present in the parties path of firebase, otherwise it will not work
        - profile: 'Player' object passed, used because it needs to create scorecard that uses player profile to determine distances.
        - completion: Returns the created PartyStruct, with all users that are currently present and their respective scorecards that are populated with the courseName
     
     - Note:              |||| JSON Structure |||||
     HostID: String
     partyID: String
     players: [String: Any]
     
     - Warning: Only use when joining a party, never after and never before. Outdated because the function joinParty is a thing.
     */
    func joinParty(partyID: String, profile: Player, completion: @escaping (Party) -> Void) {
        /*
         This will be the only callable function for joining a party
         Grab Party -> Party.courseName -> Course -> Create scorecard -> upload scorecard -> Send scorecard and name to party
         */
        fetchParty(partyID: partyID) { tempParty in
            Task {
                print("Fetching party ...")
                self.party = tempParty
                if let course = await CourseManager.shared.getCourse(name: tempParty.courseName) {
                    print("Fetching course ...")
                    print("Creating Scorecard...")
                    let scorecard = CourseManager.shared.createScorecard(player: profile, course: course)
                    print("Uploading scorecard...")
                    ProfileManager.shared.uploadScorecard(scorecard: scorecard)
                    let id = scorecard.id //Need to pass ID to ViewModel
                    self.scorecard = scorecard
                    print("Adding player with scorecard to party with ID: \(id) in party: \n \(tempParty)")
                    self.addPlayerToParty(partyID: partyID, player: profile, scorecardID: id)
                    completion(tempParty)
                    print("All operations successful")
                }
            }
        }
    }
    
    func leaveParty(player: Player, party: Party){
        let id = player.id
        let partyHost = party.hostID
        let partyID = party.partyID
        
        let ref = Database.database().reference().child("parties").child("\(partyID)")
        if id == partyHost {
            ref.removeValue()
        }
        else{
            return
        }
    }

}

