//
//  SwiftUIView.swift
//  ParPals
//
//  Created by Justin Richardson on 10/27/24.
//

import SwiftUI

struct JoinPartyView: View {
    @ObservedObject var vm: ViewModel
    @State var partyCode: [String] = Array(repeating: "", count: 6)
    @FocusState private var focusedField: Int?
    @State private var oldValue = ""
    
    private var fullPartyCode: String {
        partyCode.joined()
    }
    
    var body: some View {
        ZStack {
            Color(hex: vm.green)
                .ignoresSafeArea()
            Circle()
                .scale(1.5)
                .foregroundColor(Color(hex: vm.white))
            VStack {
                Text("Enter Party Code:")
                    .font(.title)
                    .padding(.bottom, 20)
                HStack(spacing: 10) {
                    // 6 separate text fields
                    ForEach(0..<6, id: \.self) { index in
                        TextField("", text: $partyCode[index], onEditingChanged: {
                            editing in
                            if editing {
                                oldValue = partyCode[index]
                            }
                        })
                            .frame(width: 40, height: 50)
                            .multilineTextAlignment(.center)
                            .font(.title)
                            .keyboardType(.alphabet)
                            .autocapitalization(.none)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textContentType(.oneTimeCode) // Don't really know what this means
                            .keyboardType(.asciiCapable)
                            .focused($focusedField, equals: index)
                            .onChange(of: partyCode[index]) { newValue in
//                                let filtered = newValue.filter { $0.isNumber || $0.isLetter }
//                                partyCode[index] = String(filtered.prefix(1))
                                if partyCode[index].count > 1 {
                                    let currentValue = Array(partyCode[index])
                                    if !oldValue.isEmpty, currentValue[0] == Character(oldValue){
                                        partyCode[index] = String(partyCode[index].suffix(1))
                                    } else {
                                        partyCode[index] = String(partyCode[index].suffix(1))
                                    }
                                }
                                
                                if !newValue.isEmpty {
                                    if index == 5 {
                                        
                                    }
                                    else {
                                        focusedField = (focusedField ?? 0) + 1
                                    }
                                } else {
                                    focusedField = (focusedField ?? 0) - 1
                                }
                            }

//                            .onChange(of: partyCode) { _ in
//                                if partyCode[index] == "", index > 0 {
//                                        focusedField = index - 1
//                                    
//                                }
//                            }

                    }
                }
                .padding()
                
                // Button for submitting the code and joining the party
                Button(action: {
                    if fullPartyCode.count == 6 {
                        if let playerProfile = vm.profile {
                            // If the player has a profile, check for the party. PartyManager will check if the party exists
                            Task {
                                PartyManager.shared.joinParty(partyID: fullPartyCode, profile: playerProfile) { party in
                                    DispatchQueue.main.async {
                                        vm.party = party
                                        // Joins Party
                                    }
                                }
                            }
                        } else {
                            print("Profile not found.")
                        }
                    } else {
                        print("Please enter a valid 6-digit party code.")
                    }
                }) {
                    Text("Join Party")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: vm.green))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            .padding()
        }
        .navigationDestination(isPresented: $vm.partyJoined) {
            PartyView(vm: vm)
        }
        .onAppear {
            focusedField = 0
        }
    }
    
}





#Preview {
    JoinPartyView(vm: {
        let rv = ViewModel()
        
        // Log in with an account that has a profile
        rv.username = "testguy420@gmail.com"
        rv.password = "thisisatest"
        rv.login()
        print(rv.errorMessage)
        return rv
    }())
}
