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

/**
 A manager or a client
 This singleton is responsible for fetching Profile data
 */
class ProfileManager {
    
    /// Creates shared instance of the Profile Manager
    static let shared = ProfileManager()
    
    ///Initializes instance
    init() {
    }
    
    /**
     Retrieves a player's profile from firebase database based on User ID.
     
        Upon successful retrieval, it will map the retrieved data to a 'Player' struct.
     - Parameters:
        - user_id: Unique identifier for a player whose profile is being fetched
        - completion: completion handler that returns an optional player object. If player is found it will return the player object, if not nothing will return. queries are asynchronous so it will not return into data is complete making function psuedo-synchronous
     
     - Note: Function maps firebase datatype into a dictionary because json parsing is not available due to limitations with realtime database with firebase in individual data rather than list of data.
     
     - Warning: Assumes the user_id being passed is intentional and unique to user passing said ID.
     */
    
    func getPlayerProfile(user_id: String, completion: @escaping (Player?) -> Void){
        
        self.getProfilePath(ID: user_id) { url in
            if url == "DNE" {
                completion(nil)
                return
            }
            let newRef = Database.database().reference(fromURL: url)
            
            newRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    // Decode the snapshot into a Course struct
                    if let playerData = snapshot.value as? [String: Any] {
                        do {
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
                        } catch {
                            print("Error decoding course data: \(error)")
                            completion(nil)
                        }
                    } else {
                        print("Snapshot data is not in expected format")
                        completion(nil)
                    }
                } else {
                    print("Player not found at \(url)")
                    completion(nil)
                }
            })
        }
    }
    
    
    private func getProfilePath(ID: String, completion: @escaping (String) -> Void){
        
        let ref = Database.database().reference().child("players")
        
        ref.queryOrdered(byChild: "playerID").queryEqual(toValue: ID).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                for child in (snapshot.children.allObjects as? [DataSnapshot])! {
                    let route = child.key
                    let routeRef = ref.child("\(route)")
                    //Grab Hole
                    completion(routeRef.url)
                }
            }
            else {
                
                print("Path does not exist")
                completion("DNE")
            }
        })
    }
    /**
     Purpose of function is to retrieve scorecards, not an individual scorecard, but multiple on login. ONLY ON LOGIN
     
     - Parameters:
        - user_id: String unqiue identifier to player.
        - completion: Will return an array of scorecards if any scorecards are to be found, if none are to be found it will return nothing. This makes the function non-asynchronous despite the search being asynchronous
     
     - Warning: Only use this function when populating user profile, if you use it for party scorecard population it will result in errors.
     */
    func fetchScorecards(by user_id: String, completion: @escaping ([Scorecard]) -> Void) {
        let ref = Database.database().reference().child("scorecards")
        
        ref.queryOrdered(byChild: "playerID")
            .queryEqual(toValue: user_id)
            .queryLimited(toLast: 20)
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
    
    func getSingleScorecard(by ID: String) async -> Scorecard? {
        /*
         Make sure name is the full name taken by Course['Name']
         This works
         */
        return await withCheckedContinuation { continuation in
            let ref = Database.database().reference()
            let newRef = ref.child("scorecards")
            
            newRef.queryOrdered(byChild: "id").queryEqual(toValue: ID).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    guard let scorecards = snapshot.value as? [String:Any],
                          let firstScorecard = scorecards.first?.value as? [String:Any] else {
                        print("Format not accepted")
//                        print(snapshot)
                        continuation.resume(returning: nil)
                        return
                    }
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: firstScorecard)
                        let decoder = JSONDecoder()
                        let scorecard = try decoder.decode(Scorecard.self, from: jsonData)
                        continuation.resume(returning: scorecard)
                    } catch {
                        print("Couldn't parse JSON in function getSingleScorecard")
                        continuation.resume(returning: nil)
                    }
                } else {
                    print("Couldnt find scorecard with ID: \(ID)")
                    continuation.resume(returning: nil)

                }
            })}
        
    }
    /**
     Uploads scorecard into firebase realtime database
     
     - Parameters:
        - scorecard: passes a 'Scorecard' object
     
     */
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
    
    /**
     Creates a userprofile on successful user creation
     
     - Parameters:
        - age: Int
        - playerID: String - Unique ID
        - username: String nonunique
        - playsFrom: String, needs to conform with courseStruct tee names
        - handicap: Optional, always going to be 0 anyway
        - completion: On successful completion it will return a player, or it won't return anything
     
     - Warning: Only use on successful creation of player, all error/parsing needs to be done on the front end
     */
    func createProfile(age: Int, playerID: String, username: String, playsFrom: String, handicap: Int = 0, completion: @escaping (Player) -> Void) {
                //playerID is a firebase generated id
                //username is selected name
                let ref = Database.database().reference().child("players")
        
                let newRef = ref.childByAutoId()
        
                let player = [
                    "age": age,
                    "handicap": handicap,
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

private func createProfileHelper(age: Int, playerID: String, username: String, playsFrom: String, handicap: Int = 0) -> Player{
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
    
    /**
     Updates profile at field being updated
     
     - Parameters:
        - field: String, one of the potential fields, i.e. Username
        - user: passes a player object
        - newValue: the newValue to be passed,
     
     - Warning: All error parsing needs to be on the front end
     */
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
