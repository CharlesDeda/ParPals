
import Foundation
import FirebaseAuth
import MapKit
import _MapKit_SwiftUI
///The ViewModel is our way to control state and bindings throughout the app, instantiated in the root  and passed to each view throughout the app, conforms to ObservableObject protocol (swift protocol for @Published and @ObservedObject)
@MainActor final class ViewModel: ObservableObject {
    // comment
    // MARK: Firebase LoginView
    @Published var username = UserDefaults.standard.string(forKey: "username") ?? ""
    @Published var password = UserDefaults.standard.string(forKey: "password") ?? ""
    @Published var confirmPassword: String = ""
    @Published var showPassword: Bool = false
    @Published var showConfirmPassword: Bool = false
    @Published var showingAlert = false;
    @Published var errorMessage: String?
    @Published var isLoggedIn: Bool = false
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var email: String = ""
    @Published var canGoDashboard = false
    @Published var isCreated: Bool = false
    @Published var isSignedUp: Bool = false
    @Published var firebaseID: String = ""
    @Published var currentPartyID: String = ""
    @Published var selectedHoleID: Int? = 1
    @Published var selectedTab: Tab = .course
    @Published var partyCreated: Bool = false
    @Published var navigateToScorecard = false
    @Published var hasLeft: Bool = false
    @Published var party: Party? {
        
        didSet{
            DispatchQueue.main.async {
                self.partyJoined = (self.party != .none)
            }
        }
    }
    @Published var partyJoined:Bool = false
    @Published var profile: Player? {
        didSet {
            DispatchQueue.main.async {
                self.isCreated = (self.profile != .none)
            }
        }
    }
    
    /* Scorecard stuff */
    @Published var scorecard: Scorecard? {
        didSet {
            DispatchQueue.main.async {
                self.scorecardSwitch = (self.scorecard != .none)
            }
        }
    }
    @Published var scorecardIndex: Int = 0
    @Published var scorecardSwitch: Bool = false

    
    // End scorecard stuff
    //Creating scorecard
    //1. Get Courses with name
    //2. Get individual course for array of courses
    //3. Pass Course to createScorecard
    @Published var selectedCourse: Course?
//    @Published var playerScorecard: Scorecard?
    
    @Published var scorecardObserverCalled:Bool = false
    
    var selectedCourseName: CourseName = .castleBay
    
    var holes: [DemoHole] {
        selectedCourseName.holes
    }
    
    var teeBoxes: [DemoHole]{
        selectedCourseName.teeBox
    }
    
    @Published var scoredHoles: Set<Int> = []
    
    func updateAnnotation(for holeID: Int, score: Int) {
            if let index = holes.firstIndex(where: { $0.id == holeID }) {
                scoredHoles.insert(holeID)
            }
        }

    
    var region: MapCameraPosition {
        selectedCourseName.region
    }
    
    var green = "4A7652"
    var white = "F5FAF7"
    var greenish = "D5E0D7"
    /**
     Update the selectedCourse
     */
    func selectCourse(courseName: CourseName) {
        selectedCourseName = courseName
        guard let profile = profile
        else { return }
        Task {
            guard let course = await CourseManager.shared.getCourse(name: courseName.courseName)
            else { return }
            
            self.selectedCourse = course
            // self.holes = courseName.holes
            print("holes: \(course.holes)")
        }
    }
    
    func nextHole(currentHoleID: Int){
        selectedHoleID! += 1
        self.greenCoordinate = teeBoxes[selectedHoleID ?? 1].coordinate
        self.holeCoordinate = holes[selectedHoleID ?? 1].coordinate
        populateIndividualHoleView(greenCoordinate: self.greenCoordinate, holeCoordinate: self.holeCoordinate)
    }
    
    func createScorecard(course: Course, player: Player) -> Scorecard{
        let scorecard = CourseManager.shared.createScorecard(player: player, course: course)
        //        CourseManager.shared.printScoreCard(scorecard: scorecard)
        return scorecard
    }
    
