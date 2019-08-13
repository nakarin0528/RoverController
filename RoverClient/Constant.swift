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
    static let upCommand1 = DefaultsKey<String?>("upCommand1")
    static let upCommand2 = DefaultsKey<String?>("upCommand2")
    static let downCommand1 = DefaultsKey<String?>("downCommand1")
    static let downCommand2 = DefaultsKey<String?>("downCommand2")
    static let leftCommand1 = DefaultsKey<String?>("leftCommand1")
    static let leftCommand2 = DefaultsKey<String?>("leftCommand2")
    static let rightCommand1 = DefaultsKey<String?>("rightCommand1")
    static let rightCommand2 = DefaultsKey<String?>("rightCommand2")
    static let ACommand1 = DefaultsKey<String?>("ACommand1")
    static let ACommand2 = DefaultsKey<String?>("ACommand2")
    static let BCommand1 = DefaultsKey<String?>("BCommand1")
    static let BCommand2 = DefaultsKey<String?>("BCommand2")
    static let XCommand1 = DefaultsKey<String?>("XCommand1")
    static let XCommand2 = DefaultsKey<String?>("XCommand2")
    static let YCommand1 = DefaultsKey<String?>("YCommand1")
    static let YCommand2 = DefaultsKey<String?>("YCommand2")
    static let startCommand1 = DefaultsKey<String?>("startCommand1")
    static let startCommand2 = DefaultsKey<String?>("startCommand2")
    static let selectCommand1 = DefaultsKey<String?>("selectCommand1")
    static let selectCommand2 = DefaultsKey<String?>("selectCommand2")
}

let ctrlC: String = "\u{3}"
let tab: String = "\t"
let del: String = "\u{7f}"
