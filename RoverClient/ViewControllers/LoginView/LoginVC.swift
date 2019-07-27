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
        btn.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupViews()
        setDefaultData()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    private func setupViews() {
        self.view.addSubview(hostLabel)
        hostLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(self.view.layer.height/12)
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
            $0.left.equalTo(hostnameTextField.snp.right).offset(20)
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
            $0.top.equalTo(hostnameTextField.snp.bottom).offset(20)
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
            $0.top.equalTo(usernameTextField.snp.bottom).offset(20)
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

    private func setDefaultData() {
        hostnameTextField.text = Defaults[.hostname]
        if let port = Defaults[.port] {
            portTextField.text = String(port)
        }
        usernameTextField.text = Defaults[.username]
        passwordTextField.text = Defaults[.password]
    }

    private func isValidConfiguration() -> Bool {
        guard !self.hostnameTextField.text!.isEmpty else { return false }
        guard self.portTextField.text!.isEmpty else { return false }
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
        } else if textField.returnKeyType == .go && self.isValidConfiguration() {

        }
        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.connectButton.isEnabled = self.isValidConfiguration()
    }

}
