import SwiftUI

struct WelcomeView: View {
    @StateObject private var viewModel = WelcomeViewModel()
    @Binding var showWelcome: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 80))
                    .foregroundColor(Theme.primaryColor)
                    .scaleEffect(viewModel.isAnimating ? 1.0 : 0.8)
                    .opacity(viewModel.isAnimating ? 1.0 : 0.5)
                
                Text(LocalizedStrings.shared.get("discover_yourself"))
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Theme.secondaryColor)
                
                Text(LocalizedStrings.shared.get("professional_mbti"))
                    .font(.system(size: 16))
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
            }
            
            Spacer()
            
            VStack(spacing: 20) {
                Button(action: {
                    showWelcome = false
                }) {
                    HStack {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 20))
                        Text(LocalizedStrings.shared.get("start_test"))
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal, 40)
                
                Text(LocalizedStrings.shared.get("have_account"))
                    .font(.system(size: 14))
                    .foregroundColor(Theme.primaryColor)
                    .onTapGesture {
                        
                    }
            }
            .padding(.bottom, 50)
        }
        .background(Theme.backgroundColor)
        .onAppear {
            viewModel.startAnimation()
        }
    }
}

#Preview {
    WelcomeView(showWelcome: .constant(true))
}