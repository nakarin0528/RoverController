//
//  ControllerView.swift
//  RoverClient
//
//  Created by yiheng on 2019/08/10.
//  Copyright © 2019 nakarin. All rights reserved.
//

import Foundation
import UIKit
import Material

final class ControllerView: UIView {

    let upButton: Button = {
        let button = Button()
        button.image = UIImage(named: "up")?.tint(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        button.layer.cornerRadius = DeviceSize.type() == .iPhone ? 30 : 40
        return button
    }()

    let rightButton: Button = {
        let button = Button()
        let image = UIImage(named: "up")?.tint(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        button.image = image?.rotatedBy(degree: 90)
        button.layer.cornerRadius = DeviceSize.type() == .iPhone ? 30 : 40
        return button
    }()

    let downButton: Button = {
        let button = Button()
        let image = UIImage(named: "up")?.tint(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        button.image = image?.rotatedBy(degree: 180)
        button.layer.cornerRadius = DeviceSize.type() == .iPhone ? 30 : 40
        return button
    }()

    let leftButton: Button = {
        let button = Button()
        let image = UIImage(named: "up")?.tint(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        button.image = image?.rotatedBy(degree: -90)
        button.layer.cornerRadius = DeviceSize.type() == .iPhone ? 30 : 40
        return button
    }()

    let ALabel: UILabel = {
        let label = UILabel()
        label.text = "A"
        label.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        label.font = .boldSystemFont(ofSize: 28)
        label.sizeToFit()
        return label
    }()

    let Abutton: Button = {
        let button = Button()
        button.backgroundColor = #colorLiteral(red: 0.952875793, green: 0.1572520137, blue: 0.2038589418, alpha: 1)
        button.layer.cornerRadius = DeviceSize.type() == .iPhone ? 30 : 40
        return button
    }()

    let BLabel: UILabel = {
        let label = UILabel()
        label.text = "B"
        label.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        label.font = .boldSystemFont(ofSize: 28)
        label.sizeToFit()
        return label
    }()

    let Bbutton: Button = {
        let button = Button()
        button.backgroundColor = #colorLiteral(red: 0.9309442639, green: 0.697024405, blue: 0.128515929, alpha: 1)
        button.layer.cornerRadius = DeviceSize.type() == .iPhone ? 30 : 40
        return button
    }()

    let XLabel: UILabel = {
        let label = UILabel()
        label.text = "X"
        label.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        label.font = .boldSystemFont(ofSize: 28)
        label.sizeToFit()
        return label
    }()

    let Xbutton: Button = {
        let button = Button()
        button.backgroundColor = #colorLiteral(red: 0.2481678128, green: 0.3294503093, blue: 0.974573791, alpha: 1)
        button.layer.cornerRadius = DeviceSize.type() == .iPhone ? 30 : 40
        return button
    }()

    let YLabel: UILabel = {
        let label = UILabel()
        label.text = "Y"
        label.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        label.font = .boldSystemFont(ofSize: 28)
        label.sizeToFit()
        return label
    }()

    let Ybutton: Button = {
        let button = Button()
        button.backgroundColor = #colorLiteral(red: 0.1539357901, green: 0.6113597751, blue: 0.1536458731, alpha: 1)
        button.layer.cornerRadius = DeviceSize.type() == .iPhone ? 30 : 40
        return button
    }()

    let selectButton: Button = {
        let button = Button()
        button.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        button.layer.cornerRadius = 8
        button.transform = CGAffineTransform(rotationAngle: CGFloat(3*Double.pi/4))
        return button
    }()

    let selectLabel: UILabel = {
        let label = UILabel()
        label.text = "select"
        label.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        label.font = .boldSystemFont(ofSize: 20)
        label.sizeToFit()
        return label
    }()

    let startButton: Button = {
        let button = Button()
        button.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        button.layer.cornerRadius = 8
        button.transform = CGAffineTransform(rotationAngle: CGFloat(3*Double.pi/4))
        return button
    }()

    let startLabel: UILabel = {
        let label = UILabel()
        label.text = "start"
        label.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        label.font = .boldSystemFont(ofSize: 20)
        label.sizeToFit()
        return label
    }()

    let modeButton: Button = {
        let button = Button()
        button.title = "Operation mode"
        button.titleColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        button.backgroundColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 15
        return button
    }()

    init() {
        super.init(frame: .zero)
        self.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.isHidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        addSubview(upButton)
        upButton.snp.makeConstraints {
            if DeviceSize.type() == .iPhone {
                $0.left.equalToSuperview().offset(120)
                $0.centerY.equalToSuperview().offset(-layer.height/7)
                $0.size.equalTo(60)
            } else {
                $0.left.equalToSuperview().inset(150)
                $0.bottom.equalToSuperview().inset(250)
                $0.size.equalTo(80)
            }
        }

        addSubview(leftButton)
        leftButton.snp.makeConstraints {
            $0.top.equalTo(upButton.snp.bottom)
            $0.right.equalTo(upButton.snp.left).offset(-10)
            if DeviceSize.type() == .iPhone {
                $0.size.equalTo(60)
            } else {
                $0.size.equalTo(80)
            }
        }

        addSubview(downButton)
        downButton.snp.makeConstraints {
            $0.top.equalTo(leftButton.snp.bottom).offset(10)
            $0.centerX.equalTo(upButton)
            if DeviceSize.type() == .iPhone {
                $0.size.equalTo(60)
            } else {
                $0.size.equalTo(80)
            }
        }

        addSubview(rightButton)
        rightButton.snp.makeConstraints {
            $0.top.equalTo(upButton.snp.bottom)
            $0.left.equalTo(upButton.snp.right).offset(10)
            if DeviceSize.type() == .iPhone {
                $0.size.equalTo(60)
            } else {
                $0.size.equalTo(80)
            }
        }

//        addSubview(tailLabel)
//        tailLabel.snp.makeConstraints {
//            $0.left.equalTo(leftButton)
//            $0.bottom.equalTo(upButton.snp.top).offset(-30)
//        }

        addSubview(Xbutton)
        Xbutton.snp.makeConstraints {
            if DeviceSize.type() == .iPhone {
                $0.right.equalToSuperview().inset(120)
                $0.centerY.equalToSuperview().offset(-layer.height/7)
                $0.size.equalTo(60)
            } else {
                $0.right.equalToSuperview().inset(150)
                $0.bottom.equalToSuperview().inset(250)
                $0.size.equalTo(80)
            }
        }

        addSubview(XLabel)
        XLabel.snp.makeConstraints {
            $0.left.equalTo(Xbutton.snp.right).offset(5)
            $0.bottom.equalTo(Xbutton.snp.top).offset(-5)
        }

        addSubview(Ybutton)
        Ybutton.snp.makeConstraints {
            $0.top.equalTo(Xbutton.snp.bottom)
            $0.right.equalTo(Xbutton.snp.left).offset(-10)
            if DeviceSize.type() == .iPhone {
                $0.size.equalTo(60)
            } else {
                $0.size.equalTo(80)
            }
        }

        addSubview(YLabel)
        YLabel.snp.makeConstraints {
            $0.right.equalTo(Ybutton.snp.left).offset(-5)
            $0.top.equalTo(Ybutton.snp.bottom).offset(5)
        }

        addSubview(Bbutton)
        Bbutton.snp.makeConstraints {
            $0.top.equalTo(Ybutton.snp.bottom).offset(10)
            $0.centerX.equalTo(Xbutton)
            if DeviceSize.type() == .iPhone {
                $0.size.equalTo(60)
            } else {
                $0.size.equalTo(80)
            }
        }

        addSubview(BLabel)
        BLabel.snp.makeConstraints {
            $0.right.equalTo(Bbutton.snp.left).offset(-5)
            $0.top.equalTo(Bbutton.snp.bottom).offset(5)
        }

        addSubview(Abutton)
        Abutton.snp.makeConstraints {
            $0.top.equalTo(Xbutton.snp.bottom)
            $0.left.equalTo(Xbutton.snp.right).offset(10)
            if DeviceSize.type() == .iPhone {
                $0.size.equalTo(60)
            } else {
                $0.size.equalTo(80)
            }
        }

        addSubview(ALabel)
        ALabel.snp.makeConstraints {
            $0.left.equalTo(Abutton.snp.right).offset(5)
            $0.bottom.equalTo(Abutton.snp.top).offset(-5)
        }

        addSubview(startButton)
        startButton.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.width.equalTo(45)
            $0.centerX.equalToSuperview().offset(30)
            $0.centerY.equalTo(leftButton).offset(50)
        }

        addSubview(startLabel)
        startLabel.snp.makeConstraints {
            $0.centerX.equalTo(startButton)
            $0.top.equalTo(startButton.snp.bottom).offset(10)
        }

        addSubview(selectButton)
        selectButton.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.width.equalTo(45)
            $0.centerX.equalToSuperview().offset(-30)
            $0.centerY.equalTo(leftButton).offset(50)
        }

        addSubview(selectLabel)
        selectLabel.snp.makeConstraints {
            $0.centerX.equalTo(selectButton)
            $0.top.equalTo(selectButton.snp.bottom).offset(10)
        }

        addSubview(modeButton)
        modeButton.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.width.equalTo(200)
            $0.top.equalToSuperview().inset(15)
            $0.centerX.equalToSuperview()
        }
    }
}

