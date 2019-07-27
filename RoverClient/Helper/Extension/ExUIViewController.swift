import UIKit
import SnapKit

extension UIViewController {

    func startIndicator() {

        let loadingIndicator = UIActivityIndicatorView(style: .whiteLarge)

        loadingIndicator.center = self.view.center
        let grayOutView = UIView()
        grayOutView.layer.cornerRadius = 20
        grayOutView.backgroundColor = .black
        grayOutView.alpha = 0.6

        // 他のViewと被らない値を代入
        loadingIndicator.tag = 999
        grayOutView.tag = 999

        view.addSubview(grayOutView)
        view.addSubview(loadingIndicator)
        view.bringSubviewToFront(grayOutView)
        view.bringSubviewToFront(loadingIndicator)

        grayOutView.snp.makeConstraints {
            $0.size.equalTo(100)
            $0.center.equalToSuperview()
        }

        loadingIndicator.startAnimating()
    }

    func endIndicator() {
        self.view.subviews.forEach {
            if $0.tag == 999 {
                $0.removeFromSuperview()
            }
        }
    }


    func topMargin() -> ConstraintItem {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.snp.topMargin
        } else {
            return self.topLayoutGuide.snp.bottom //ステータスバーの下
        }
    }

    func bottomMargin() -> ConstraintItem {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.snp.bottomMargin
        } else {
            return self.view.snp.bottomMargin
        }
    }

    func leftMargin() -> ConstraintItem {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.snp.leftMargin
        } else {
            return self.view.snp.leftMargin
        }
    }

    func rightMargin() -> ConstraintItem {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.snp.rightMargin
        } else {
            return self.view.snp.rightMargin
        }
    }
}