    ///takes a password string and makes sure its between 8-12, has a special character, and a number.
    func isPasswordValid(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[0-9])(?=.*[!@#$%^&*])(?=.*[a-zA-Z]).{8,12}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
    ///Signup takes two paramaters from the viewmodel and allows user to create account using firebase Auth package, used in signupview
    func signup(withEmail username: String, password: String) {
        guard isPasswordValid(password) else {
            self.errorMessage = "Password must be 8-12 characters long, include at least one number and one special character."
            return
        }
        
        isLoading = true
        Auth.auth().createUser(withEmail: username, password: password) { authResult, error in
            self.isLoading = false
            if let error = error {
                self.errorMessage = "Error: \(error.localizedDescription)"
            } else if authResult != nil {
                self.isSignedUp = true
                self.errorMessage = nil
                self.username = username
                self.password = ""
            }
        }
    }
    
    
    ///logs user and stores in firebase using Auth package, ties profile to firebase ID using ProfileManager to get a profile.
    func login() {
        isLoading = true
        errorMessage = nil
        
        Auth.auth().signIn(withEmail: username, password: password) { authResult, error in
            if let error = error {
                self.errorMessage = "Error: \(error.localizedDescription)"
                self.isLoading = false
            } else if authResult == nil {
                self.errorMessage = "Error: No authorization"
                self.isLoading = false
            } else {
                // Successfully logged in
                // spend one more second to fetch the existing profile if any
                // After successful sign in retrieve user information
                Task {
                    let user = Auth.auth().currentUser
                    if let user = user {
                        self.firebaseID = user.uid
                        print(self.firebaseID)
                        ProfileManager.shared.getPlayerProfile(user_id: self.firebaseID) { player in
                            self.profile = player
                            self.isLoggedIn = true
                            self.isLoading = false
                        }
                    } else {
                        self.isLoggedIn = true
                        self.isLoading = false
                    }
                }
            }
        }
    }
    /// logs user out using firebase Auth package
    func logout() {
        guard self.isLoggedIn else{
            print("Attempted log out. isLoggedIn: \(self.isLoggedIn)")
            return
        }
        do{
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.username = ""
                self.password = ""
                self.firebaseID = ""
                self.profile = nil
                print("Successfully signed out.")
                self.isLoggedIn = false
            }
        } catch{
            print("Error signing out: \(error)")
        }
    }
    ///resets password using firebase Auth package
    func resetPassword() {
        guard !email.isEmpty else {
            alertMessage = "Please enter your email."
            showAlert = true
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                case .userNotFound:
                    self.alertMessage = "If an account with this email exists, a password reset link has been sent."
                case .invalidEmail:
                    self.alertMessage = "The email address is not valid."
                default:
                    self.alertMessage = error.localizedDescription
                }
            } else {
                self.alertMessage = "If an account with this email exists, a password reset link has been sent."
            }
            self.showAlert = true
        }
    }
    
    // MARK: Firebase CreateProfileView
    
    // Mark: Firebase PlayCourseView
//    @Published var scoreInput: String = ""
//    
//    func submitScore() {
//        if let score = Int(scoreInput), score > 0 {
//            scoreInput = ""
//        }
//    }
    
    // MARK: Firebase PartyView
    //    @Published var PartyTest = Party(partyID: "", hostID: "P1", players: [
    //        PartyPlayer(username: "Player 1", scorecardID: ""),
    //        PartyPlayer(username: "Player 2", scorecardID: ""),
    //        PartyPlayer(username: "Player 3", scorecardID: ""),
    //        PartyPlayer(username: "Player 4", scorecardID: "")])
    
    @Published var playerScorecard1 = Scorecard(id: "ScorecardId", date: "Date", courseName: "CourseName", playerID: "PlayerId", playingFrom: "Whites", totalScore: 0, holes: [playerHoles(score: 0, par: 3, yardages: 0), playerHoles(score: 0, par: 3, yardages: 0), playerHoles(score: 0, par: 4, yardages: 0), playerHoles(score: 0, par: 4, yardages: 0), playerHoles(score: 0, par: 4, yardages: 0), playerHoles(score: 0, par: 4, yardages: 0), playerHoles(score: 0, par: 4, yardages: 0), playerHoles(score: 0, par: 5, yardages: 0), playerHoles(score: 0, par: 5, yardages: 0),playerHoles(score: 0, par: 3, yardages: 0), playerHoles(score: 0, par: 3, yardages: 0), playerHoles(score: 0, par: 4, yardages: 0), playerHoles(score: 0, par: 4, yardages: 0), playerHoles(score: 0, par: 4, yardages: 0), playerHoles(score: 0, par: 4, yardages: 0), playerHoles(score: 0, par: 4, yardages: 0), playerHoles(score: 0, par: 5, yardages: 0), playerHoles(score: 0, par: 5, yardages: 0)])
    

    func updateScore(for index: Int, with newScore: Int) -> Int {
        self.scorecard?.holes[index].score = newScore
        CourseManager.shared.updateScorecard(scorecardID: self.scorecard?.id ?? "", holeNum: index + 1, score: newScore)
        self.scorecard?.totalScore += newScore
        return newScore
    }
    
    
    func calcHandicap() -> String {
        
        guard let profile = profile else { return "0" }
        // check if any scores are 0 in the scorecard an excludes them
        let validScores = profile.previousScores.filter { scorecard in
                !scorecard.holes.contains { $0.score == 0 }
            }
        // get 20 most recent scores
        let recentScores = validScores.prefix(20)
        guard !recentScores.isEmpty else { return "0" }
        // sort scores lowest to highest then take the lowest 8
        
        let bestScores = recentScores.sorted { $0.totalScore < $1.totalScore }.prefix(8)
        // add all best scores up and get average
        let totalScore = bestScores.reduce(0) { $0 + $1.totalScore }
        let averageBestScores = totalScore / bestScores.count
        // make calculation relative to par
        let rawHandicap = (72 - averageBestScores)
        var playerHandicap: String
        if rawHandicap == 72 {
            playerHandicap = "0"
            ProfileManager.shared.updateProfile(field: "handicap", user: profile, newValue: playerHandicap)
            return playerHandicap
        }
        if rawHandicap > 0 {playerHandicap = "+" + String(rawHandicap)}
        else{ playerHandicap = String(rawHandicap) }
        ProfileManager.shared.updateProfile(field: "handicap", user: profile, newValue: playerHandicap)
        return playerHandicap
        
    }


    /// for MainTabView to switch between playcourseview and scorecardview
    enum Tab {
            case course
            case scorecard
            case individualHole
        }
    @Published var isSubmitted: Bool = false
    func submitScores() {
            isSubmitted = true
        }
    
    @Published var greenCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @Published var holeCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    @Published var yardage: Double = 0
    @Published var yardagefromPosition: Double = 0
    
    @Published var tappedPosition: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0){
        didSet {
            self.yardagefromPosition = self.distanceInYards(from: tappedPosition, to: holeCoordinate)
            midpointOne = midpointFinder(from: greenCoordinate, to: tappedPosition)
            midpointTwo = midpointFinder(from: tappedPosition, to: holeCoordinate)
        }
    }
