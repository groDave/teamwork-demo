//
//  RealmManager.swift
//  TeamworkDemo
//
//  Created by Dave Hannan on 09/10/2017.
//  Copyright © 2017 Gro. All rights reserved.
//

import UIKit
import RealmSwift

class RealmManager: NSObject {
    
    static let shared : RealmManager = {
        let instance = RealmManager()
        return instance
    }()
    
    /** Current logged in User **/
    func user(completion: @escaping(TWUser?, Bool) -> ())
    {
        let realm = try! Realm()
        
        let loggedInUser = realm.objects(TWUser.self).first
        
        if(loggedInUser != nil)
        {
            print("There exists a logged in user - grabbing now...")
            completion(loggedInUser!, true)
            
        } else {
            print("No logged in user exists")
            completion(nil, false)
        }
    }
    
    /** Log user out **/
    func logout(completion: @escaping(Bool)->())
    {
        // a simple logout - I just delete everything from Realm, in this case my TWUser and on completion jump back to the login
        // for a bigger project this would not be as simple - but for this and the fact we'll only ever have one user stored on Realm it will work well
        let realm = try! Realm()
        realm.deleteAll()
        completion(true)
    }

}
