//
//  uploadEngine.swift
//  ParPals
//
//  Created by Hayden Romick on 10/3/24.
//

import SwiftUI
import Foundation
import FirebaseCore
import FirebaseDatabase

func uploadScorecard(scorecard: Scorecard) {
    ref = Database.database().reference()
    //Grab the correct path
    
    ref = ref.child("scorecards")
    
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

func createProfile(age: Int, playerID: String, username: String, playsFrom: String){
    //playerID is a firebase generated id
    //username is selected name
    ref = Database.database().reference()
    
    ref = ref.child("players")
    
    let newRef = ref.childByAutoId()
    
    let player = [
        "age": age,
        "playerID": playerID,
        "username": username,
        "playsFrom": playsFrom
    ] as [String : Any]
    
    ref.queryOrdered(byChild: "playerID").queryEqual(toValue: playerID).observeSingleEvent(of: .value) { snapshot in
        if snapshot.exists() {
            print("Error: Profile with this ID already exists. Try Signing in.")
        } else {
            newRef.setValue(player) { (error, ref) in
                if let error = error {
                            print("Error uploading player: \(error.localizedDescription)")
                        } else {
                            print("Player successfully uploaded!")
                        }
            }
        }
    }
}




