import SwiftUI

struct OrientationAwareColumns {
    let portrait: Int
    let landscape: Int
    
    static let spirits = OrientationAwareColumns(portrait: 2, landscape: 3)
    static let feathers = OrientationAwareColumns(portrait: 4, landscape: 6)
    static let arrangements = OrientationAwareColumns(portrait: 2, landscape: 4)
}

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
} 