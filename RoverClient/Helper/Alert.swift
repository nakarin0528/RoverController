import UIKit

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
        let cancel = UIAlertAction(title: "キャンセル", style: .default, handler: { (action: UIAlertAction!) -> Void in
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
}
