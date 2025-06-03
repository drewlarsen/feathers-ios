import UIKit

class OrientationAwareTabBarController: UITabBarController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let isLandscape = size.width > size.height
        coordinator.animate(alongsideTransition: { _ in
            self.tabBar.isHidden = isLandscape
        })
    }
} 