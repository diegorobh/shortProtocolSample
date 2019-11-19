//
//  WTRequest.swift
//  protocol_test
//
//  Created by diego paredes on 18/11/19.
//  Copyright © 2019 Diego Paredes. All rights reserved.
//

import UIKit
import Foundation

struct WTError {
    let errorDescription: String
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

enum Result<T> {
    case success(T)
    case failure(WTError)
}

class WTRequest {
    
    static let shared = WTRequest()
    private let session = URLSession(configuration: .default)
    
    func get<T: Decodable>(url: String, accesstoken: String = "", type: T.Type, completion: @escaping (Result<T>, Int) -> ()) {
        request(url: url, parameters: nil, method: .get, accesstoken: accesstoken,  completion: completion)
    }
    
    func post<T: Decodable>(url: String, accesstoken: String = "", type: T.Type, parameters: [String:Any]?, completion: @escaping (Result<T>,Int) -> ()) {
        request(url: url, parameters: parameters, method: .post, accesstoken: accesstoken, completion: completion)
    }
    
    func put<T: Decodable>(url: String, accesstoken: String = "", type: T.Type, parameters: [String:Any]?, completion: @escaping (Result<T>,Int) -> ()) {
        request(url: url, parameters: parameters, method: .put, accesstoken: accesstoken, completion: completion)
    }
    
    private func request<T: Decodable>(url: String, bodyType: String = "application/json",  parameters: [String:Any]?, method: HTTPMethod, accesstoken:String = "" , completion: @escaping (Result<T>, Int) -> Void) {
        guard let url = URL(string: url) else {
            let customError = WTError(errorDescription: "Invalid url specified.")
            completion(.failure(customError),9)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let parameters = parameters {
            if let data = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) {
                request.httpBody = data
            }
        }
        print("parameters down")
        print(parameters)
        switch bodyType {
        case "x-www-form-urlencoded":
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        default:
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        
        if accesstoken != "" {
            request.setValue("Bearer \(accesstoken)", forHTTPHeaderField: "Authorization")
        }
        session.dataTask(with: request){ (data, response, error) in
            let httpResponse = response as! HTTPURLResponse
            if let error = error {
                let customError = WTError(errorDescription: error.localizedDescription)
                completion(.failure(customError),httpResponse.statusCode)
            }else if let data = data {
                if httpResponse.statusCode >= 200 && httpResponse.statusCode < 400 {
                    do {
                        let decoder = JSONDecoder()
                        let json = try decoder.decode(T.self, from: data)
                        completion(.success(json), httpResponse.statusCode)
                    }catch {
                        let customError = WTError(errorDescription: "Oops! Not was possible decode.")
                        completion(.failure(customError),httpResponse.statusCode)
                    }
                }else{
                    let customError = WTError(errorDescription: "Oops! Server Error.")
                    completion(.failure(customError),httpResponse.statusCode)
                }
            }else{
                let customError = WTError(errorDescription: "Oops! Not was posible get data.")
                completion(.failure(customError),httpResponse.statusCode)
            }
            }.resume()
    }
}



