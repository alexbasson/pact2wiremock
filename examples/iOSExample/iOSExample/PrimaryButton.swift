import SwiftUI

struct PrimaryButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(16.0)
    }
}

extension View {
    func primaryButton() -> some View {
        modifier(PrimaryButton())
    }
}

