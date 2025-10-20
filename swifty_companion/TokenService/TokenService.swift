//
//  TokenService.swift
//  swifty_companion
//
//  Created by Anisa Kapateva on 21.07.2023.
//

import Foundation

class TokenService {
    static var uid: String = {
        let env = EnvironmentLoader.load()
        return env["UID"] ?? ""
    }()
    static var secret: String = {
        let env = EnvironmentLoader.load()
        return env["SECRET"] ?? ""
    }()
}
