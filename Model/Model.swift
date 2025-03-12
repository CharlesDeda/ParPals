import Foundation
import Swift
import SwiftUI
import Firebase


/// Player has a profile, id is firebase ID
struct Player: Equatable, Codable {
    var id: String
    var handicap:Int
    let username: String
    let playsFrom: String
    var age: Int
    var previousScores: [Scorecard] //Change this to [Scorecard]
}

struct playerHoles: Equatable, Codable, Hashable {
    var score: Int
    let par: Int
    let yardages: Int
    
    func toDictionary() -> [String: Any] {
        return [
            "score": score,
            "par": par,
            "yardages": yardages
        ]
    }
}
// Scorecard struct for each round, scorecards save after every round and are created with new rounds.

struct Scorecard: Equatable, Codable, Hashable, Identifiable {
    let id: String
    let date: String
    let courseName: String
    let playerID: String
    let playingFrom: String
    var totalScore: Int
    var holes: [playerHoles]
    
    func toDictionary() -> [String: Any] {
        // Date formatting to a string for Firebase
        //               let dateString = dateFormatter.string(from: date)
        
        // Convert the holes array to an array of dictionaries
        let holesDict = holes.map { $0.toDictionary() }
        
        return [
            "id": id,
            "date": date,
            "courseName": courseName,
            "playerID": playerID,
            "playingFrom": playingFrom,
            "totalScore": totalScore,
            "holes": holesDict
        ]
    }
}

struct Party: Codable, Equatable {
    var partyID: String
    var hostID: String
    var courseName: String
    var players: [PartyPlayer]
}
//let players = Party.players
//for username, socercardID in players { }

struct PartyPlayer: Codable, Equatable, Hashable {
    //Don't need userID because scorecardID is tagged to userID
    var username: String
    var scorecardID: String
    var scorecard: Scorecard?

    
    private init(username: String, scorecardID: String, scorecard: Scorecard? = nil) {
        self.username = username
        self.scorecardID = scorecardID
        self.scorecard = scorecard
    }
    
    static func create(username: String, scorecardID: String) async -> PartyPlayer {
        var player = PartyPlayer(username: username, scorecardID: scorecardID)
        player.scorecard = await ProfileManager.shared.getSingleScorecard(by: scorecardID)
        return player
    }
}

enum CourseName {
    case castleBay
    case wilmingtonMunicipal
    case ironclad
    case beauRivage
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// User ID will be selected from log in using firebase UUID, everything else not related to authentication uses apple UUID
//array of Players
//let players = [
//    Player(id: "Kqx5It9GeVV5ZXEiRgJZZHMXUq32", username: "DEDA", playsfrom: "red", previousScores: ["hole": 4, "par": 4, "handicap": 17, "yardage": 320, "score": 3]),
//    Player(id: UUID().uuidString, username: "Layman", playsfrom: "blue", previousScores: ["hole": 5, "par": 3, "handicap": 11, "yardage": 230, "score": 2])
//]
