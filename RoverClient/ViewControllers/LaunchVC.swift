//
//  LaynchVC.swift
//  RoverClient
//
//  Created by yiheng on 2019/08/12.
//  Copyright © 2019 nakarin. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class LaunchVC: UIViewController {

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "icon")
        return imageView
    }()

    private let nakarinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "nakarin")
        imageView.alpha = 0
        return imageView
    }()

//    private let backgroundView: UIView = {
//        let view = UIView()
//        view.backgroundColor = #colorLiteral(red: 0.3333333333, green: 0.7294117647, blue: 0.6745098039, alpha: 1)
//        view.layer.cornerRadius =
//        return view
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = .white

        self.view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.size.equalTo(200)
            $0.center.equalToSuperview()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        UIView.animateKeyframes(withDuration: 0.75, delay: 0.2, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.1, animations: {
                let angle = CGFloat((90.0 * Double.pi) / 180.0)
                self.logoImageView.transform = CGAffineTransform(rotationAngle: angle)
                self.view.layoutIfNeeded()
            })
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.2, animations: {
                let angle = CGFloat((-90.01 * Double.pi) / 180.0)
                self.logoImageView.transform = CGAffineTransform(rotationAngle: angle)
                self.view.layoutIfNeeded()
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.2, animations: {
                let angle = CGFloat((89.98 * Double.pi) / 180.0)
                self.logoImageView.transform = CGAffineTransform(rotationAngle: angle)
                self.view.layoutIfNeeded()
            })
            UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.25, animations: {
                let angle = CGFloat((0.0 * Double.pi) / 180.0)
                self.logoImageView.transform = CGAffineTransform(rotationAngle: angle)
                self.view.layoutIfNeeded()
            })
            UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.32, animations: {
                let angle = CGFloat((0.0 * Double.pi) / 180.0)
                self.logoImageView.transform = CGAffineTransform(rotationAngle: angle)
                self.view.layoutIfNeeded()
            })
        }, completion: { _ in
            let vc = LoginVC()
            vc.modalTransitionStyle = .flipHorizontal
            self.present(vc, animated: true)
        })
    }
}
