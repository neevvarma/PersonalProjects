import SwiftUI

extension View {
    func onLongPress(minimumDuration: Double = 0.5, perform action: @escaping () -> Void) -> some View {
        self.gesture(
            LongPressGesture(minimumDuration: minimumDuration)
                .onEnded { _ in
                    action()
                }
        )
    }
}
