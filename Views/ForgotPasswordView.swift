import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    @ObservedObject var vm: ViewModel
  
    var body: some View {
        ZStack {
            Color(hex: vm.green)
                .ignoresSafeArea()
            Circle()
                .scale(1.7)
                .foregroundColor(Color(hex: vm.white))
                .opacity(0.8)
            VStack {
                TextField("Enter your email", text: $vm.email)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    vm.resetPassword()
                }) {
                    Text("Forgot Password")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
                .alert(isPresented: $vm.showAlert) {
                    Alert(title: Text("Password Reset"), message: Text(vm.alertMessage), dismissButton: .default(Text("OK")))
                    
                    
                }
            }
            .padding()
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
      ForgotPasswordView(vm: ViewModel())
    }
}
