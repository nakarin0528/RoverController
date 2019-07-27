//
//  SSHVCProtocol.swift
//  RoverClient
//
//  Created by yiheng on 2019/07/27.
//  Copyright © 2019 nakarin. All rights reserved.
//

import Foundation

protocol SSHViewController: class {
    var requiresAuthentication: Bool { get set }
    var hostname: String! { get set }
    var port: UInt16? { get set }
    var username: String! { get set }
    var password: String? { get set }
}
