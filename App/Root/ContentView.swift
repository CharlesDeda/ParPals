//
//  ContentView.swift
//  ParPals
//
//  Created by Nick Deda on 9/17/24.
//

import SwiftUI

/**
 Step 1
 */
struct ContentView: View {
    @ObservedObject var vm = ViewModel()
    
    var body: some View {
        if vm.isLoggedIn {
            if vm.profile == .none {
                CreateProfileView(vm: vm)
            } else {
                DashboardView(vm: vm)
            }
        } else {
            LoginView(vm: vm)
        }
    }
}

#Preview {
    ContentView()
}
