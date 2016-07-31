//
//  User.swift
//  MessengerClone
//
//  Created by Chase Wang on 7/30/16.
//  Copyright © 2016 ocwang. All rights reserved.
//

import UIKit

class User: NSObject {
    var username: String
    var name: String
    var userID: Int
    
    init(userID: Int, username: String, name: String) {
        self.userID = userID
        self.username = username
        self.name = name
        super.init()
    }
    
    init(dictionary: [String: AnyObject]) {
        self.username = dictionary["username"] as! String
        self.userID = dictionary["id"] as! Int
        self.name = dictionary["name"] as! String
        super.init()
    }
}
