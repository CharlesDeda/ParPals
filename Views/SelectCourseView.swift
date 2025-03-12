import SwiftUI

struct SelectCourseView: View {
    @ObservedObject var vm: ViewModel
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
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
                    LazyVGrid(columns: columns, spacing: 20) {
                        NavigationLink(destination: PartyView(vm: vm)) {
                            CourseName.castleBay.label
                        }.simultaneousGesture(TapGesture().onEnded {
                            vm.selectCourse(courseName: .castleBay)
                        })
                        NavigationLink(destination: PartyView(vm: vm)) {
                            CourseName.wilmingtonMunicipal.label
                        }.simultaneousGesture(TapGesture().onEnded {
                            vm.selectCourse(courseName: .wilmingtonMunicipal)
                        })
                        NavigationLink(destination: PartyView(vm: vm)) {
                            CourseName.ironclad.label
                        }.simultaneousGesture(TapGesture().onEnded {
                            vm.selectCourse(courseName: .ironclad)
                        })
                        NavigationLink(destination: PartyView(vm: vm)) {
                            CourseName.beauRivage.label
                        }.simultaneousGesture(TapGesture().onEnded {
                            vm.selectCourse(courseName: .beauRivage)
                        })
                    }
                    .padding()
                    .frame(maxHeight: .infinity)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Select A Course")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                }
            }
        }
    }
}

#Preview {
    SelectCourseView(vm: {
        let rv = ViewModel()
        
        // login with an account that has prfile
        rv.username = "testguy420@gmail.com"
        rv.password = "thisisatest"
        rv.login()
        print(rv.errorMessage)
        return rv
    }())
}
