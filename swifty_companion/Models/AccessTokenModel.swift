//
//  AccessTokenModel.swift
//  swifty_companion
//
//  Created by Anisa Kapateva on 07.08.2023.
//

import Foundation

struct AccessTokenModel: Codable {
    let access_token: String
    let token_type: String
    let expires_in: Int
    let scope: String
    let created_at: Int
    
    func isValid() -> Bool {
        let stamp = Double(expires_in + created_at)
        let interval = Date(timeIntervalSince1970: TimeInterval(stamp))
        let currentDate = Date()
        print("IS VALID ")
        print(interval > currentDate)
        print("Time left for current token: \(Int(interval.timeIntervalSince(currentDate) / 60)) mins")
        return interval > currentDate
    }
}
