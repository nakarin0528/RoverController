//
//  Constant.swift
//  RoverClient
//
//  Created by yiheng on 2019/07/27.
//  Copyright © 2019 nakarin. All rights reserved.
//

import SwiftyUserDefaults

extension DefaultsKeys {
    static let hostname = DefaultsKey<String?>("hostname")
    static let port = DefaultsKey<Int?>("port")
    static let username = DefaultsKey<String?>("username")
    static let password = DefaultsKey<String?>("password")
}
