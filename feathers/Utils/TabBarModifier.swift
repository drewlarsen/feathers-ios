import SwiftUI

struct TabBarModifier: ViewModifier {
    let isHidden: Bool
    
    func body(content: Content) -> some View {
        content.preference(key: TabBarPreferenceKey.self, value: isHidden)
    }
}

private struct TabBarPreferenceKey: PreferenceKey {
    static var defaultValue: Bool = false
    
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}

struct TabBarController: UIViewControllerRepresentable {
    var isHidden: Bool
    
    func makeUIViewController(context: Context) -> UIViewController {
        return TabBarCoordinator(isHidden: isHidden)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let coordinator = uiViewController as? TabBarCoordinator {
            coordinator.setHidden(isHidden)
        }
    }
}

class TabBarCoordinator: UIViewController {
    private var isHidden: Bool
    
    init(isHidden: Bool) {
        self.isHidden = isHidden
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setHidden(isHidden)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setHidden(isHidden)
    }
    
    func setHidden(_ hidden: Bool) {
        if let tabBarController = self.tabBarController {
            tabBarController.tabBar.isHidden = hidden
        }
    }
}

extension View {
    func hideTabBar(_ hidden: Bool) -> some View {
        self
            .modifier(TabBarModifier(isHidden: hidden))
            .background(TabBarController(isHidden: hidden))
    }
} 