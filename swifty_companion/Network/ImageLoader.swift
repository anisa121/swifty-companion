//
//  ImageLoader.swift
//  swifty_companion
//
//  Created by Anisa Kapateva on 30.10.2024.
//

import UIKit
import Foundation

class ImageLoader {
    private let session: URLSession
    
    init() {
        let cacheSizeMemory = 20 * 1024 * 1024
        let cacheSizeDick = 100 * 1024 * 1024
        let urlCache = URLCache(memoryCapacity: cacheSizeMemory, diskCapacity: cacheSizeDick)
        
        let configuartion = URLSessionConfiguration.default
        configuartion.urlCache = urlCache
        configuartion.requestCachePolicy = .returnCacheDataElseLoad
        self.session = URLSession(configuration: configuartion)
    }
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) -> Void {
        var cleanedImageUrl = urlString.replacingOccurrences(of: "\\/", with: "/")
        cleanedImageUrl = "uploads/achievement/image/40/SCO001.svg"
        let fullURL = DefaultData.baseURL + cleanedImageUrl
        print("FULL URL   - \(fullURL)")
        guard let url = URL(string: fullURL) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        if let token = KeychainManager.shared.retrieveToken() {
            request.addValue("Bearer \(token.access_token)", forHTTPHeaderField: "Authorization")
        }
        
        if let cachedResponce = session.configuration.urlCache?.cachedResponse(for: request) {
            let image = UIImage(data: cachedResponce.data)
            DispatchQueue.main.async {
                completion(image)
            }
            return
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                    DispatchQueue.main.async { completion(nil) }
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                // Check for HTTP response and status code
            guard let httpResponse = response as? HTTPURLResponse else {
                    DispatchQueue.main.async { completion(nil) }
                    print("Invalid response")
                    return
                }

                // Check if the status code indicates an error
                if httpResponse.statusCode != 200 {
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("Error response: \(responseString)")
                    }
                    DispatchQueue.main.async { completion(nil) }
                    return
                }
            
            // mine !
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            // store responce to cache for the particular request
            if let responce = response {
                let cachedData = CachedURLResponse(response: responce, data: data)
                self.session.configuration.urlCache?.storeCachedResponse(cachedData, for: request)
            }
            // send image to caller
            DispatchQueue.main.async {
                completion(image)
            }
        }
        task.resume()
    }
    
}
