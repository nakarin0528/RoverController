//
//  DefaultButton.swift
//  RoverClient
//
//  Created by yiheng on 2019/07/27.
//  Copyright © 2019 nakarin. All rights reserved.
//

import Foundation
import Material

final class DefaultButton: Button {


    init(title: String?, titleColor: UIColor? = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), fontSize: CGFloat = 20) {
        super.init(frame: CGRect.zero)
        self.title = title
        self.titleColor = titleColor
        self.titleLabel?.font = .boldSystemFont(ofSize: fontSize)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
