//
//  ParPalsApp.swift
//  ParPals
//
//  Created by Nick Deda on 9/17/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?=nil) -> Bool{
        FirebaseApp.configure()
        return true
    }
}

@main
struct ParPalsApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            
            ContentView()
        }
    }
}
