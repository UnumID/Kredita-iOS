import SwiftUI

struct VerifyView: View {
    var buttonAction: () -> Void
    var sendLogsAction: () -> Void
    
    var body: some View {
        VStack {
            Image("account_created")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 258, height: 233)
                .padding(.top, 143)
            
            Text("Account Created!")
                .font(.custom("InterstateBlackCondensed", size: 35))
                .padding(.top, 96)
                .foregroundColor(Color(hex: "1C1939"))
            
            Text("Next, please verify your identity")
                .font(.custom("Interstate-Regular", size: 15))
                .padding(.top, 9)
                .foregroundColor(Color(hex: "1C1939"))
                .opacity(0.8)
            
            Button(action: buttonAction) {
                ZStack {
                    Color(hex: "01ABE8")
                    Text("Verify Identity")
                        .font(.custom("InterstateBlackCondensed", size: 22))
                        .foregroundColor(Color.white)
                }.cornerRadius(10)
            }
            .buttonStyle(ScaleButtonStyle())
            .frame(height: 60)
            .padding(EdgeInsets(top: 108, leading: 37, bottom: 0, trailing: 37))
            
            Text("Powered by Unum ID")
                .font(.custom("Interstate-Regular", size: 15))
                .padding(.top, 18)
                .padding(.bottom, 135)
                .foregroundColor(Color(hex: "1C1939"))
                .opacity(0.8)
        }
        .padding(.bottom, 100)
    }
}

struct ScaleButtonStyle: ButtonStyle {
    private let animation = Animation.interpolatingSpring(stiffness: 300.0,
                                                          damping: 30.0,
                                                          initialVelocity: 10.0)
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(animation, value: configuration.isPressed)
    }
}
