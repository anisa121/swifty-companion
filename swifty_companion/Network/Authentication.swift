//
//  Authentication.swift
//  swifty_companion
//
//  Created by Anisa Kapateva on 14.08.2023.
//

import Foundation
import Alamofire
import UIKit

struct DefaultData {
    static var tokenUrl = "https://api.intra.42.fr/oauth/token"
    static var baseURL = "https://api.intra.42.fr/v2/"
    static var parametrs = [
        "grant_type" : "client_credentials",
        "client_id" : TokenService.uid,
        "client_secret" : TokenService.secret
    ]
}

enum Result {
    case success
    case error
}

class Authentication {
    static let shared = Authentication()
    
    func requestToken() async -> () {
        print("ENV UID AND SECRET RETRIEVED \(DefaultData.parametrs)")
        let backgroundThread = DispatchQueue(label: "retrieve_token_background", qos: .background)
        if (!KeychainManager.shared.tokenIsValid()) {
            AF.request(DefaultData.tokenUrl, method: .post, parameters:DefaultData.parametrs, encoder: .json).responseDecodable(of: AccessTokenModel.self, queue: backgroundThread, completionHandler: { responce in
                print(responce)
                switch responce.result {
                case .success(let model):
                    print("NEW ONE\n")
                    print(model.access_token)
                    DispatchQueue.main.async {
                        KeychainManager.shared.storeToken(tokenModel: model)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print("Failed while requesting token and decode into model: \(error.localizedDescription)")
                    }
                }
            })
        } else {
            print("\(KeychainManager.shared.retrieveToken())")
        }
    }
        
    func fetchUserLogin<T: Decodable>(user login: String, responceType: T.Type, completion: @escaping (Swift.Result<T, Error>) -> Void) {
        let userFetchUrl = DefaultData.baseURL + login
        guard let tokenModel: AccessTokenModel = KeychainManager.shared.retrieveToken() else {
            print("error! the program couldn't retrieve token while fetching info!")
            return
        }
        
        let headers: HTTPHeaders = ["Authorization" : "Bearer \(tokenModel.access_token)"]
        print(tokenModel.access_token)
        let backgroundThread = DispatchQueue(label: "fetch_user_background", qos: .background)
        AF.request(userFetchUrl, method: .get, headers: headers).responseDecodable(
            of: responceType, queue: backgroundThread, completionHandler: { responce in
                switch responce.result {
                case .success(let model):
                    if let modelArr = model as? [UserModelDTO], !modelArr.isEmpty {
                        completion(.success(model))
                    } else if let model2 = model as? UserInfoDTO {
                        completion(.success(model))
                    } else {
                        let err = NSError(domain: "d", code: 0)
                        print("Error while recognition T.type of modelDTO")
                        print(err.localizedDescription)
                        completion(.failure(err))
                    }
                    print(model)
                case .failure(let error):
                    completion(.failure(error))
                    print("Error while request API, respond failure!")
                    print(error.localizedDescription)
                }
        })
    }
    
}
