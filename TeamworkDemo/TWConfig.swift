//
//  TWConfig.swift
//  TeamworkDemo
//
//  Created by Dave Hannan on 08/10/2017.
//  Copyright © 2017 Gro. All rights reserved.
//

import UIKit

class TWConfig: NSObject {
    
    var configDictionary : NSDictionary?
    var endpointsDictionary : NSDictionary?
    
    static let shared : TWConfig =
    {
        let instance = TWConfig()
        return instance
    }()
    
    override init() {
        if let path = Bundle.main.path(forResource: "config", ofType: "plist"){
            configDictionary = NSDictionary.init(contentsOfFile: path)
            endpointsDictionary = configDictionary?["endpoints"] as? NSDictionary
        }
    }
    
    
    /** Endpoints **/
    
    func auth() -> String
    {
        return (endpointsDictionary!["auth"] as? String)!
    }
    
    func projects() -> String
    {
        return (endpointsDictionary!["projects"] as? String)!
    }
    
    func tasks(projectID: String) -> String
    {
        return "https://yat.teamwork.com/projects/\(projectID)/tasks.json"
    }

}
