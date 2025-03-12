//
//  SettingsView.swift
//  ParPals
//
//  Created by Zachary Terault on 10/26/24.
//

import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    ///View model for managing app state and data
    @ObservedObject var vm: ViewModel
    ///State variables for confirming the logout process
    @State private var isLoggingOut = false
    @State private var showingConfirmation = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: vm.green)
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(Color(hex: vm.white))
                    .opacity(0.8)
                VStack {
                    Button(action: {
                        ///Checks to see if user is logged in before they can log out
                        if vm.isLoggedIn == false{
                            ///Shows error alert if user isn't logged in
                            vm.showingAlert = true
                        } else {
                            ///Else it shows confirmation message to user
                            showingConfirmation = true
                        }
                    }){
                        Text("Log Out")
                            .frame(width: 200, height: 50)
                    }
                    .alert(isPresented: $vm.showingAlert){
                        Alert(title: Text("Logout Error"), message: Text("User is not logged in"), dismissButton: .default(Text("OK")))
                    }
                    .confirmationDialog("Logout Confirmation", isPresented: $showingConfirmation) {
                        ///Lets user confirm if they want to logout
                        Button("Yes") {
                            ///Logs out user
                            vm.logout()
                            isLoggingOut = true
                        }
                        Button("No") {}
                    } message: {
                        Text("Are you sure you want to log out?")
                    }
                    .padding()
                    .fontWeight(.bold)
                    .font(.largeTitle)
                    .background(Color(hex: vm.green)).cornerRadius(10)
                    .foregroundColor(.white)
                }
            }
            .navigationDestination(isPresented: $isLoggingOut) {
                LoginView(vm: vm)
            }
        }
        .tint(.white)
    }
    
}

#Preview {
    SettingsView(vm: ViewModel())
}
