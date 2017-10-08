//
//  ApiConfig.swift
//  TeamworkDemo
//
//  Created by Dave Hannan on 08/10/2017.
//  Copyright © 2017 Gro. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ApiConfig: NSObject {
    
    static let shared : ApiConfig =
    {
        let instance = ApiConfig()
        return instance
    }()
    
    
    //input can be email or api key - for purpose of demo I will autocomplete with email
    func authUser(input: String, completion: @escaping (Bool) -> ())
    {
        let user = input
        let password = "xxx"
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        print(headers)
        
        Alamofire.request(TWConfig.shared.auth(),
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers:headers)
            .validate()
            .responseJSON { response in
                switch(response.result){
                case .success(let value):
                    
                    let json = JSON(value)
                    print("JSON: \(json)")
                    completion(true)
                    
                case .failure(let error):
                    print(error)
                    completion(false)
                    break
                }
        }
    }
}
