import UIKit
import Foundation

struct Helper {
    // 最前面のViewControllerを取得する
    static func frontViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return frontViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return frontViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return frontViewController(controller: presented)
        }
        return controller
    }

}
