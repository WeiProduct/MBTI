import Foundation
import SwiftUI

class WelcomeViewModel: ObservableObject {
    @Published var isAnimating = false
    
    func startAnimation() {
        withAnimation(.easeInOut(duration: 1.0)) {
            isAnimating = true
        }
    }
}