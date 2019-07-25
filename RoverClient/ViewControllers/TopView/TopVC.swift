//
//  ViewController.swift
//  RoverClient
//
//  Created by yiheng on 2019/07/25.
//  Copyright © 2019 nakarin. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import ReactorKit
import SwiftSH

class TopVC: UIViewController, StoryboardView {

    private let reactor = TopViewReactor()
    var disposeBag = DisposeBag()
    var shell: Shell?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = #colorLiteral(red: 0.3333333333, green: 0.7294117647, blue: 0.6745098039, alpha: 1)

        self.bind(reactor: reactor)
        self.open()
    }

    func bind(reactor: TopViewReactor) {

    }

    private func open() {
        shell = Shell(host: "raspberry.local", port: 22)

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

