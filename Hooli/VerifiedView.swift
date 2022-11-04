import SwiftUI
import UIKit

struct VerifiedView: View {
    var body: some View {
        ScrollView {
            VStack {
                topSection()
                
                Header(title: "New")
                
                CardView(
                    viewModel: .init(
                        header: "Invite Your Friends and Earn!",
                        body: "For every friend you refer, you’ll receive $5. You can earn up to $25 total.",
                        actionButtonTitle: "Invite Now",
                        type: .imageTop(Image("verified_card_top"), "Get $25 free!")
                    )
                )
                
                Header(title: "Recommendations")
                
                CardView(
                    viewModel: .init(
                        header: "Spending",
                        body: "You spent $468 on food. That’s 50% higher than normal",
                        actionButtonTitle: "More details",
                        type: .leftCounterBox(17)
                    )
                )
                
                CardView(
                    viewModel: .init(
                        header: "Credit",
                        body: "Switch your credit card to reduce your annual fee.",
                        actionButtonTitle: "More details",
                        type: .leftCounterBox(8)
                    )
                )
            }
        }
        .background(Color(hex: "F9F9FB"))
        .preferredColorScheme(.light)
    }
    
    private func topSection() -> some View {
        VStack {
            HStack {
                Spacer()
                Image("verified_top")
                    .padding(.top, 78)
                Spacer()
            }
            Text("You’re Verified!")
                .font(.custom("InterstateBlackCondensed", size: 35))
                .foregroundColor(Color.white)
            
            Text("You’re ready to start earning")
                .font(.custom("Interstate-Regular", size: 18))
                .padding(.top, 14)
                .padding(.bottom, 41)
                .foregroundColor(Color.white)
        }
        .background(Color(hex: "01ABE8"))
        .cornerRadius(30, corners: [.bottomLeft, .bottomRight])
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct Header: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.custom("InterstateBlackCondensed", size: 22))
                .foregroundColor(Color(hex: "1C1939"))
                .padding(.leading, 25)
                .padding(.top, 38)
            Spacer()
        }
    }
}

enum CardType {
    case imageTop(Image, String)
    case leftCounterBox(Int)
}

struct CardViewModel {
    let header: String
    let body: String
    let actionButtonTitle: String
    let type: CardType
}

struct CardView: View {
    let viewModel: CardViewModel
    
    var body: some View {
        switch viewModel.type {
        case .imageTop(let image, let textOverlay):
            imageTop(image: image, textOverlay: textOverlay)
        case .leftCounterBox(let value):
            leftCounterBox(with: value)
        }
    }
    
    private func imageTop(image: Image, textOverlay: String) -> some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .top) {
                image
                HStack {
                    Spacer()
                    Text(textOverlay)
                        .font(.custom("InterstateBlackCondensed", size: 22))
                        .foregroundColor(Color.white)
                        .padding(.top, 18)
                        .padding(.trailing, 21)
                }
            }
            Text(viewModel.header)
                .font(.custom("InterstateBlackCondensed", size: 16))
                .foregroundColor(Color(hex: "1C1939"))
                .padding(.top, 28)
                .padding(.leading, 21)
            Text(viewModel.body)
                .fontWithLineHeight(
                    font: UIFont(name: "Interstate-Regular", size: 13)!,
                    lineHeight: 20
                )
                .foregroundColor(Color(hex: "1C1939"))
                .padding(.top, 14)
                .padding(.leading, 21)
                .padding(.trailing, 21)
            Button(action: {}) {
                Text(viewModel.actionButtonTitle)
                    .font(.custom("InterstateBlackCondensed", size: 15))
                    .foregroundColor(Color(hex: "01ABE8"))
                    .padding(.top, 18)
                    .padding(.leading, 21)
                    .padding(.bottom, 30)
            }
        }
        .background(Color.white)
        .cornerRadius(10, corners: .allCorners)
        .padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 25))
    }
    
    private func leftCounterBox(with value: Int) -> some View {
        HStack {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(Color(hex: "01ABE8"))
                        .frame(width: 52, height: 52)
                    Text("+\(value)")
                        .font(.custom("InterstateBlackCondensed", size: 15))
                        .foregroundColor(Color.white)
                }
                .padding(.top, 32)
                .padding(.leading, 18)
                Spacer()
            }
            VStack(alignment: .leading, spacing: 0) {
                Text(viewModel.header)
                    .font(.custom("InterstateBlackCondensed", size: 16))
                    .foregroundColor(Color(hex: "9EA6BE"))
                    .padding(.top, 28)
                    .padding(.leading, 21)
                Text(viewModel.body)
                    .fontWithLineHeight(
                        font: UIFont(name: "Interstate-Regular", size: 13)!,
                        lineHeight: 20
                    )
                    .foregroundColor(Color(hex: "1C1939"))
                    .padding(.top, 14)
                    .padding(.leading, 21)
                    .padding(.trailing, 21)
                Button(action: {}) {
                    Text(viewModel.actionButtonTitle)
                        .font(.custom("InterstateBlackCondensed", size: 15))
                        .foregroundColor(Color(hex: "01ABE8"))
                        .padding(.top, 18)
                        .padding(.leading, 21)
                        .padding(.bottom, 30)
                }
            }
            Spacer()
        }
        .background(Color.white)
        .cornerRadius(10, corners: .allCorners)
        .padding(EdgeInsets(top: 0, leading: 25, bottom: 14, trailing: 25))
    }
}

struct FontWithLineHeight: ViewModifier {
    let font: UIFont
    let lineHeight: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(Font(font))
            .lineSpacing(lineHeight - font.lineHeight)
            .padding(.vertical, (lineHeight - font.lineHeight) / 2)
    }
}

extension View {
    func fontWithLineHeight(font: UIFont, lineHeight: CGFloat) -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: font, lineHeight: lineHeight))
    }
}
