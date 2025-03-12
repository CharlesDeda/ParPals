//
//  CourseManager.swift
//  ParPals
//
//  Created by Nick Deda on 10/16/24.
//

import SwiftUI
import Foundation
import FirebaseCore
import FirebaseDatabase

/**
 A manager or a client
 This singleton is responsible for fetching Course data
 */
final class CourseManager {
    
    /// Creates shared source of Coursemanager
    static let shared = CourseManager()
    
    /// what courses have been fetched
    var fetchedCourses: [Course] = []
    
    init() {}
    
    /**
     This function does everything that is needed
     
     - Parameters:
     - name: String, partial or full name of the course.
     */
    func getCourse(name: String) async -> Course? {
        ///Helper function for getting courses
        ///
        ///Parameter:
        /// - Name: partial string of a course that is in database potentially
        
        await withCheckedContinuation { continuation in
            getSingleCourse(by: name) { course in
                continuation.resume(returning: course)
            }
        }
    }
    
    private func getCoursePath(byName name: String, completion: @escaping (String) -> Void){
        
        let ref = Database.database().reference().child("golfCourses")
        
        ref.queryOrdered(byChild: "courseName").queryEqual(toValue: name).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                for child in (snapshot.children.allObjects as? [DataSnapshot])! {
                    let route = child.key
                    let routeRef = ref.child("\(route)")
                    //Grab Hole
                    completion(routeRef.url)
                }
            }
        })
    }

    private func getSingleCourse(by name: String, completion: @escaping (Course?) -> Void) {
        /*
         Make sure name is the full name taken by Course['Name']
         This works
         */
        self.getCoursePath(byName: name) { url in
            let newRef = Database.database().reference(fromURL: url)
            
            newRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    // Decode the snapshot into a Course struct
                    if let courseData = snapshot.value as? [String: Any] {
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: courseData)
                            let decoder = JSONDecoder()
                            let course = try decoder.decode(Course.self, from: jsonData)
                            completion(course)
                        } catch {
                            print("Error decoding course data: \(error)")
                            completion(nil)
                        }
                    } else {
                        print("Snapshot data is not in expected format")
                        completion(nil)
                    }
                } else {
                    print("Course not found at \(url)")
                    completion(nil)
                }
            })
        }
    }

            
    private func fetchCourses(by name: String) async -> [Course]  {
        await withCheckedContinuation { continuation in
            let ref = Database.database().reference()
            
            ref.child("golfCourses")
                .queryOrdered(byChild: "courseName")
                .queryStarting(atValue: name)
                .queryLimited(toFirst: 10)
                .observeSingleEvent(of: .value, with: { snapshot in
                    guard let golfCourseDict = snapshot.value as? [[String: Any]] else {
                        print(snapshot)
                        print("Format not accepted")
                        return
                    }
                    do {
                        //JSONSerialization converts the NSsnapshot Datatype to JSON to be decoded into the structures
                        let jsonData = try JSONSerialization.data(withJSONObject: golfCourseDict)
                        let decoder = JSONDecoder()
                        let golfCourses = try decoder.decode([Course].self, from: jsonData)
                        continuation.resume(returning: golfCourses)
                    } catch {
                        print("Error Encountered at fetchCourses")
                    }
                    
                }) { error in
                    print("Error fetching data: \(error.localizedDescription)")
                }
        }
    }
    
    private func createHoles(player: Player, course: Course) -> [playerHoles] {
        
        let playingFrom = player.playsFrom
        let holes = course.holes
        return transformHoles()
        
        func transformHoles() -> [playerHoles]{
            return holes.map { hole in
                var selectedYardage: Int = 0
                switch playingFrom.lowercased() {
                case "gold":
                    selectedYardage = hole.yardages.gold
                case "blue":
                    selectedYardage = hole.yardages.blue
                case "white":
                    selectedYardage = hole.yardages.white
                case "green":
                    selectedYardage = hole.yardages.green
                case "red":
                    selectedYardage = hole.yardages.red
                default:
                    selectedYardage = hole.yardages.white
                }
                return playerHoles(score: 0, par: hole.par, yardages: selectedYardage)
            }
        }
    }
    
    func createScorecard(player: Player, course: Course) -> Scorecard {
        let id = UUID().uuidString
        let holes = createHoles(player: player, course: course)
        let currentDate = Date()
        
        let dateFormatter = ISO8601DateFormatter()
        
        let dateString = dateFormatter.string(from: currentDate)
        return Scorecard(id: id, date:dateString , courseName: course.courseName, playerID: player.id, playingFrom: player.playsFrom, totalScore: 0, holes: holes)
    }
    
    func updateScorecard(scorecardID: String, holeNum: Int, score: Int){
        /*
         Purpose is to update the scorecard for a player at each hole increment. This will push the change to the server.
         holeNum is at max 17. so Pass it 0 for 1 and 1 for 2 etc.
         */
        if holeNum > 17 { return }
        let scorecardID = scorecardID
        
        let ref = Database.database().reference().child("scorecards")
        
        ref.queryOrdered(byChild: "id").queryEqual(toValue: scorecardID).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            if snapshot.exists() {
                for child in (snapshot.children.allObjects as? [DataSnapshot])! {
                    let route = child.key
                    let routeRef = ref.child("\(route)")
                    let holesRef = routeRef.child("holes")
                    //Grab Hole
                    let totalScoreRef = routeRef.child("totalScore")
                    Task{
                        do{
                            let s_totalscore = try await totalScoreRef.getData()
                            var totalScore = s_totalscore.value as? Int ?? 0
                            print("Previous total score: \(totalScore)")
                            totalScore = totalScore + score
                            print("Current total score: \(totalScoreRef)")
                            let holeNumRef = holesRef.child("\(holeNum)")
                            //Grab current score
                            try await holeNumRef.child("score").setValue(score)
                            try await totalScoreRef.setValue(totalScore)
                            print("Scorecard updated")
                        }
                    }
                    
                    //                    do {
                    //                        let scoreSnapshot = try await routeRef.getData()
                    //                        let updater = snapshot.value as? Int ?? 0
                    //                    } catch {
                    //
                    //                    }
                }
            }
            else{
                print("Scorecard doesn't Exist")
            }
        })
        
    }
    
    func getScorecardPath(scorecardID: String, completion: @escaping (String) -> Void){
        let ref = Database.database().reference().child("scorecards")
        
        ref.queryOrdered(byChild: "id").queryEqual(toValue: scorecardID).observeSingleEvent(of: .value, with: { (snapshot) in
            print("Getting scorecard Path")
            if snapshot.exists() {
                for child in (snapshot.children.allObjects as? [DataSnapshot])! {
                    let route = child.key
                    let routeRef = ref.child("\(route)")
                    //Grab Hole
                    completion(routeRef.url)
                }
            }
        })
    }
    
    
    
    
    func printScoreCard(scorecard: Scorecard){
        print("ID:\(scorecard.id)")
        print("Player ID:\(scorecard.playerID)")
        print("Date made: \(scorecard.date)")
        print("Plays from:\(scorecard.playingFrom)")
        print("Course Name:\(scorecard.courseName)")
        print("Total Score:\(scorecard.totalScore)")
        
        var result: String
        
        result = "Holes Information:\n"
        
        for (index,hole) in scorecard.holes.enumerated() {
            result += "Hole \(index+1): Par \(hole.par), Distance: \(hole.yardages) yards, Score: \(hole.score)\n"
        }
        print(result)
    }
    
}
