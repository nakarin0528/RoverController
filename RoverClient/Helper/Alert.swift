import UIKit
import Foundation

struct Alert {

    static func action(title: String, message: String,  completion: @escaping () -> ()) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .default, handler:{ (action: UIAlertAction!) -> Void in
            completion()
        })

        alert.addAction(action)

        Helper.frontViewController()?.present(alert, animated: true, completion: nil)
    }

    static func choice(title: String, message: String, completion: @escaping () -> ()) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) -> Void in
            completion()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) -> Void in
            alert.dismiss(animated: true, completion: nil)
        })

        alert.addAction(cancel)
        alert.addAction(action)

        Helper.frontViewController()?.present(alert, animated: true, completion: nil)
    }

    static func notice(title: String, message: String) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) -> Void in
            alert.dismiss(animated: true, completion: nil)
        })

        alert.addAction(action)

        Helper.frontViewController()?.present(alert, animated: true, completion: nil)
    }

    static func help(title: String, message: String) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) -> Void in
            alert.dismiss(animated: true, completion: nil)
        })
        let twitter = UIAlertAction(title: "Developer's twitter", style: .default, handler: { (action: UIAlertAction!) -> Void in
            let screenName =  "nakarinrin0528"
            let appURL = NSURL(string: "twitter://user?screen_name=\(screenName)")!
            let webURL = NSURL(string: "https://twitter.com/\(screenName)")!

            let application = UIApplication.shared

            if application.canOpenURL(appURL as URL) {
                application.open(appURL as URL)
            } else {
                application.open(webURL as URL)
            }
            alert.dismiss(animated: true, completion: nil)
        })

        alert.addAction(twitter)
        alert.addAction(action)

        Helper.frontViewController()?.present(alert, animated: true, completion: nil)
    }

    static func setCommand(title: String, line1: String, line2: String, completion: @escaping (String, String) -> ()) {
        let alert = UIAlertController(title: title, message: "line1: touch down\nline2: touch up", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: {[weak alert] (action) -> Void in

            var touchDownCommand = ""
            var touchUpInsideComand = ""

            guard let textFields = alert?.textFields else {
                return
            }

            for text in textFields {
                if text.tag == 1 {
                    if let command = text.text {
                        touchDownCommand = command
                    }
                } else {
                    if let command = text.text {
                        touchUpInsideComand = command
                    }
                }
            }

            completion(touchDownCommand, touchUpInsideComand)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addTextField(configurationHandler: {(text:UITextField!) -> Void in
            text.text = line1
            text.tag  = 1
        })
        alert.addTextField(configurationHandler: {(text:UITextField!) -> Void in
            text.text = line2
            text.tag  = 2
        })

        alert.addAction(ok)
        alert.addAction(cancel)

        Helper.frontViewController()?.present(alert, animated: true, completion: nil)
    }
}
