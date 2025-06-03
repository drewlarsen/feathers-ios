import SwiftUI
import UIKit

struct OrientationAwareTabView<Content: View>: UIViewControllerRepresentable {
    let content: Content
    @Binding var selection: Int
    
    init(selection: Binding<Int>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> OrientationAwareTabBarController {
        let tabBarController = OrientationAwareTabBarController()
        tabBarController.delegate = context.coordinator
        
        let host = UIHostingController(rootView: content)
        host.view.backgroundColor = .clear
        
        // Extract UITabBarItems from SwiftUI view hierarchy
        let mirror = Mirror(reflecting: content)
        var tabItems: [UIViewController] = []
        
        for child in mirror.children {
            if let tabItem = child.value as? TabItemPage {
                let hostController = UIHostingController(rootView: tabItem.content)
                hostController.tabBarItem = UITabBarItem(
                    title: tabItem.title,
                    image: tabItem.icon,
                    tag: tabItem.tag
                )
                tabItems.append(hostController)
            }
        }
        
        tabBarController.viewControllers = tabItems
        tabBarController.selectedIndex = selection
        
        return tabBarController
    }
    
    func updateUIViewController(_ tabBarController: OrientationAwareTabBarController, context: Context) {
        tabBarController.selectedIndex = selection
    }
    
    class Coordinator: NSObject, UITabBarControllerDelegate {
        var parent: OrientationAwareTabView
        
        init(_ tabView: OrientationAwareTabView) {
            self.parent = tabView
        }
        
        func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            parent.selection = viewController.tabBarItem.tag
        }
    }
}

struct TabItemPage {
    let content: AnyView
    let title: String
    let icon: UIImage
    let tag: Int
}

extension View {
    func tabItem(title: String, systemImage: String, tag: Int) -> TabItemPage {
        return TabItemPage(
            content: AnyView(self),
            title: title,
            icon: UIImage(systemName: systemImage) ?? UIImage(),
            tag: tag
        )
    }
} 