import SwiftUI

struct SignInView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack(spacing: 16) {
            // Username field
            VStack(alignment: .leading, spacing: 4) {
                Text("Username or email address")
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .regular))
                TextField("", text: $username)
                    .padding()
                    .background(Color(.darkGray))
                    .cornerRadius(4)
            }
            
            // Password field with "Forgot password?" link
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Password")
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .regular))
                    Spacer()
                    Text("Forgot password?")
                        .foregroundColor(.blue)
                        .font(.system(size: 14, weight: .regular))
                }
                SecureField("", text: $password)
                    .padding()
                    .background(Color(.darkGray))
                    .cornerRadius(4)
            }
            
            // Sign In button
            Button(action: {
                // Action for sign in
            }) {
                Text("Sign in")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(4)
            }
            .padding(.top, 16)
        }
        .padding()
        .background(Color.black.opacity(0.9)) // Background color of the view
        .cornerRadius(8)
        .padding(.horizontal, 20)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .background(Color.black) // Overall background color
            .edgesIgnoringSafeArea(.all)
    }
}
