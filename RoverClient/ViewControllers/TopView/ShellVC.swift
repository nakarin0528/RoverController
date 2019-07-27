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

class ShellVC: UIViewController {

    var disposeBag = DisposeBag()
    var shell: Shell?

    private let textfield: UITextField = {
        let textfield = UITextField()
        textfield.font = UIFont.systemFont(ofSize: 20)
        textfield.placeholder = "コマンドを入力"
        textfield.borderStyle = .roundedRect
        textfield.autocapitalizationType = .none
        return textfield
    }()

    private let sendButton: Button = {
        let btn = Button()
        btn.title = "send"
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        btn.titleColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btn.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        btn.layer.cornerRadius = 20
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = #colorLiteral(red: 0.3333333333, green: 0.7294117647, blue: 0.6745098039, alpha: 1)

        self.bind()
        self.open()
        self.setupViews()
    }

    func bind() {
        sendButton.rx.tap
            .subscribe(onNext: {
                if let text = self.textfield.text {
                    self.sendCommand(command: text)
                }
                self.textfield.text = ""
            })
            .disposed(by: disposeBag)

    }

    private func setupViews() {
        self.view.addSubview(textfield)
        textfield.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.right.equalToSuperview().inset(100)
            $0.height.equalTo(40)
        }

        self.view.addSubview(sendButton)
        sendButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(textfield.snp.bottom).offset(20)
            $0.width.equalTo(110)
            $0.height.equalTo(40)
        }
    }

    private func open() {
        shell = Shell(host: "raspberrypi.local", port: 22)

        guard let shell = shell else { return }
        shell.log.enabled = true
        


        shell.withCallback { (string: String?, error: String?) in
            print("\(string ?? error!)")
            }
            .connect()
            .authenticate(.byPassword(username: "pi", password: "raspberry"))
            .open { (error) in
                if let error = error {
                    print("\(error)")
                }
        }
    }

    private func sendCommand(command: String) {
        guard let shell = shell else { return }
        shell.write(command) { error in
            if let error = error {
                print("\(error)")
            }
        }
    }

    private func disconnect() {
        guard let shell = shell else { return }
        shell.disconnect {
            print("disconnected!")
        }
    }
}

