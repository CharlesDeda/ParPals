//
//  CreateProfileView.swift
//  ParPals
//
//  Created by Ethan Barber on 10/8/24.
//

import SwiftUI

struct CreateProfileView: View {
    
    // ViewModel for managing app state and data
    @ObservedObject var vm: ViewModel
    
    // State variables to hold inputs
    @State private var username: String = ""
    @State private var age: String = ""
    @State private var selectedPlaysFrom: String = "White"
    @State private var showError = false
    @State private var errorMessage = ""
    
    // Options for the picker
    let playsFromOptions = ["Red","Yellow","White","Blue","Black"]
    
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
                    
                    Text("Welcome to ParPals!")
                        .font(.headline)
                        .padding(.leading, 20)
                    
                    Text("Create Profile Below")
                        .font(.largeTitle)
                        .padding()
                    
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding()
                    
                    TextField("Age", text: $age)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Picker("Plays From", selection: $selectedPlaysFrom) {
                        ForEach(playsFromOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .padding()
                    .pickerStyle(MenuPickerStyle())
                    
                    Button(action: {
                        // Validatation of input
                        if let ageInt = Int(age),
                           !username.isEmpty && !age.isEmpty {
                            // create the profile and update the ViewModel
                            Task {
                                ProfileManager.shared.createProfile(
                                    age: ageInt,
                                    playerID: vm.firebaseID,
                                    username: username,
                                    playsFrom: selectedPlaysFrom
                                ) { profile in
                                    vm.profile = profile
                                    print(profile)
                                }
                                vm.canGoDashboard = true // Trigger navigation to dashboard
                            }
                            
                        } else {
                            // Show an error if validation fails
                            errorMessage = "Invalid input. Please check the information entered."
                            showError = true
                            
                        }
                    })
                    {
                        Text("Create Profile")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: vm.green))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding()
                    }
                }
                
                Spacer()
            }
            
            // Alert for any error messages
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
        
        // Navigation link to DashboardView once `canGoDashboard` becomes true
        .navigationDestination(isPresented: $vm.canGoDashboard) {
            DashboardView(vm: vm)
        }
    }
}

#Preview {
    CreateProfileView(vm: ViewModel())
}
