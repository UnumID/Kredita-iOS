import SwiftUI

struct SignUpView: View {
    let action: () -> Void
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            VStack {
                Image("kredita_logo")
                    .padding(.top, 98)
                
                Spacer()
                
                Text("You’re moments\naway from magic…")
                    .multilineTextAlignment(.center)
                    .font(.custom("Nunito-Bold", size: 35))
                    .foregroundColor(Color(hex: "1C1300"))
                    .padding(.bottom, 4)
                
                Group {
                    Text("To get started, please verify your identity")
                        .font(.custom("Nunito-Regular", size: 18))
                        .foregroundColor(Color(hex: "1C1300"))
                    Spacer()
                    Button(action: action) {
                        ZStack {
                            Color(hex: "FFAD00")
                            Text("Verify Identity")
                                .font(.custom("Nunito-Black", size: 22))
                                .foregroundColor(Color.white)
                        }.cornerRadius(30)
                    }
                    .buttonStyle(ScaleButtonStyle())
                    .frame(width: 214, height: 60)
                }
                
                Text("Powered by Unum ID")
                    .font(.custom("Nunito-Regular", size: 15))
                    .padding(.top, 5)
                    .foregroundColor(Color(hex: "1C1300"))
                
                Spacer()
                Image("verify_illustration")
                
                Spacer()
            }
        }.preferredColorScheme(.light)
    }
}
