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
    var isSetting = false

    private let headerView = HeaderView()

    private lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
        let ctrlCButton = UIBarButtonItem(title: "Ctrl-C", style: .done, target: self, action: #selector(sendCtrlC))
        ctrlCButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], for: UIControl.State.normal)
        let tabButton = UIBarButtonItem(title: "tab", style: .done, target: self, action: #selector(sendTab))
        tabButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], for: UIControl.State.normal)
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([space, tabButton, ctrlCButton], animated: true)
        return toolBar
    }()

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
        textView.inputAccessoryView = toolBar
        textView.delegate = self
        return textView
    }()

    private let controllerView = ControllerView()

    private let disconnectButton: Button = {
        let button = Button()
        button.image = UIImage(named: "disconnect")?.tint(UIColor.app.gray)
        button.imageView?.contentMode = .scaleToFill
        button.backgroundColor = .white
        button.layer.cornerRadius = DeviceSize.type() == .iPhone ? 15 : 20
        return button
    }()

    private let controllerButton: Button = {
        let button = Button()
        button.image = UIImage(named: "controller")?.tint(with: .white)
        button.imageView?.contentMode = .scaleAspectFill
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
    }

    override func viewWillLayoutSubviews() {
        self.controllerView.setupViews()
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

        controllerButton.rx.tap
            .subscribe(onNext: {
                self.controllerView.isHidden = !self.controllerView.isHidden
                self.disconnectButton.isHidden = !self.disconnectButton.isHidden
                self.controllerButton.image = UIImage(named: "controller")?.tint(with: .white)
                if !self.controllerView.isHidden {
                    self.textView.resignFirstResponder()
                    self.controllerButton.image = UIImage(named: "teminal")?.tint(with: .white)
                }
            })
            .disposed(by: disposeBag)

        controllerView.upButton.rx.controlEvent(.touchDown)
            .subscribe(onNext: {
                if self.isSetting {
                    Alert.setCommand(
                        title: "Up button",
                        line1: Helper.getUpCommand1(),
                        line2: Helper.getUpCommand2(),
                        completion: { command1, command2 in
                            Helper.setUpCommand(command1: command1, command2: command2)
                    })
                } else {
                    self.sendCommand(text: Helper.getUpCommand1()+"\n")
                }
            })
            .disposed(by: disposeBag)

        controllerView.upButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {
                if !self.isSetting {
                    self.sendCommand(text: Helper.getUpCommand2()+"\n")
                }
            })
            .disposed(by: disposeBag)

        controllerView.downButton.rx.controlEvent(.touchDown)
            .subscribe(onNext: {
                if self.isSetting {
                    Alert.setCommand(
                        title: "Down button",
                        line1: Helper.getDownCommand1(),
                        line2: Helper.getDownCommand2(),
                        completion: { command1, command2 in
                            Helper.setDownCommand(command1: command1, command2: command2)
                    })
                } else {
                    self.sendCommand(text: Helper.getDownCommand1()+"\n")
                }
            })
            .disposed(by: disposeBag)

        controllerView.downButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {
                if !self.isSetting {
                    self.sendCommand(text: Helper.getDownCommand2()+"\n")
                }
            })
            .disposed(by: disposeBag)

        controllerView.leftButton.rx.controlEvent(.touchDown)
            .subscribe(onNext: {
                if self.isSetting {
                    Alert.setCommand(
                        title: "Left button",
                        line1: Helper.getLeftCommand1(),
                        line2: Helper.getLeftCommand2(),
                        completion: { command1, command2 in
                            Helper.setLeftCommand(command1: command1, command2: command2)
                    })
                } else {
                    self.sendCommand(text: Helper.getLeftCommand1()+"\n")
                }
            })
            .disposed(by: disposeBag)

        controllerView.leftButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {
                if !self.isSetting {
                    self.sendCommand(text: Helper.getLeftCommand2()+"\n")
                }
            })
            .disposed(by: disposeBag)

        controllerView.rightButton.rx.controlEvent(.touchDown)
            .subscribe(onNext: {
                if self.isSetting {
                    Alert.setCommand(
                        title: "Right button",
                        line1: Helper.getRightCommand1(),
                        line2: Helper.getRightCommand2(),
                        completion: { command1, command2 in
                            Helper.setRightCommand(command1: command1, command2: command2)
                    })
                } else {
                    self.sendCommand(text: Helper.getRightCommand1()+"\n")
                }
            })
            .disposed(by: disposeBag)

        controllerView.rightButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {
                if !self.isSetting {
                    self.sendCommand(text: Helper.getRightCommand2()+"\n")
                }
            })
            .disposed(by: disposeBag)

        controllerView.Abutton.rx.controlEvent(.touchDown)
            .subscribe(onNext: {
                if self.isSetting {
                    Alert.setCommand(
                        title: "A button",
                        line1: Helper.getACommand1(),
                        line2: Helper.getACommand2(),
                        completion: { command1, command2 in
                            Helper.setACommand(command1: command1, command2: command2)
                    })
                } else {
                    self.sendCommand(text: Helper.getACommand1()+"\n")
                }
            })
            .disposed(by: disposeBag)

        controllerView.Abutton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {
                if !self.isSetting {
                    self.sendCommand(text: Helper.getACommand2()+"\n")
                }
            })
            .disposed(by: disposeBag)

        controllerView.Bbutton.rx.controlEvent(.touchDown)
            .subscribe(onNext: {
                if self.isSetting {
                    Alert.setCommand(
                        title: "B button",
                        line1: Helper.getBCommand1(),
                        line2: Helper.getBCommand2(),
                        completion: { command1, command2 in
                            Helper.setBCommand(command1: command1, command2: command2)
                    })
                } else {
                    self.sendCommand(text: Helper.getBCommand1()+"\n")
                }
            })
            .disposed(by: disposeBag)

        controllerView.Bbutton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {
                if !self.isSetting {
                    self.sendCommand(text: Helper.getBCommand2()+"\n")
                }
            })
            .disposed(by: disposeBag)

        controllerView.Xbutton.rx.controlEvent(.touchDown)
            .subscribe(onNext: {
                if self.isSetting {
                    Alert.setCommand(
                        title: "X button",
                        line1: Helper.getXCommand1(),
                        line2: Helper.getXCommand2(),
                        completion: { command1, command2 in
                            Helper.setXCommand(command1: command1, command2: command2)
                    })
                } else {
                    self.sendCommand(text: Helper.getXCommand1()+"\n")
                }
            })
            .disposed(by: disposeBag)

        controllerView.Xbutton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {
                if !self.isSetting {
                    self.sendCommand(text: Helper.getXCommand2()+"\n")
                }
            })
            .disposed(by: disposeBag)

        controllerView.Ybutton.rx.controlEvent(.touchDown)
            .subscribe(onNext: {
                if self.isSetting {
                    Alert.setCommand(
                        title: "Y button",
                        line1: Helper.getYCommand1(),
                        line2: Helper.getYCommand2(),
                        completion: { command1, command2 in
                            Helper.setYCommand(command1: command1, command2: command2)
                    })
                } else {
                    self.sendCommand(text: Helper.getYCommand1()+"\n")
                }
            })
            .disposed(by: disposeBag)

        controllerView.Ybutton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {
                if !self.isSetting {
                    self.sendCommand(text: Helper.getYCommand2()+"\n")
                }
            })
            .disposed(by: disposeBag)

        controllerView.startButton.rx.controlEvent(.touchDown)
            .subscribe(onNext: {
                if self.isSetting {
                    Alert.setCommand(
                        title: "start button",
                        line1: Helper.getStartCommand1(),
                        line2: Helper.getStartCommand2(),
                        completion: { command1, command2 in
                            Helper.setStartCommand(command1: command1, command2: command2)
                    })
                } else {
                    self.sendCommand(text: Helper.getStartCommand1()+"\n")
                }
            })
            .disposed(by: disposeBag)

        controllerView.startButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {
                if !self.isSetting {
                    self.sendCommand(text: Helper.getStartCommand2()+"\n")
                }
            })
            .disposed(by: disposeBag)

        controllerView.selectButton.rx.controlEvent(.touchDown)
            .subscribe(onNext: {
                if self.isSetting {
                    Alert.setCommand(
                        title: "select button",
                        line1: Helper.getSelectCommand1(),
                        line2: Helper.getSelectCommand2(),
                        completion: { command1, command2 in
                            Helper.setSelectCommand(command1: command1, command2: command2)
                    })
                } else {
                    self.sendCommand(text: Helper.getSelectCommand1()+"\n")
                }
            })
            .disposed(by: disposeBag)

        controllerView.selectButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {
                if !self.isSetting {
                    self.sendCommand(text: Helper.getSelectCommand2()+"\n")
                }
            })
            .disposed(by: disposeBag)

        controllerView.modeButton.rx.tap
            .subscribe(onNext: {
                self.isSetting = !self.isSetting
                self.controllerView.modeButton.title = self.isSetting ? "Setting mode" : "Operation mode"
            })
            .disposed(by: disposeBag)
    }

    private func setupViews() {
        self.view.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.top.right.equalToSuperview()
            $0.left.equalToSuperview()
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
            $0.height.equalTo(DeviceSize.type() == .iPhone ? 30 : 40)
            $0.width.equalTo(DeviceSize.type() == .iPhone ? 50 : 70)
        }

        self.view.addSubview(textView)
        textView.snp.makeConstraints {
            $0.left.equalTo(self.leftMargin()).offset(10)
            $0.top.equalTo(headerView.snp.bottom)
            $0.bottom.right.equalToSuperview()
        }

        self.view.addSubview(controllerView)
        controllerView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.bottom.left.right.equalToSuperview()
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
                    Alert.action(title: "Error", message: "could not connect") {
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

    private func sendCommand(text: String) {
        if let semaphore = self.semaphore {
            self.password = self.lastCommand.trimmingCharacters(in: .newlines)
            semaphore.signal()
        } else {
            print("Last command is '\(self.lastCommand)'")
            self.shell?.write(text) { [unowned self] (error) in
                if let error = error {
                    self.appendToTextView("[ERROR] \(error)")
                }
            }
        }

        self.lastCommand = ""
    }

    @objc private func sendCtrlC() {
        self.shell?.write(ctrlC) { [unowned self] (error) in
            if let error = error {
                self.appendToTextView("[ERROR] \(error)")
            }
        }

        self.lastCommand = ""
    }

    @objc private func sendTab() {
        let command = lastCommand
        for _ in 0..<self.lastCommand.count {
            self.textView.deleteBackward()
        }
        self.shell?.write(command+tab) { [unowned self] (error) in
            if let error = error {
                self.appendToTextView("[ERROR] \(error)")
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
