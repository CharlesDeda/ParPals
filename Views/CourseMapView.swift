import SwiftUI
import MapKit

/// DemoHole is how we represent each pin on the map
struct DemoHole: Identifiable {
    let id: Int
    let coordinate: CLLocationCoordinate2D
}



struct CourseMapView: View {
    @ObservedObject var vm: ViewModel

    
    var body: some View {
        Map(position: .constant(vm.region)) {
            ForEach(vm.holes) { hole in
                Annotation("", coordinate: hole.coordinate) {
                    Button {
                        vm.selectedHoleID = hole.id
                        vm.navigateToScorecard = true
                        vm.selectedTab = .scorecard

                    } label: {
                        ZStack {
                            Circle()
                                .fill(vm.scoredHoles.contains(hole.id) ? Color(hex: vm.green) : Color(.systemGray6))
                                .frame(width: 30, height: 30)
                            Text(hole.id.description)
                                .fontWeight(.semibold)
                                .foregroundColor(vm.scoredHoles.contains(hole.id) ? Color(.systemGray6) : .accentColor)
                        }
                        .overlay(
                            Circle()
                                .strokeBorder(vm.selectedHoleID == hole.id ? Color(.systemGray6) : Color(.systemGray4))
                        )
                        .shadow(radius: 2, y: 2)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .background(Color.clear)
        .mapStyle(.imagery)
        .onAppear {
            if vm.selectedHoleID == nil {
                vm.selectedHoleID = vm.holes.first?.id
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $vm.navigateToScorecard) {
            MainTabView(vm: vm)
        }
    }
}

#Preview {
    CourseMapView(vm: {
        let rv = ViewModel()
        
        // login with an account that has profile
        rv.username = "testguy420@gmail.com"
        rv.password = "thisisatest"
        rv.login()
        print(rv.errorMessage)
        return rv
    }())
}
