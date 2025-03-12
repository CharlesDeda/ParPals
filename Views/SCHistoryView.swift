//
//  SCHistory.swift
//  ParPals
//
//  Created by Zachary Terault on 11/21/24.
//

import SwiftUI

//@Published var scorecardIndex: Int = 0
/// Implements and displays all the sub structs for the scorecard history view
struct SCHistoryView: View {
    @ObservedObject var vm: ViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: vm.green)
                    .ignoresSafeArea()
                VStack {
                    SCHeaderView(vm: vm)
                    SCScoreListView(vm: vm)
                }
            }
        }
    }
}

/// Displaying player and course information at the top
struct SCHeaderView: View {
    @ObservedObject var vm: ViewModel

    var body: some View {
        HStack {
            let sortedScores = vm.profile!.previousScores.sorted(by: { $0.date > $1.date })
            let strdate = sortedScores[vm.scorecardIndex].date
            let scdate = String(strdate.prefix(10))
            Text(vm.profile!.username)
                .font(.headline)
                .padding()
            Text((sortedScores[vm.scorecardIndex].courseName))
                .font(.headline)
                .padding()
            Text(scdate)
                .font(.headline)
                .padding()
        }
    }
}
/// Gets the list of scores and the corresponding holes
struct SCScoreListView: View {
    @ObservedObject var vm: ViewModel
    
    var body: some View {
        List {
            let sortedScores = vm.profile!.previousScores.sorted(by: { $0.date > $1.date })
                ForEach(sortedScores[vm.scorecardIndex].holes.indices, id: \.self) { index in
                    SCHoleRowView(vm: vm, index: index)
                }
            }
        
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
/// Displays individual hole information
struct SCHoleRowView: View {
    ///Recieves the scorecard index and hole index for data finding
    @ObservedObject var vm: ViewModel
    var index = -1

    
    var body: some View {
        ///Creates instance of hole
        let sortedScores = vm.profile!.previousScores.sorted(by: { $0.date > $1.date })
        let hole = sortedScores[vm.scorecardIndex].holes[index]
        VStack(alignment: .leading) {
            HStack {
                Text("Hole \(index + 1)")
                    .font(.headline)
                    .frame(width: 60)
                Spacer()
                Text("Par \(String(describing: hole.par))")
                    .font(.headline)
                    .frame(width: 60)
                Spacer()
                Text("Score: \(String(describing: hole.score))")
                    .font(.headline)
                    .frame(width: 60, alignment: .center)
                    .onTapGesture {
                        vm.selectedHoleID = (index + 1)
                    }
            }
        }
    }
}

#Preview {
    SCHistoryView(vm: ViewModel())
}
