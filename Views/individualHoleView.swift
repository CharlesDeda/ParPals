/***
 This is Hayden's project. I'm going to see if I can get this full thing working in 3 days.
 */

import SwiftUI
import MapKit



struct individualHoleView: View {
    let totalScore: Int = 0
    let holeNum: Int = 1
    @ObservedObject var vm: ViewModel
    let strokeStyle = StrokeStyle(
        lineWidth: 2,
        lineCap: .round,
        lineJoin: .round,
        dash: [2, 3]
    )
    @State private var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()

    
    var body: some View {
        
            ZStack {
                MapReader { proxy in
                    Map(position: $vm.cameraPosition) {

                        MapPolyline(coordinates: [vm.greenCoordinate, vm.tappedPosition, vm.holeCoordinate], contourStyle: .straight).stroke(.white, style: strokeStyle)
                        // TODO: Make a 3 point system so
                        
                        Annotation("", coordinate: vm.tappedPosition) {
                            DraggableAnnotation(vm: vm,  coordinate: $coordinate, proxy: proxy) {
                                coordinate in
                                vm.tappedPosition = coordinate
                            }
                        }
                        //TODO: Add safe area inset
                        Annotation("", coordinate: vm.greenCoordinate) {
                            Image(systemName: "figure.golf")
                                .foregroundColor(Color.white)
                                .imageScale(.large)
                                .frame(width: 20, height: 20)
                        }
                        Annotation("", coordinate: vm.holeCoordinate) {
                            Image(systemName: "flag.fill")
                                .foregroundColor(.white)
                                .imageScale(.large)
                                .frame(width: 20, height: 20)
                        }
                        
                        Annotation("", coordinate: vm.midpointOne) {
                            Text("\(String(format: "%.0f", abs(vm.yardage-vm.yardagefromPosition))) yds")
                                .foregroundColor(.white)
                                .background(Color.gray.opacity(0.8))
                                .cornerRadius(14)
                                .offset(CGSize(width:35, height: 0))
                        }
                        Annotation("", coordinate: vm.midpointTwo) {
                            Text("\(String(format: "%.0f", abs(vm.yardagefromPosition))) yds")
                                .foregroundColor(.white)
                                .background(Color.gray.opacity(0.8))
                                .cornerRadius(14)
                                .padding(8)
                                .offset(CGSize(width:35, height: 0))
                        }
                    }
                    
                    
                    // 3 points, 1 from green, 1 from tap, 1 from hole
                    .mapControlVisibility(.hidden)
                    .mapStyle(.imagery)
                    .onTapGesture { location in
                        let position = location
                        if let tempcoord = proxy.convert(position, from: .local) {
                            vm.tappedPosition = tempcoord
                        }
                    }.ignoresSafeArea()
                    
                        .onAppear {
                            vm.updateCameraPosition()
                            vm.yardage = vm.distanceInYards(from: vm.greenCoordinate, to: vm.holeCoordinate)
                            self.coordinate = vm.tappedPosition
                        }
                        .overlay(
                            VStack(alignment: .leading){
                                TopBarView(vm: vm)
                                
                                
                                Spacer()
                                
                                BottomBarView(vm:vm)
                                
                            }
                            
                                .padding()
                        ) // Overlay
                } // Map
            }.toolbar(.hidden)//Map Reader
         //ZStack
    } //NavigationStack
        
        
    
}

struct DraggableAnnotation: View{
    @ObservedObject var vm: ViewModel
    @Binding var coordinate: CLLocationCoordinate2D
    var proxy: MapProxy
    @State private var isActive: Bool = false
    @State private var translation: CGSize = .zero
    var onCoordinateChange: (CLLocationCoordinate2D) -> ()
    var body: some View {
        GeometryReader {
            let frame = $0.frame(in: .global)
            
            Image(systemName: "mappin")
                .font(.title)
                .frame(width: frame.width, height: frame.height)
                .onChange(of: isActive, initial: false) {
                    oldValue, newValue in
                    let position = CGPoint(x: frame.midX, y: frame.midY)
                    if let coordinate = proxy.convert(position, from: .global) {
                        self.coordinate = coordinate
                        translation = .zero
                        onCoordinateChange(coordinate)
                    }
                }

        }.frame(width: 30, height: 30)
            .contentShape(.rect)
        .offset(translation)
            .gesture(
                LongPressGesture(minimumDuration:0.15)
                    .onEnded{
                        isActive = $0}
                    .simultaneously(with: DragGesture(minimumDistance: 0).onChanged{
                        value in if isActive {
                            translation = value.translation
                            print(value.location)

                            
                        }
                    }
                        .onEnded { value in
                            if isActive { isActive = false}
                        }
                                    
                    )
            )
    }
}


