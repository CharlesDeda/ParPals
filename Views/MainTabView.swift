import SwiftUI

struct MainTabView: View {
    @ObservedObject var vm: ViewModel
    
    var body: some View {
        VStack {
            if vm.selectedTab == .course {
                PlayCourseView(vm: vm)
                    .background(Color(hex: vm.white))
                    .ignoresSafeArea()
            } else if vm.selectedTab == .scorecard {
                ScoreCardView(vm: vm)
            } else if vm.selectedTab == .individualHole {
                individualHoleView(vm: vm)
            }
            
            HStack {
                Spacer()
                Button(action: {
                    vm.selectedTab = .course
                }) {
                    VStack {
                        Image(systemName: "map")
                        Text("Course")
                    }
                }
                .foregroundColor(vm.selectedTab == .course ? Color(hex: vm.green) : .gray)
                
                Spacer()
                
                Button(action: {
                    vm.selectedTab = .individualHole
                }) {
                    VStack{
                        // Put Image here
                        Image(systemName: "mappin")
                        Text("Hole View")
                    }
                }.foregroundColor(vm.selectedTab == .individualHole ? Color(hex: vm.green) : .gray)
                
                Spacer()
                Button(action: {
                    vm.selectedTab = .scorecard
                }) {
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("Scorecard")
                    }
                }
                .foregroundColor(vm.selectedTab == .scorecard ? Color(hex: vm.green) : .gray)
                
                Spacer()
            }
            .padding()
        }.onChange(of: vm.selectedTab) { newValue in
            if newValue == .course {
                vm.navigateToScorecard = false
            }
        }.onAppear{
            let currentHoleID = vm.selectedHoleID ?? 1
            vm.greenCoordinate = vm.teeBoxes[currentHoleID - 1].coordinate
            vm.holeCoordinate = vm.holes[currentHoleID - 1].coordinate
            vm.populateIndividualHoleView(greenCoordinate: vm.greenCoordinate, holeCoordinate: vm.holeCoordinate)
            vm.updateCameraPosition()
            
        }
        .background(Color(hex: vm.white))
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MainTabView(vm: ViewModel())
}
