//
//  KeychainManager.swift
//  swifty_companion
//
//  Created by Anisa Kapateva on 01.03.2024.
//

import Foundation
import KeychainSwift

class KeychainManager {
    static let shared = KeychainManager()
    private let keychain = KeychainSwift()
    private let tokenKey = "tokenData"
    
    func storeToken(tokenModel: AccessTokenModel) {
        let encoder = JSONEncoder();
        do {
            let data = try encoder.encode(tokenModel)
            keychain.set(data, forKey: tokenKey)
            print("New token stored!")
        } catch {
            print("Failed while storing token: \(error.localizedDescription)")
        }
    }
    
    func retrieveToken() -> AccessTokenModel? {
        if let data = keychain.getData(tokenKey) {
            let decoder = JSONDecoder()
            do {
                let model = try decoder.decode(AccessTokenModel.self, from: data)
                return model
            } catch {
                print("Failed while retrieving token: \(error.localizedDescription)")
            }
        }
        return nil
    }
    
    func tokenIsValid() -> Bool {
        if let token = retrieveToken() {
            return token.isValid()
        }
        return false
    }
}


