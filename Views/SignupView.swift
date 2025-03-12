import SwiftUI

struct SignupView: View {
    @ObservedObject var vm: ViewModel
    @State var username = ""
    @State var password = ""
    @State var confirmPassword = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: vm.green)
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(Color(hex: vm.white))
                    .opacity(0.8)
                VStack(spacing: 20) {
                    Spacer()
                    TextField("Email", text: $username)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    
                    HStack {
                        if vm.showPassword {
                            TextField("Password", text: $password)
                                .autocapitalization(.none)
                                .padding()
                        } else {
                            SecureField("Password", text: $password)
                                .autocapitalization(.none)
                                .padding()
                        }
                        
                        Button(action: {
                            vm.showPassword.toggle()
                        }) {
                            Image(systemName: vm.showPassword ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                        .padding()
                    }
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    
                    HStack {
                        if vm.showConfirmPassword {
                            TextField("Confirm Password", text: $confirmPassword)
                                .autocapitalization(.none)
                                .padding()
                        } else {
                            SecureField("Confirm Password", text: $confirmPassword)
                                .autocapitalization(.none)
                                .padding()
                        }
                        
                        Button(action: {
                            vm.showConfirmPassword.toggle()
                        }) {
                            Image(systemName: vm.showConfirmPassword ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                        .padding()
                    
                    }
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    
                    Button(action: {
                        if (username.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                            vm.showingAlert = true
                        } else if password != confirmPassword {
                            vm.errorMessage = "Passwords do not match."
                        } else {
                            vm.signup(withEmail: username, password: password)
                        }
                    }) {
                        Text(vm.isLoading ? "Signing up..." : "Sign Up")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(username.isEmpty || password.isEmpty || confirmPassword.isEmpty || vm.isLoading ? Color.gray : Color(hex: vm.green))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                    .disabled(username.isEmpty || password.isEmpty || confirmPassword.isEmpty)
                    .alert(isPresented: $vm.showingAlert) {
                        Alert(title: Text("Error"), message: Text("Enter a valid email"), dismissButton: .default(Text("OK")))
                    }
                    
                    if let errorMessage = vm.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.bottom, 20)
                    }
                    Spacer()
                }
                .padding()
                .navigationTitle("Sign Up")
                .navigationDestination(isPresented: $vm.isSignedUp) {
                    LoginView(vm: vm)
                }
            }
        }
    }
}

#Preview {
    SignupView(vm: ViewModel())
}
