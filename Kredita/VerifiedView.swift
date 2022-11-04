import SwiftUI

struct VerifiedView: View {
    let action: () -> Void
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            VStack {
                Image("kredita_logo")
                    .padding(.top, 98)
                
                Image("verified_illustration")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .padding(.top, 55)
                
                Spacer()
                
                Text("You’re Verified!")
                    .multilineTextAlignment(.center)
                    .font(.custom("Nunito-Bold", size: 35))
                    .foregroundColor(Color(hex: "1C1300"))
                    .padding(.bottom, 4)
                
                Text("One more step to create your account:")
                    .font(.custom("Nunito-Regular", size: 18))
                    .foregroundColor(Color(hex: "1C1300"))
                
                TextField("Email", text: $email)
                    .textFieldStyle(RegisterLoginTextFieldStyle(fontSize: 20))
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RegisterLoginTextFieldStyle(fontSize: 20))
                    .keyboardType(.asciiCapable)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                Spacer()
                
                Button(action: action) {
                    ZStack {
                        Color(hex: "FFAD00")
                        Text("Sign Up")
                            .font(.custom("Nunito-Black", size: 22))
                            .foregroundColor(Color.white)
                    }.cornerRadius(30)
                }
                .buttonStyle(ScaleButtonStyle())
                .frame(width: 214, height: 60)

                Spacer()
            }
        }.preferredColorScheme(.light)
    }
}

struct RegisterLoginTextFieldStyle: TextFieldStyle {
    var fontSize: CGFloat
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(18)
            .frame(height: 56)
            .background(.white)
            .cornerRadius(28)
            .addBorder(Color.black.opacity(0.23), width: 1, cornerRadius: 28)
            .padding(EdgeInsets(top: 5, leading: 47, bottom: 0, trailing: 47))
            .font(.custom("Nunito-Light", size: fontSize))
            .foregroundColor(.black)
    }
}

extension View {
    public func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S : ShapeStyle {
        let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
        return clipShape(roundedRect)
            .overlay(roundedRect.strokeBorder(content, lineWidth: width))
    }
}
