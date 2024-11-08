//
//  NetworkService.swift
//  SevenWindsStudioApp
//
//  Created by Ваня Сокол on 30.10.2024.
//

import UIKit
import Alamofire

final class NetworkService {
    
    static let shared = NetworkService()
    
    private let jsonDecoder = JSONDecoder()
    private let baseUrlString = URLStrings.base
    private let cache = NSCache<NSString, UIImage>()
    
    private init() { }
    
    public func register(with email: String,
                         and password: String,
                         completion: @escaping (Result<Login, Error>) -> Void) {
        let path = URLStrings.registerPath
        let urlString = baseUrlString + path
        
        let parameters = [
            "login": email,
            "password": password
        ]
        
        AF.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .response { response in
                if let error = response.error {
                    completion(.failure(error))
                    return
                }
                
                if let data = response.data {
                    if let content = try? self.jsonDecoder.decode(Login.self, from: data) {
                        DispatchQueue.main.async {
                            completion(.success(content))
                        }
                    }
                }
            }
    }
    
    
    public func login(with email: String, 
                      and password: String,
                      completion: @escaping (Result<Login, Error>) -> Void) {
        let path = URLStrings.loginPath
        let urlString = baseUrlString + path
        
        let parameters = [
            "login": email,
            "password": password
        ]
        
        AF.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .response { response in
                if let error = response.error {
                    completion(.failure(error))
                    return
                }
                
                if let data = response.data {
                    if let content = try? self.jsonDecoder.decode(Login.self, from: data) {
                        DispatchQueue.main.async {
                            completion(.success(content))
                        }
                        print(content.token)
                    }
                }
            }
    }
    
    
    public func getLocations(with token: String, completion: @escaping (Result<[Location], any Error>) -> Void) {
        let path = URLStrings.locationPath
        let urlString = baseUrlString + path
        
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        
        AF.request(urlString, method: .get, headers: headers)
            .response { response in
                if let statusCode = response.response?.statusCode,
                   statusCode > 300 {
                    completion(.failure(CoffeError.tokenExpired))
                    return
                }
                
                if let data = response.data {
                    if let content = try? self.jsonDecoder.decode([Location].self, from: data) {
                        DispatchQueue.main.async {
                            completion(.success(content))
                        }
                    }
                }
            }
    }
    
    
    public func getMenu(with token: String, for id: Int, completion: @escaping (Result<[MenuItem], any Error>) -> Void) {
        let path = URLStrings.getMenuPath(id: id)
        let urlString = baseUrlString + path
        
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        
        AF.request(urlString, method: .get, headers: headers)
            .response { response in
                if let statusCode = response.response?.statusCode,
                   statusCode > 300 {
                    completion(.failure(CoffeError.tokenExpired))
                    return
                }
                
                if let data = response.data {
                    if let content = try? self.jsonDecoder.decode([MenuItem].self, from: data) {
                        DispatchQueue.main.async {
                            completion(.success(content))
                        }
                        
                    }
                }
            }
    }
    
    public func downloadImage(from urlString: String, completion: @escaping (UIImage) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completion(image)
            return
        }
        
        AF.request(urlString)
            .validate()
            .response { response in
                if let data = response.data,
                   let image = UIImage(data: data, scale: 0.1) {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            }
    }
}