//    private var debounceTimer: Timer?
//    func updateTappedPosition(newPosition: CLLocationCoordinate2D){
//        debounceTimer?.invalidate()
//        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) {[weak self] _ in guard let self = self else { return }
//            Task { @MainActor in
//            self.tappedPosition = newPosition}
//            
//        }
//    }
    
    @Published var cameraPosition: MapCameraPosition = .camera(
        MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), distance: 1000, heading: 0, pitch: 0)
    )

    @Published var annotationPos: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @Published var midpointOne:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @Published var midpointTwo:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
//    @State private var translation: CGSize = .zero
    
    func populateIndividualHoleView(greenCoordinate: CLLocationCoordinate2D, holeCoordinate: CLLocationCoordinate2D) {
        self.greenCoordinate = greenCoordinate
        self.holeCoordinate = holeCoordinate
        // Initial camera position
        let midpoint = CLLocationCoordinate2D(
            latitude: (greenCoordinate.latitude + holeCoordinate.latitude) / 2,
            longitude: (greenCoordinate.longitude + holeCoordinate.longitude) / 2
        )
        tappedPosition = midpoint
        annotationPos = midpoint
        midpointOne = midpointFinder(from: greenCoordinate, to: midpoint)
        midpointTwo = midpointFinder(from: midpoint, to: holeCoordinate)
        yardage = distanceInYards(from: greenCoordinate, to: holeCoordinate)
        let initialCamera = MapCamera(centerCoordinate: midpoint, distance: 600, heading: 0, pitch: 0)
        cameraPosition = .camera(initialCamera)
    }
    
    func calculateHeading(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) -> CLLocationDirection {
        
        //Haversine formula DO NOT TOUCH
        //DON'T DO IT
        let startLat = start.latitude * .pi / 180 // Convert to radians
        let startLon = start.longitude * .pi / 180
        let endLat = end.latitude * .pi / 180
        let endLon = end.longitude * .pi / 180
        
        let deltaLon = endLon - startLon
        
        let y = sin(deltaLon) * cos(endLat)
        let x = cos(startLat) * sin(endLat) - sin(startLat) * cos(endLat) * cos(deltaLon)
        let radiansHeading = atan2(y, x)
        
        // Convert from radians to degrees
        let degreesHeading = radiansHeading * 180 / .pi
        
        // Normalize to 0-360 degrees
        return (degreesHeading + 360).truncatingRemainder(dividingBy: 360)
    }
    
    func distanceInYards(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) -> Double {
        //Haversine Formula Pt.2 Don't touch
        
        let earthRadius = 6371000.0 // Earth's radius in meters
        
        // Convert latitude and longitude from degrees to radians
        let startLat = start.latitude * .pi / 180
        let startLon = start.longitude * .pi / 180
        let endLat = end.latitude * .pi / 180
        let endLon = end.longitude * .pi / 180
        
        // Calculate deltas
        let deltaLat = endLat - startLat
        let deltaLon = endLon - startLon
        
        // Haversine formula
        let a = sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(startLat) * cos(endLat) * sin(deltaLon / 2) * sin(deltaLon / 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        let distanceInMeters = earthRadius * c // Distance in meters
        
        // Convert meters to yards (1 meter = 1.09361 yards)
        let distanceInYards = distanceInMeters * 1.09361
        return distanceInYards
    }
    
    func midpointFinder(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let midpoint = CLLocationCoordinate2D(
            latitude: (from.latitude + to.latitude) / 2,
            longitude: (from.longitude + to.longitude) / 2
        )
        return midpoint
    }
    
    func updateCameraPosition() {
        let midpoint = CLLocationCoordinate2D(
            latitude: (greenCoordinate.latitude + holeCoordinate.latitude) / 2,
            longitude: (greenCoordinate.longitude + holeCoordinate.longitude) / 2
        )
        let heading = calculateHeading(from: greenCoordinate, to: holeCoordinate)
        let baseDistance = 175.0
        let multiplier = 3.25
        let distance:Double = max(baseDistance, multiplier * yardage)
        // Update camera position
        cameraPosition = .camera(
            MapCamera(
                centerCoordinate: midpoint,
                distance: distance, // Adjust distance as needed
                heading: heading,
                pitch: 0
            )
        )
    }
    
    }

