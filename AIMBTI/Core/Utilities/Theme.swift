import SwiftUI

struct Theme {
    static let primaryColor = Color(hex: "E67E22")
    static let secondaryColor = Color(hex: "2C3E50")
    static let backgroundColor = Color(hex: "F8F9FA")
    static let cardBackgroundColor = Color.white
    static let textPrimary = Color(hex: "333333")
    static let textSecondary = Color(hex: "666666")
    static let borderColor = Color(hex: "EEEEEE")
    static let successColor = Color(hex: "27AE60")
    static let warningColor = Color(hex: "E74C3C")
    
    static let cornerRadius: CGFloat = 15
    static let buttonCornerRadius: CGFloat = 25
    static let cardPadding: CGFloat = 20
    static let screenPadding: CGFloat = 20
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Theme.primaryColor)
            .cornerRadius(Theme.buttonCornerRadius)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(Theme.secondaryColor)
            .padding(.horizontal, 25)
            .padding(.vertical, 12)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Theme.primaryColor, lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct CardViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(Theme.cardPadding)
            .background(Theme.cardBackgroundColor)
            .cornerRadius(Theme.cornerRadius)
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 2)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardViewModifier())
    }
}