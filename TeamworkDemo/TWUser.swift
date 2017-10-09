//
//  TWUser.swift
//  TeamworkDemo
//
//  Created by Dave Hannan on 09/10/2017.
//  Copyright © 2017 Gro. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON

class TWUser: Object {

    dynamic var userId = ""
    dynamic var firstName = ""
    dynamic var lastname = ""
    dynamic var avatarUrl = ""
    dynamic var companyid = ""
    dynamic var companyname = ""
    dynamic var URL = ""
    dynamic var apiKey = ""
    
    override static func primaryKey() -> String?
    {
        return "userId"
    }
    
    convenience init(userDict: JSON) {
        self.init()
        self.userId = userDict["userId"].stringValue
        self.firstName = userDict["firstname"].stringValue
        self.lastname = userDict["lastname"].stringValue
        self.avatarUrl = userDict["avatar-url"].stringValue
        self.companyid = userDict["companyid"].stringValue
        self.companyname = userDict["companyname"].stringValue
        self.URL = userDict["URL"].stringValue
        
    }
    
    
}