struct TopBarView: View {
    @State private var isExpanded: Bool = true
    @ObservedObject var vm: ViewModel
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0){
            HStack(spacing: 16){
                Text("#\(vm.selectedHoleID ?? 1)")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(Color.green)
                    .frame(width: 60)
                    .cornerRadius(10)
                InfoBlock(title: "To Hole", value: "\(String(format: "%.0f", (vm.yardage)))")

// Fixed width for alignment
                if isExpanded {
                    // Expanded content
                        
                        VStack(spacing: 10) {
                            HStack(spacing: 20) {
                                InfoBlock(title: "Par", value: "\(String(describing: vm.scorecard!.holes[((vm.selectedHoleID ?? 1) - 1)].par))")
                                InfoBlock(title: "Blue", value: "395")
                                InfoBlock(title: "Handicap", value: "13")
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            isExpanded.toggle()
                        }) {
                            Image(systemName: "chevron.left")
                                .padding()
                        }
                    

                } else {
                    // Collapsed button
                        Button(action: {
                            isExpanded.toggle()
                        }) {
                            Image(systemName: "chevron.right")
                                .padding()
                        }

                }
            }
        }
//        .padding(.horizontal)
        .background(Color.gray)
            .cornerRadius(10)
            .shadow(radius: 2)
            .animation(.spring(), value: isExpanded)
    }
}

struct InfoBlock: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(Color.white)
            Text(value)
                .font(.headline)
                .foregroundColor(Color.white)
        }
    }
}

struct BottomBarView: View {
    
    @ObservedObject var vm: ViewModel
    
    
    @State var currentHoleID = 1

    
    private func nextHole(){
        if currentHoleID < 18 {
            currentHoleID += 1
            vm.greenCoordinate = vm.teeBoxes[currentHoleID - 1].coordinate
            vm.holeCoordinate = vm.holes[currentHoleID - 1].coordinate
            vm.populateIndividualHoleView(greenCoordinate: vm.greenCoordinate, holeCoordinate: vm.holeCoordinate)
            vm.updateCameraPosition()
            vm.selectedHoleID = currentHoleID
        }
    }
    
    private func lastHole(){
        if currentHoleID > 1 {
            currentHoleID -= 1
            vm.greenCoordinate = vm.teeBoxes[currentHoleID - 1].coordinate
            vm.holeCoordinate = vm.holes[currentHoleID - 1].coordinate
            vm.populateIndividualHoleView(greenCoordinate: vm.greenCoordinate, holeCoordinate: vm.holeCoordinate)
            vm.updateCameraPosition()
            vm.selectedHoleID = currentHoleID
        }
    }

    var body: some View {
        HStack {
            // Back Button

                Button(action: {
                    print("Back tapped")
                    lastHole()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .padding()
                    .frame(maxWidth: .infinity) // Stretch to take equal space
                    .background(Color.gray)
                    .cornerRadius(10)
                    .disabled(vm.selectedHoleID ?? 1 <= 1)
                }
            
            
            Spacer()
            
            // Input Score Button
            Button(action: {
                print("Input Score tapped")
            }) {
                Text("Enter Score")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            Spacer()
            
            // Next Button

                Button(action: {
                    print("Next tapped")
                    nextHole()
                    
                }) {
                    HStack {
                        Text("Next")
                            .font(.system(size: 16, weight: .bold))
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .frame(maxWidth: .infinity) // Stretch to take equal space
                    .background(Color.gray)
                    .cornerRadius(10)
                    .disabled(vm.selectedHoleID ?? 1 >= 18)
                }
            
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.clear)
        .cornerRadius(10)
        .shadow(radius: 2)
        .onAppear{
            self.currentHoleID = vm.selectedHoleID ?? 1
            vm.selectedHoleID = self.currentHoleID
        }
    }
}



#Preview {
    individualHoleView(vm: {
        let rv = ViewModel()
//        let holes = rv.holes
//        let teeBoxes = rv.teeBoxes
//        let firstHole = holes.first?.coordinate
//        let firstBox = teeBoxes.first?.coordinate
        let coordone = CLLocationCoordinate2D(latitude: 34.403721, longitude: -77.703779)
        let coordtwo = CLLocationCoordinate2D(latitude: 34.40495, longitude: -77.70083)
        rv.populateIndividualHoleView(greenCoordinate: coordone, holeCoordinate: coordtwo)
//        ForEach(vm.holes) { hole in
//            Annotation("", coordinate: hole.coordinate)
        // login with an account that has prfile
        rv.username = "testguy420@gmail.com"
        rv.password = "thisisatest"
        rv.login()
        print(rv.errorMessage)
        return rv
    }())

}
