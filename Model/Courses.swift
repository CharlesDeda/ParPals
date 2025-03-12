//
//  Courses.swift
//  ParPals
//
//  Created by Hayden Romick on 9/30/24.
//


//1. Golf Course [Array]
//    1. holes: Array[Dict] from 0-18
//        1. handicap: int
//        2. hole: int
//        3. par: int
//        4. yardages Array[Dict]
//    2. courseID: String
//    3. courseName: string
//    4. handicap: int

import Foundation

struct Yardages:Codable, Equatable {
    let gold: Int
    let blue:Int
    let white:Int
    let green:Int
    let red:Int
}

struct Hole:Codable, Equatable {
    let hole: Int
    let par: Int
    let handicap: Int
    let yardages: Yardages
}

struct Course: Codable, Equatable {
    var courseName: String
    var holes: [Hole]
    var handicap: Int
    var location: Location
}

struct Location: Codable, Equatable {
    var address: String
    var city: String
    var country: String
    var state: String
    var zipCode: String
    var coordinates: Coordinates
}

struct Coordinates: Codable, Equatable{
    var latitude: Double
    var longitude: Double
}



//let castleBayCourse = Course(courseName: "Castle Bay", holes: dummyHoles, courseID: "C1", handicap: 76)

//let dummyCourseCollection = CourseCollection(golfCourses: [castleBayCourse])

//func printCourseInfo() {
//    
//    for course in dummyCourseCollection.golfCourses {
//        print("Course Name: \(course.courseName)")
//        print("Course ID: \(course.courseID)")
//        print("Handicap: \(course.handicap)")
//        print("Holes:")
//        
//        for hole in course.holes {
//            print("  Hole \(hole.hole):")
//            print("    Par: \(hole.par)")
//            print("    Handicap: \(hole.handicap)")
//            print("    Yardages:")
//            print("      Gold: \(hole.yardages.gold)")
//            print("      Blue: \(hole.yardages.blue)")
//            print("      White: \(hole.yardages.white)")
//            print("      Green: \(hole.yardages.green)")
//            print("      Red: \(hole.yardages.red)")
//        }
//        print() // Print a blank line for better readability between courses
//    }
//}
//func printCourseInfo() {
//    let jsonString = """
//    {
//        "golfCourses": [
//          {
//            "courseID": "C1",
//            "courseName": "Castle Bay",
//            "handicap": 76,
//            "Holes": [
//                {
//                  "hole": 1,
//                  "par": 4,
//                  "handicap": 17,
//                  "yardages": {
//                    "gold": 356,
//                    "blue": 342,
//                    "white": 320,
//                    "green": 310,
//                    "red": 258
//                  }
//                },
//                {
//                  "hole": 2,
//                  "par": 4,
//                  "handicap": 11,
//                  "yardages": {
//                    "gold": 353,
//                    "blue": 301,
//                    "white": 283,
//                    "green": 270,
//                    "red": 253
//                  }
//                },
//                {
//                  "hole": 3,
//                  "par": 3,
//                  "handicap": 7,
//                  "yardages": {
//                    "gold": 166,
//                    "blue": 157,
//                    "white": 133,
//                    "green": 128,
//                    "red": 108
//                  }
//                },
//                {
//                  "hole": 4,
//                  "par": 5,
//                  "handicap": 1,
//                  "yardages": {
//                    "gold": 589,
//                    "blue": 563,
//                    "white": 549,
//                    "green": 509,
//                    "red": 391
//                  }
//                },
//                {
//                  "hole": 5,
//                  "par": 3,
//                  "handicap": 9,
//                  "yardages": {
//                    "gold": 174,
//                    "blue": 161,
//                    "white": 152,
//                    "green": 141,
//                    "red": 126
//                  }
//                },
//                {
//                  "hole": 6,
//                  "par": 4,
//                  "handicap": 15,
//                  "yardages": {
//                    "gold": 347,
//                    "blue": 328,
//                    "white": 320,
//                    "green": 308,
//                    "red": 278
//                  }
//                },
//                {
//                  "hole": 7,
//                  "par": 4,
//                  "handicap": 3,
//                  "yardages": {
//                    "gold": 432,
//                    "blue": 408,
//                    "white": 381,
//                    "green": 315,
//                    "red": 287
//                  }
//                },
//                {
//                  "hole": 8,
//                  "par": 5,
//                  "handicap": 5,
//                  "yardages": {
//                    "gold": 566,
//                    "blue": 536,
//                    "white": 483,
//                    "green": 462,
//                    "red": 406
//                  }
//                },
//                {
//                  "hole": 9,
//                  "par": 4,
//                  "handicap": 13,
//                  "yardages": {
//                    "gold": 356,
//                    "blue": 345,
//                    "white": 323,
//                    "green": 323,
//                    "red": 241
//                  }
//                },
//                {
//                  "hole": 10,
//                  "par": 4,
//                  "handicap": 18,
//                  "yardages": {
//                    "gold": 387,
//                    "blue": 361,
//                    "white": 342,
//                    "green": 324,
//                    "red": 312
//                  }
//                },
//                {
//                  "hole": 11,
//                  "par": 5,
//                  "handicap": 14,
//                  "yardages": {
//                    "gold": 530,
//                    "blue": 508,
//                    "white": 467,
//                    "green": 455,
//                    "red": 390
//                  }
//                },
//                {
//                  "hole": 12,
//                  "par": 3,
//                  "handicap": 8,
//                  "yardages": {
//                    "gold": 181,
//                    "blue": 157,
//                    "white": 139,
//                    "green": 124,
//                    "red": 103
//                  }
//                },
//                {
//                  "hole": 13,
//                  "par": 4,
//                  "handicap": 10,
//                  "yardages": {
//                    "gold": 398,
//                    "blue": 375,
//                    "white": 351,
//                    "green": 334,
//                    "red": 278
//                  }
//                },
//                {
//                  "hole": 14,
//                  "par": 4,
//                  "handicap": 6,
//                  "yardages": {
//                    "gold": 567,
//                    "blue": 555,
//                    "white": 437,
//                    "green": 430,
//                    "red": 404
//                  }
//                },
//                {
//                  "hole": 15,
//                  "par": 4,
//                  "handicap": 12,
//                  "yardages": {
//                    "gold": 390,
//                    "blue": 377,
//                    "white": 339,
//                    "green": 323,
//                    "red": 293
//                  }
//                },
//                {
//                  "hole": 16,
//                  "par": 3,
//                  "handicap": 2,
//                  "yardages": {
//                    "gold": 199,
//                    "blue": 179,
//                    "white": 168,
//                    "green": 160,
//                    "red": 129
//                  }
//                },
//                {
//                  "hole": 17,
//                  "par": 4,
//                  "handicap": 16,
//                  "yardages": {
//                    "gold": 441,
//                    "blue": 418,
//                    "white": 370,
//                    "green": 335,
//                    "red": 327
//                  }
//                },
//                {
//                  "hole": 18,
//                  "par": 4,
//                  "handicap": 4,
//                  "yardages": {
//                    "gold": 266,
//                    "blue": 257,
//                    "white": 226,
//                    "green": 215,
//                    "red": 192
//                  }
//                }
//              ]
//      
//          }
//        ]
//    }
//    """
//    
//    if let jsonData = jsonString.data(using:  .utf8){
//        do {
//            let CourseCollection = try JSONDecoder().decode(CourseCollection.self, from: jsonData)
//            print(CourseCollection)
//            
//        } catch {
//            print("Failed to decode JSON: \(error)")
//        }
//    }
//}


