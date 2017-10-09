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
import RealmSwift

class ApiConfig: NSObject {
    
    static let shared : ApiConfig =
    {
        let instance = ApiConfig()
        return instance
    }()
    
    
    /** USER FUNCTIONS**/
    
    //AUTH
    //input can be email or api key - for purpose of demo I will autocomplete with email
    func authUser(input: String, completion: @escaping (Bool) -> ())
    {
//        let user = input
//        let password = "xxx"
//        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
//        let base64Credentials = credentialData.base64EncodedString(options: [])
//        let headers = ["Authorization": "Basic \(base64Credentials)"]
//        print(headers)
        
        Alamofire.request(TWConfig.shared.auth(),
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers:self.createAuthHeader(input: input))
            .validate()
            .responseJSON { response in
                switch(response.result){
                case .success(let value):
                    
                    let json = JSON(value)
                    print("JSON: \(json)")
                    if(self.isSuccessfulResponse(json: json)){
                        if(self.createTeamworkUserFromJson(json: json, apiKey: input)){
                            completion(true)
                        } else {
                            completion(false)
                        }
                    } else {
                        completion(false)
                    }
                case .failure(let error):
                    print(error)
                    completion(false)
                    break
                }
        }
    }
    
    //CREATE USER FROM JSON
    private func createTeamworkUserFromJson(json: JSON, apiKey: String) -> (Bool)
    {
        let accountDict = json["account"]
        
        let twUser = TWUser.init(userDict: accountDict)
        twUser.apiKey = apiKey
        let realm = try! Realm()
        try! realm.write({
            print("Creating realm user")
            realm.add(twUser, update:true)
        })
        
        let storedUser = realm.object(ofType: TWUser.self, forPrimaryKey: twUser.userId)
        
        if(storedUser != nil){
            print("realmuser exists")
            return true
        } else {
            print("realmuser was not created")
            return false
        }
    }
    
    
    /** PROJECT FUNCTIONS **/
    
    func projectsForUser(completion: @escaping(Array<TWProject>?, Bool) -> ())
    {
        RealmManager.shared.user { (user, bool) in
            if(bool){
                let projectsURL = user!.URL + TWConfig.shared.projects()
                Alamofire.request(projectsURL,
                                  method: .get,
                                  parameters: nil,
                                  encoding: JSONEncoding.default,
                                  headers:self.createAuthHeader(input: user!.apiKey))
                    .validate()
                    .responseJSON { response in
                        switch(response.result){
                        case .success(let value):
                            
                            let json = JSON(value)
                            print("JSON: \(json)")
                            if(self.isSuccessfulResponse(json: json)){
                                let projects = self.createProjectsFromJSON(json: json)
                                if(projects.count > 0){
                                    completion(projects, true)
                                } else {
                                    completion(nil, false)
                                }
                                
                            } else {
                                completion(nil, false)
                            }
                            
                            
                            break
                        case .failure(let error):
                            print(error)
                            completion(nil, false)
                            break
                        }
                }
                
                
            } else {
                print("No user was returned")
                completion(nil, false)
            }
        }
    }
    
    private func createProjectsFromJSON(json: JSON) -> Array<TWProject>{
        var projects : Array<TWProject> = []
        
        let projectArray = json["projects"].arrayValue
        
        for i in 0 ..< projectArray.count
        {
            let dict = projectArray[i].dictionaryValue
            
            let project = TWProject()
            project.starred = (dict["starred"]?.bool)!
            project.status = (dict["status"]?.stringValue)!
            project.createdOn = (dict["created-on"]?.stringValue)!
            project.logoUrl = (dict["logo"]?.stringValue)!
            project.startDate = (dict["startDate"]?.stringValue)!
            project.id = (dict["id"]?.stringValue)!
            project.lastChangedOn = (dict["last-changed-on"]?.stringValue)!
            project.endDate = (dict["endDate"]?.stringValue)!
            project.name = (dict["name"]?.stringValue)!
            project.projectDescription = (dict["description"]?.stringValue)!
            
            projects.append(project)
        }
        
        return projects
        
    }
    
    
    
    
    
    /** MISC **/
    
    private func isSuccessfulResponse(json: JSON)->Bool
    {
        if json["STATUS"].string == "OK"
        {
            return true
        } else {
            return false
        }
    }
    
    private func createAuthHeader(input: String) -> Dictionary<String, String>
    {
        let user = input
        let password = "xxx"
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        print(headers)
        
        return headers
    }
}
