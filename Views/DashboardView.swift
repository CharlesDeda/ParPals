//
//  DashboardView.swift
//  ParPals
//
//  Created by Zachary Terault on 10/7/24.
//

import SwiftUI

/**
 Step 4
 We have been logged in
 We have a profile
 We are ready to do some more work
 */
struct DashboardView: View {
    @ObservedObject var vm: ViewModel
    
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
                    Text("ParPals")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Image(.golfer)
                        .resizable()
                        .frame(width: 225, height: 225, alignment: .center)
                        .aspectRatio(contentMode: .fit)
                        .padding()
                    Spacer()
                        .frame(height: 30)
                    
                    NavigationLink(destination: JoinPartyView(vm: vm)) {
                        Text("Join")
                            .foregroundColor(.accentColor)
                            .frame(width: 275, height: 30)
                    }
                    .padding()
                    .fontWeight(.bold)
                    .font(.largeTitle)
                    .background(Color(hex: vm.green)).cornerRadius(10)
                    .foregroundColor(.white)
                    Spacer()
                        .frame(height: 20)
                    
                    NavigationLink(destination: SelectCourseView(vm: vm)) {
                        Text("Create")
                            .frame(width: 275, height: 30)
                    }
                    .padding()
                    .fontWeight(.bold)
                    .font(.largeTitle)
                    .background(Color(hex: vm.green)).cornerRadius(10)
                    .foregroundColor(.white)
                    
                }
                .toolbar {
                    NavigationLink {
                        ProfileView(vm: vm)
                    }label: {
                        Image(systemName: "person.circle")
                            .font(.largeTitle)
                    }
                }
                .navigationBarBackButtonHidden(true)
            }
        }
        .tint(.white)
    }
    
}

#Preview {
    DashboardView(vm: ViewModel())
}
