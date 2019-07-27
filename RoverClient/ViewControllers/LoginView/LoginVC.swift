//
//  LoginVC.swift
//  RoverClient
//
//  Created by yiheng on 2019/07/27.
//  Copyright © 2019 nakarin. All rights reserved.
//

import Foundation
import UIKit
import Material
import RxSwift
import RxCocoa
import SwiftyUserDefaults

final class LoginVC: UIViewController {

    var disposeBag = DisposeBag()

    private let headerView = HeaderView(title: "接続先")

    private let hostLabel: UILabel = {
        let label = UILabel()
        label.text = "HostName:"
        label.font = .systemFont(ofSize: 24)
        label.sizeToFit()
        return label
    }()

    private lazy var hostnameTextField: UITextField = {
        let textfield = UITextField()
        textfield.font = UIFont.systemFont(ofSize: 20)
        textfield.placeholder = "hostname"
        textfield.borderStyle = .roundedRect
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.delegate = self
        return textfield
    }()

    private let portLabel: UILabel = {
        let label = UILabel()
        label.text = "Port:"
        label.font = .systemFont(ofSize: 24)
        label.sizeToFit()
        return label
    }()

    private lazy var portTextField: UITextField = {
        let textfield = UITextField()
        textfield.font = UIFont.systemFont(ofSize: 20)
        textfield.placeholder = "port"
        textfield.text = "22"
        textfield.borderStyle = .roundedRect
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.delegate = self
        return textfield
    }()

    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username:"
        label.font = .systemFont(ofSize: 24)
        label.sizeToFit()
        return label
    }()

    private lazy var usernameTextField: UITextField = {
        let textfield = UITextField()
        textfield.font = UIFont.systemFont(ofSize: 20)
        textfield.placeholder = "username"
        textfield.borderStyle = .roundedRect
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.delegate = self
        return textfield
    }()

    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password:"
        label.font = .systemFont(ofSize: 24)
        label.sizeToFit()
        return label
    }()

    private lazy var passwordTextField: UITextField = {
        let textfield = UITextField()
        textfield.font = UIFont.systemFont(ofSize: 20)
        textfield.placeholder = "password"
        textfield.borderStyle = .roundedRect
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.isSecureTextEntry = true
        textfield.returnKeyType = .go
        textfield.delegate = self
        return textfield
    }()

    private let connectButton: Button = {
        let btn = DefaultButton(title: "Connect")
        btn.titleColor = .white
        btn.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.3333333333, green: 0.7294117647, blue: 0.6745098039, alpha: 1)
        setupViews()
        setDefaultData()
        bind()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if DeviceSize.type() == .iPhone {
            configureObserver()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if DeviceSize.type() == .iPhone {
            removeObserver()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // Notificationを設定
    func configureObserver() {
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    // キーボードが消えたときに、画面を戻す
    @objc func keyboardWillHide(notification: Notification?) {
        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            self.view.transform = CGAffineTransform.identity
        })
    }

    // Notificationを削除
    func removeObserver() {
        let notification = NotificationCenter.default
        notification.removeObserver(self)
    }

    private func setupViews() {
        self.view.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.top.right.equalToSuperview()
            $0.left.equalTo(leftMargin())
            $0.height.equalTo(DeviceSize.type() == .iPhone ? 50 : 80)
        }

        self.view.addSubview(hostLabel)
        hostLabel.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(15)
            $0.centerX.equalToSuperview().offset(-1 * self.view.layer.width/3)
        }

        self.view.addSubview(hostnameTextField)
        hostnameTextField.snp.makeConstraints {
            $0.top.equalTo(hostLabel.snp.bottom).offset(5)
            $0.left.equalTo(hostLabel)
            $0.height.equalTo(25)
            $0.width.equalTo(3 * self.view.layer.width/4)
        }

        self.view.addSubview(portLabel)
        portLabel.snp.makeConstraints {
            $0.top.equalTo(hostLabel)
            $0.left.equalTo(hostnameTextField.snp.right).offset(15)
        }

        self.view.addSubview(portTextField)
        portTextField.snp.makeConstraints {
            $0.top.equalTo(portLabel.snp.bottom).offset(5)
            $0.left.equalTo(portLabel)
            $0.height.equalTo(25)
            $0.width.equalTo(50)
        }

        self.view.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(hostnameTextField.snp.bottom).offset(15)
            $0.left.equalTo(hostLabel)
        }

        self.view.addSubview(usernameTextField)
        usernameTextField.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(5)
            $0.height.equalTo(25)
            $0.left.equalTo(hostnameTextField)
            $0.right.equalTo(portTextField)
        }

        self.view.addSubview(passwordLabel)
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(usernameTextField.snp.bottom).offset(15)
            $0.left.equalTo(hostLabel)
        }

        self.view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(5)
            $0.height.equalTo(25)
            $0.left.equalTo(hostnameTextField)
            $0.right.equalTo(portTextField)
        }

        self.view.addSubview(connectButton)
        connectButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(passwordTextField.snp.bottom).offset(30)
            $0.width.equalTo(190)
            $0.height.equalTo(40)
        }
    }

    func bind() {
        self.connectButton.rx.tap
            .subscribe(onNext: {
                if self.isValidConfiguration() {
                    self.setCurrentData()
                    let vc = ShellVC()
                    self.present(vc, animated: true)
                } else {
                    Alert.notice(title: "入力漏れ", message: "全項目入力してください")
                }
            })
            .disposed(by: disposeBag)
    }

    private func setDefaultData() {
        hostnameTextField.text = Defaults[.hostname]
        if let port = Defaults[.port] {
            portTextField.text = String(port)
        }
        usernameTextField.text = Defaults[.username]
        passwordTextField.text = Defaults[.password]
    }

    private func setCurrentData() {
        Defaults[.hostname] = hostnameTextField.text
        Defaults[.port] = Int(portTextField.text!)
        Defaults[.username] = usernameTextField.text
        Defaults[.password] = passwordTextField.text
    }

    private func isValidConfiguration() -> Bool {
        guard !self.hostnameTextField.text!.isEmpty else { return false }
        guard !self.portTextField.text!.isEmpty else { return false }
        guard !self.usernameTextField.text!.isEmpty else { return false }
        guard !self.passwordTextField.text!.isEmpty else { return false }

        return true
    }
}


extension LoginVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === self.hostnameTextField {
            self.usernameTextField.becomeFirstResponder()
        } else if textField === self.portTextField {
            self.usernameTextField.becomeFirstResponder()
        } else if textField === self.usernameTextField && self.passwordTextField.isEnabled {
            self.passwordTextField.becomeFirstResponder()
        }

        return false
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField === self.passwordTextField {
            UIView.animate(withDuration: 0.1, animations: { () in
                let transform = CGAffineTransform(translationX: 0, y: -100)
                self.view.transform = transform
            })
        }

        return true
    }
}
