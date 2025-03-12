import SwiftUI
import FirebaseAuth

struct LoginView: View {
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
                    HStack {
                        Text("Log In")
                            .font(.largeTitle)
                        Image(systemName: "figure.golf")
                            .imageScale(.large)
                    }
                    .padding(.bottom, 40)
                    
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 4)  {
                            Text("Email")
                                .padding(.leading, 16)
                            TextField("Email", text: $vm.username)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }
                        .cornerRadius(8)
                        
                        VStack(alignment: .leading, spacing: 4)  {
                            HStack {
                                Text("Password")
                                    .padding(.leading, 16)
                                Spacer()
                                NavigationLink(destination: ForgotPasswordView(vm: vm)) {
                                    Text("Forgot Password?")
                                        .foregroundColor(.accentColor)
                                        .font(.footnote)
                                }
                                .navigationBarBackButtonHidden()
                                .padding(.trailing, 16)
                            }
                            SecureField("Password", text: $vm.password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                        }
                        .cornerRadius(8)
                        
                        if let errorMessage = vm.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding(.bottom, 20)
                        }
                        
                        Button(action: {
                            if vm.username.isEmpty || vm.password.isEmpty {
                                vm.showingAlert = true
                            } else {
                                vm.login()
                            }
                        }) {
                            Text(vm.isLoading ? "Logging in..." : "Login")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(vm.username.isEmpty || vm.password.isEmpty || vm.isLoading ? Color.gray : Color(hex: vm.green))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(vm.username.isEmpty || vm.password.isEmpty)
                        .padding()
                        .alert(isPresented: $vm.showingAlert) {
                            Alert(title: Text("Error"), message: Text("Please enter both username and password"), dismissButton: .default(Text("OK")))
                        }
                        
                        NavigationLink(destination: SignupView(vm: vm)) {
                            Text("Create Account")
                                .foregroundColor(.accentColor)
                                .font(.footnote)
                        }
                    }
                    .padding()
                }
                .padding()
            }.navigationDestination(isPresented: $vm.isCreated) {
                DashboardView(vm: vm)
            }
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(vm: ViewModel())
    }
}
