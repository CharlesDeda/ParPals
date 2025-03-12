//
//  searchEngine.swift
//  ParPals
//
//  Created by Hayden Romick on 10/3/24.
//
import SwiftUI
import Foundation
import FirebaseCore
import FirebaseDatabase

class ProfileManager {
    
    static let shared = ProfileManager()
    
    init() {
    }
    
    func getPlayerProfile(user_id: String, completion: @escaping (Player?) -> Void) {
            let ref = Database.database().reference().child("players")
            //Retrieval Process -> C++ Array Dictionary -> Dictionary -> Struct
            // Can be bypassed by JSON destruction but can't do it with this individual struct
            ref.queryOrdered(byChild: "playerID").queryEqual(toValue: user_id)
                .observeSingleEvent(of: .value, with: { snapshot in

                    if let snapshotArray = snapshot.value as? [Any],
                       let playerData = snapshotArray.first as? [String:Any] {
                        let playerID = playerData["playerID"] as? String ?? ""
                        let username = playerData["username"] as? String ?? ""
                        let playsfrom = playerData["playsFrom"] as? String ?? ""
                        let user_age = playerData["age"] as? Int ?? 0
                        let user_handicap = playerData["handicap"] as? Int ?? 0
                        self.fetchScorecards(by: user_id) { scorecards in
                            let player = Player(
                                id: playerID,
                                handicap: user_handicap,
                                username: username,
                                playsFrom: playsfrom,
                                age: user_age,
                                previousScores: scorecards
                            )
                            completion(player)
                        }
                    } else {
                        completion(.none)
                    }
                    
                }) { error in
                    print("Error fetching player profile: \(error.localizedDescription)")
                    completion(.none)
                }
    }
    
    func fetchScorecards(by user_id: String, completion: @escaping ([Scorecard]) -> Void) {
        let ref = Database.database().reference().child("scorecards")
        
        ref.queryOrdered(byChild: "playerID")
            .queryEqual(toValue: user_id)
            .observeSingleEvent(of: .value, with: { snapshot in

                guard let value = snapshot.value as? [String: Any] else {
                    print("No scorecards found for this player.")
                    completion([])
                    return
                }
                
                var scorecards: [Scorecard] = []
                
                //TODO: Refer to fetchCourses (we probably dont need to serialize the json and then decode that when we have a scorecard already)
                for (_, scorecardData) in value {
                    if let scorecardDict = scorecardData as? [String: Any],
                       let jsonData = try? JSONSerialization.data(withJSONObject: scorecardDict),
                       let scorecard = try? JSONDecoder().decode(Scorecard.self, from: jsonData) {
                        scorecards.append(scorecard)
                    }
                }
                
                completion(scorecards)
                
            }) { error in
                print("Error fetching scorecards: \(error.localizedDescription)")
                completion([])
            }
    }
    
    func uploadScorecard(scorecard: Scorecard) {
        let ref = Database.database().reference()
            .child("scorecards")
        
        let scorecardData = scorecard.toDictionary()
        
        let newRef = ref.childByAutoId()
        
        newRef.setValue(scorecardData) { (error, ref) in
            if let error = error {
                print("Error uploading scorecard: \(error.localizedDescription)")
            } else {
                print("Scorecard successfully uploaded!")
            }
        }
    }
    
    //TODO: Modernize this, how can we use this function to create a profile?
    func createProfile(age: Int, playerID: String, username: String, playsFrom: String, handicap: Int, completion: @escaping (Player) -> Void) {
                //playerID is a firebase generated id
                //username is selected name
                let ref = Database.database().reference().child("players")
        
                let newRef = ref.childByAutoId()
        
                let player = [
                    "age": age,
                    "handicap":0,
                    "playerID": playerID,
                    "username": username,
                    "playsFrom": playsFrom
                ] as [String : Any]
        
                ref.queryOrdered(byChild: "playerID").queryEqual(toValue: playerID).observeSingleEvent(of: .value) { snapshot in
                    if snapshot.exists() {
                        print("Error: Profile with this ID already exists. Try Signing in.")
                    } else {
                        Task{
                            do{
                                try await newRef.setValue(player) //Created
                                let player = self.createProfileHelper(age: age, playerID: playerID, username: username, playsFrom: playsFrom, handicap: handicap)
                                completion(player)
                            } catch {
                                print("Error in createProfile Function couldnt set Value.")
                            }
                        }
                    }
                }
//        if created {
//            return createProfileHelper(age: age, playerID: playerID, username: username, playsFrom: playsFrom, handicap: handicap)
//        } else {
//            print("Didnt return player")
//            return .none
//        }
    }

func createProfileHelper(age: Int, playerID: String, username: String, playsFrom: String, handicap: Int) -> Player{
    /*
     var id: String
     var handicap:Int
     let username: String
     let playsFrom: String
     var age: Int
     let previousScores: [Scorecard] //Change this to [Scorecard]
     */
    return Player(id:playerID, handicap: handicap, username: username, playsFrom: playsFrom, age: age, previousScores:[])
}
    
    func updateProfile(field: String, user: Player, newValue: String){
        
        let id = user.id
        
        //Fields are age, handicap, playsFrom, or username
        
        let ref = Database.database().reference().child("players")
        
        ref.queryOrdered(byChild: "playerID").queryEqual(toValue: id).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                for child in (snapshot.children.allObjects as? [DataSnapshot])! {
                    // Get key of original
                    let route = child.key
                    Task{
                        do{
                            try await ref.child("\(route)/\(field)").setValue(newValue)
                            print("Profile updated at: \(field)")
                        } catch{
                            print("Profile couldn't be updated at: \(field)")
                        }
                    }
                }
            } else {
                print("Snapshot doesn't exist")
            }
            // Check if it exists
            
            //If it exists continue
        })
        
    }
}
