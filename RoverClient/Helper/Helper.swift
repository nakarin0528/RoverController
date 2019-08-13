import UIKit
import Foundation
import SwiftyUserDefaults

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

    static func getUpCommand1() -> String {
        guard let string = Defaults[.upCommand1] else {
            return ""
        }
        return string
    }

    static func getUpCommand2() -> String {
        guard let string = Defaults[.upCommand2] else {
            return ""
        }
        return string
    }

    static func getLeftCommand1() -> String {
        guard let string = Defaults[.leftCommand1] else {
            return ""
        }
        return string
    }

    static func getLeftCommand2() -> String {
        guard let string = Defaults[.leftCommand2] else {
            return ""
        }
        return string
    }

    static func getRightCommand1() -> String {
        guard let string = Defaults[.rightCommand1] else {
            return ""
        }
        return string
    }

    static func getRightCommand2() -> String {
        guard let string = Defaults[.rightCommand2] else {
            return ""
        }
        return string
    }

    static func getDownCommand1() -> String {
        guard let string = Defaults[.downCommand1] else {
            return ""
        }
        return string
    }

    static func getDownCommand2() -> String {
        guard let string = Defaults[.downCommand2] else {
            return ""
        }
        return string
    }

    static func getACommand1() -> String {
        guard let string = Defaults[.ACommand1] else {
            return ""
        }
        return string
    }

    static func getACommand2() -> String {
        guard let string = Defaults[.ACommand2] else {
            return ""
        }
        return string
    }
    

    static func getBCommand1() -> String {
        guard let string = Defaults[.BCommand1] else {
            return ""
        }
        return string
    }

    static func getBCommand2() -> String {
        guard let string = Defaults[.BCommand2] else {
            return ""
        }
        return string
    }

    static func getYCommand1() -> String {
        guard let string = Defaults[.YCommand1] else {
            return ""
        }
        return string
    }

    static func getYCommand2() -> String {
        guard let string = Defaults[.YCommand2] else {
            return ""
        }
        return string
    }

    static func getXCommand1() -> String {
        guard let string = Defaults[.XCommand1] else {
            return ""
        }
        return string
    }

    static func getXCommand2() -> String {
        guard let string = Defaults[.XCommand2] else {
            return ""
        }
        return string
    }

    static func getStartCommand1() -> String {
        guard let string = Defaults[.startCommand1] else {
            return ""
        }
        return string
    }

    static func getStartCommand2() -> String {
        guard let string = Defaults[.startCommand2] else {
            return ""
        }
        return string
    }

    static func getSelectCommand1() -> String {
        guard let string = Defaults[.selectCommand1] else {
            return ""
        }
        return string
    }

    static func getSelectCommand2() -> String {
        guard let string = Defaults[.selectCommand2] else {
            return ""
        }
        return string
    }

    static func setUpCommand(command1: String, command2: String){
        Defaults[.upCommand1] = command1
        Defaults[.upCommand2] = command2
    }

    static func setLeftCommand(command1: String, command2: String) {
        Defaults[.leftCommand1] = command1
        Defaults[.leftCommand2] = command2
    }

    static func setRightCommand(command1: String, command2: String) {
        Defaults[.rightCommand1] = command1
        Defaults[.rightCommand2] = command2
    }

    static func setDownCommand(command1: String, command2: String) {
        Defaults[.downCommand1] = command1
        Defaults[.downCommand2] = command2
    }

    static func setACommand(command1: String, command2: String) {
        Defaults[.ACommand1] = command1
        Defaults[.ACommand2] = command2
    }

    static func setBCommand(command1: String, command2: String) {
        Defaults[.BCommand1] = command1
        Defaults[.BCommand2] = command2
    }

    static func setYCommand(command1: String, command2: String) {
        Defaults[.YCommand1] = command1
        Defaults[.YCommand2] = command2
    }

    static func setXCommand(command1: String, command2: String) {
        Defaults[.XCommand1] = command1
        Defaults[.XCommand2] = command2
    }

    static func setStartCommand(command1: String, command2: String) {
        Defaults[.startCommand1] = command1
        Defaults[.startCommand2] = command2
    }

    static func setSelectCommand(command1: String, command2: String) {
        Defaults[.selectCommand1] = command1
        Defaults[.selectCommand2] = command2
    }
}
