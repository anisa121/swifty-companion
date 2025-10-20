//
//  EnvironmentLoader.swift
//  swifty_companion
//
//  Created by Anisa Kapateva on 31.10.2024.
//

import Foundation

class EnvironmentLoader {
    static func load() -> [String: String] {
        var envDict: [String: String] = [:]
        if let path = Bundle.main.path(forResource: "Config", ofType: "env") {
            do {
                let contents = try String(contentsOfFile: path)
                for line in contents.components(separatedBy: .newlines) {
                    let keyValue = line.components(separatedBy: "=")
                    if keyValue.count == 2 {
                        let key = keyValue[0].trimmingCharacters(in: .whitespaces)
                        let value = keyValue[1].trimmingCharacters(in: .whitespaces)
                        envDict[key] = value
                    }
                }
            } catch {
                print("Error loading Config.env file: \(error)")
            }
        } else {
            print("No Config.env file found.")
        }
        return envDict
    }
}
