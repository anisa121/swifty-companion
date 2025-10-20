//
//  UserModelDTO.swift
//  swifty_companion
//
//  Created by Anisa Kapateva on 24.04.2024.
//

import Foundation

struct UserModelDTO: Decodable {
    let id: Int
    let email: String
    let login: String
    let displayname: String
    let image: ImageStruct
    
    struct ImageStruct: Decodable {
        let link: String?
        let versions: ImgVersions
        struct ImgVersions: Decodable {
            let large: String?
            let medium: String?
            let small: String?
        }
    }
}
