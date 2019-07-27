//
//  HeaderView.swift
//  RoverClient
//
//  Created by yiheng on 2019/07/27.
//  Copyright © 2019 nakarin. All rights reserved.
//

import UIKit
import SnapKit

final class HeaderView: UIView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = .boldSystemFont(ofSize: DeviceSize.type() == .iPhone ? 20 : 40 )
        label.textColor = .white
        return label
    }()

    init(title: String = "") {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.app.aresRed
        titleLabel.text = title
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
        }
    }
}
