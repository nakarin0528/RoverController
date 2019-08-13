//
//  DeviceSize.swift
//  RoverClient
//
//  Created by yiheng on 2019/07/28.
//  Copyright © 2019 nakarin. All rights reserved.
//

import UIKit

//TODO: リファクタリング、暫定

struct DeviceSize {
    static func type() -> DeviceType {
        let nativeWidth = UIScreen.main.nativeBounds.size.width

        switch nativeWidth {
//        case 640:
//            return iPhoneType.iPhoneSE
//        case 750:
//            return iPhoneType.iPhone8
//        case 1080, 1242:
//            return iPhoneType.iPhone8Plus
        case 0 ..< 1243:
            return DeviceType.iPhone
        default:
            return DeviceType.other
        }
    }
}

enum DeviceType {
//    case iPhoneSE
//    case iPhone8
//    case iPhone8Plus
//    case iPhoneX
    case iPhone
    case other
}

