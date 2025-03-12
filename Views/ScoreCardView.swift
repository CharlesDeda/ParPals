//
//  SwiftUIView.swift
//  ParPals
//
//  Created by Justin Richardson on 10/15/24.
//
import SwiftUI

struct ScoreCardView: View {
    @ObservedObject var vm: ViewModel
    @State private var showSubmitConfirmation = false
    @State var navigateToDashboard = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: vm.green)
                    .ignoresSafeArea()
                VStack {
                    HeaderView(vm: vm)
                    ScoreListView(vm: vm)
                    HStack {
                        Button("Back"){
                            guard let selectedID = vm.selectedHoleID, selectedID > 0 else {
                                vm.selectedHoleID = 1  // Default to 0 if invalid
                                return
                            }
                            vm.selectedHoleID = selectedID - 1
                        }
                        .padding()
                        
                        Button("Next") {
                            guard let selectedID = vm.selectedHoleID, selectedID < vm.holes.count else {
                                vm.selectedHoleID = vm.holes.count - 1  // Default to last hole if invalid
                                return
                            }
                            vm.selectedHoleID = selectedID + 1
                        }
                    }
                    
                }
            }
        }
        .navigationDestination(isPresented: $navigateToDashboard) {
            DashboardView(vm: vm)
        }
    }
}
    
// Displaying player and course information at the top
struct HeaderView: View {
    @ObservedObject var vm: ViewModel
    
    var body: some View {
        HStack {
            let stdate = vm.scorecard?.date ?? "Date"
            let scDate = String(stdate.prefix(10))
            Text(vm.party?.players.first?.username ?? "Player")
                .font(.subheadline)
                .padding()
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(vm.scorecard?.courseName ?? "Course")
                .font(.title3)
                .fontWeight(.medium)
                .lineLimit(1)
                .frame(maxWidth: 200, alignment: .center)
                .padding(.horizontal)
            Text(scDate)
                .font(.subheadline)
                .padding()
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
    }
}
// gets the list of scores and the corresponding holes
struct ScoreListView: View {
    @ObservedObject var vm: ViewModel
    
    var body: some View {
        List {
            // Safely unwrapping holes from the scorecard
            if let holes = vm.scorecard?.holes {
                ForEach(vm.scorecard?.holes.indices ?? vm.playerScorecard1.holes.indices, id: \.self) { index in
                    HoleRowView(vm: vm, index: index)
                }
            } else {
                Text("No holes found")
            }
        }
        .onTapGesture {
            // Dismiss keyboard when tapping outside of a text field
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
// displays individual hole information
struct HoleRowView: View {
    @ObservedObject var vm: ViewModel
    var index: Int = 0
    @State private var tempScore: String = ""
    
    var body: some View {
        let hole = vm.scorecard?.holes[index]
        // creating instance of hole
        VStack(alignment: .leading) {
            HStack {
                Text("Hole \(index + 1)")
                    .font(.headline)
                    .frame(width: 60)
                Spacer()
                Text("Par \(hole?.par ?? 0)")
                    .font(.headline)
                    .frame(width: 60)
                Spacer()
                if vm.selectedHoleID == (index + 1) && !vm.isSubmitted{
                    TextField("", text: $tempScore)
                        .font(.headline)
                        .keyboardType(.numberPad)
                        .frame(width: 60, alignment: .center)
                        .multilineTextAlignment(.center)
                        .onChange(of: tempScore) { newScore in
                            // Update the score in the view model if valid
                            if let score = Int(newScore) {
                                vm.updateScore(for: index, with: score)
                                vm.updateAnnotation(for: index + 1, score: score)
                            }
                        }
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                }
                            }
                        }
                }

                else {
                    Text("\(hole?.score ?? 0)")
                        .font(.headline)
                        .frame(width: 60, alignment: .center)
                        .onTapGesture {
                            vm.selectedHoleID = index
                            tempScore = "\(hole?.score ?? 0)"
                        }
                }
            }
        }
        .background(vm.selectedHoleID == index + 1 ? Color(hex: vm.green).opacity(0.3) : Color.clear)
    }
}

#Preview {
    ScoreCardView(vm: ViewModel())
}
