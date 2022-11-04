import SwiftUI

struct SignUpView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var accepted: Bool = false
    
    let action: (String) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Welcome!")
                .font(.custom("InterstateBlackCondensed", size: 35))
                .padding(.top, 116)
                .foregroundColor(Color(hex: "1C1939"))
            
            Text("Create your account below")
                .font(.custom("Interstate-Regular", size: 15))
                .padding(.top, 9)
                .foregroundColor(Color(hex: "1C1939"))
                .opacity(0.8)
            
            Image("signup_top")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 231, height: 184)
                .padding(.top, 50)
                .padding(.bottom, 60)
            
            TextField("Email Address", text: $email)
                .textFieldStyle(RegisterLoginTextFieldStyle(fontSize: 15))
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RegisterLoginTextFieldStyle(fontSize: 15))
                .keyboardType(.asciiCapable)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            HStack {
                Button(action: { accepted.toggle() }) {
                    ZStack {
                        Image("checkbox")
                        if accepted {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color(hex: "1C1939"))
                        }
                    }
                }
                Group {
                    Text("I agree to the ") +
                    Text("Privacy Policy")
                        .underline()
                        .foregroundColor(Color(hex: "01ABE8")) +
                    Text(" and ") +
                    Text("Terms of Use")
                        .underline()
                        .foregroundColor(Color(hex: "01ABE8"))
                }.font(.custom("Interstate-Regular", size: 15))
            }.padding(.top, 19)
            
            Button(action: { action(email) }) {
                ZStack {
                    Color(hex: "01ABE8")
                    Text("Create Account")
                        .font(.custom("InterstateBlackCondensed", size: 22))
                        .foregroundColor(Color.white)
                }.cornerRadius(10)
            }
            .buttonStyle(ScaleButtonStyle())
            .frame(height: 60)
            .padding(EdgeInsets(top: 25, leading: 37, bottom: 0, trailing: 37))
            
            Button(action: {}) {
                Text("Already have an account? Sign In")
                .font(.custom("Interstate-Regular", size: 15))
                .foregroundColor(Color(hex: "1C1939"))
                .opacity(0.8)
            }.padding(.top, 18)
            
            Spacer()
        }

    }
}

struct RegisterLoginTextFieldStyle: TextFieldStyle {
    var fontSize: CGFloat
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(18)
            .frame(height: 50)
            .background(Color(hex: "F7F7F7"))
            .cornerRadius(10)
            .padding(EdgeInsets(top: 5, leading: 37, bottom: 0, trailing: 37))
            .font(.custom("Interstate-Regular", size: fontSize))
            .foregroundColor(.black)
    }
}
