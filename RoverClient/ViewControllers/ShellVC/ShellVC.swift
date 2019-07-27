//
//  ViewController.swift
//  RoverClient
//
//  Created by yiheng on 2019/07/25.
//  Copyright © 2019 nakarin. All rights reserved.
//

import UIKit
import SnapKit
import Material
import RxSwift
import RxCocoa
import SwiftSH
import SwiftyUserDefaults

class ShellVC: UIViewController {

    var disposeBag = DisposeBag()
    var shell: Shell?
    var lastCommand = ""
    var semaphore: DispatchSemaphore!
    var password: String?
    var authenticationChallenge: AuthenticationChallenge?

    private let headerView = HeaderView()

    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .black
        textView.font = .systemFont(ofSize: 16)
        textView.text = ""
        textView.textColor = UIColor.app.green
        textView.isEditable = false
        textView.isSelectable = false
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        textView.delegate = self
        return textView
    }()

    private let disconnectButton: Button = {
        let button = Button()
        button.image = UIImage(named: "disconnect")?.tint(UIColor.app.gray)
        button.backgroundColor = .white
        button.layer.cornerRadius = DeviceSize.type() == .iPhone ? 15 : 20
        return button
    }()

    private let controllerButton: Button = {
        let button = Button()
        button.backgroundColor = .white
        button.layer.cornerRadius = DeviceSize.type() == .iPhone ? 15 : 20
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .black

        guard
            let hostname = Defaults[.hostname],
            let username = Defaults[.username],
            let password = Defaults[.password],
            let port = Defaults[.port]
            else {
                return
        }

        self.headerView.titleLabel.text = "\(username)@\(hostname)"

        self.authenticationChallenge = .byPassword(username: username, password: password)
        self.shell = Shell(host: hostname, port: UInt16(port), terminal: "vanilla")

        self.bind()
        self.setupViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureObserver()
        self.connect()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
        self.disconnect()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // Notificationを設定
    func configureObserver() {
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // キーボードが現れた時に、画面全体をずらす。
    @objc func keyboardWillShow(notification: Notification?) {
        let rect = (notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            self.textView.snp.remakeConstraints {
                $0.left.equalTo(self.leftMargin()).offset(10)
                $0.top.equalTo(self.headerView.snp.bottom)
                $0.right.equalToSuperview()
                $0.bottom.equalToSuperview().inset((rect?.size.height)!)
            }
            self.view.layoutIfNeeded()
        })
    }

    // キーボードが消えたときに、画面を戻す
    @objc func keyboardWillHide(notification: Notification?) {
        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            self.textView.snp.remakeConstraints {
                $0.left.equalTo(self.leftMargin()).offset(10)
                $0.top.equalTo(self.headerView.snp.bottom)
                $0.bottom.right.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        })
    }

    // Notificationを削除
    func removeObserver() {
        let notification = NotificationCenter.default
        notification.removeObserver(self)
    }

    func bind() {
        disconnectButton.rx.tap
            .subscribe(onNext: {
                self.disconnect()
            })
            .disposed(by: disposeBag)
    }

    private func setupViews() {
        self.view.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.top.right.equalToSuperview()
            $0.left.equalTo(leftMargin())
            $0.height.equalTo(DeviceSize.type() == .iPhone ? 50 : 80)
        }

        self.headerView.addSubview(disconnectButton)
        disconnectButton.snp.makeConstraints {
            $0.left.equalTo(self.leftMargin()).offset(15)
            $0.centerY.equalTo(headerView.titleLabel)
            $0.size.equalTo(DeviceSize.type() == .iPhone ? 30 : 40)
        }

        self.headerView.addSubview(controllerButton)
        controllerButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(15)
            $0.centerY.equalTo(headerView.titleLabel)
            $0.size.equalTo(DeviceSize.type() == .iPhone ? 30 : 40)
        }

        self.view.addSubview(textView)
        textView.snp.makeConstraints {
            $0.left.equalTo(self.leftMargin()).offset(10)
            $0.top.equalTo(headerView.snp.bottom)
            $0.bottom.right.equalToSuperview()
        }
    }

    private func connect() {
        shell?.withCallback { (string: String?, error: String?) in
            DispatchQueue.main.async {
                if let string = string {
                    self.appendToTextView(string)
                }
                if let error = error {
                    self.appendToTextView("[ERROR] \(error)")
                }
            }

            }
            .connect()
            .authenticate(self.authenticationChallenge)
            .open { (error) in
                if let error = error {
                    self.appendToTextView("[ERROR] \(error)")
                    self.textView.isEditable = false
                    Alert.action(title: "エラー", message: "接続できませんでした") {
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    self.textView.isEditable = true
                    self.textView.becomeFirstResponder()
                }
        }
    }

    private func disconnect() {
        self.shell?.disconnect { [unowned self] in
            self.textView.isEditable = false
            self.dismiss(animated: true, completion: nil)
        }
    }

    private func appendToTextView(_ text: String) {
        self.textView.text = "\(self.textView.text!)\(text)"
        let range = NSMakeRange(textView.text.count - 1, 0)
        self.textView.scrollRangeToVisible(range)
    }

    private func sendCommand() {
        if let semaphore = self.semaphore {
            self.password = self.lastCommand.trimmingCharacters(in: .newlines)
            semaphore.signal()
        } else {
            print("Last command is '\(self.lastCommand)'")
            self.shell?.write(self.lastCommand) { [unowned self] (error) in
                if let error = error {
                    self.appendToTextView("[ERROR] \(error)")
                }
            }
        }

        self.lastCommand = ""
    }
}

extension ShellVC: UITextViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.textView.resignFirstResponder()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard !text.isEmpty else {
            guard !self.lastCommand.isEmpty else {
                return false
            }

            let endIndex = self.lastCommand.endIndex
            self.lastCommand.removeSubrange(self.lastCommand.index(before: endIndex)..<endIndex)

            return true
        }

        self.lastCommand.append(text)

        if text == "\n" {
            self.sendCommand()
        }

        return true
    }}
