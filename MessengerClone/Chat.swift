//
//  Chat.swift
//  MessengerClone
//
//  Created by Chase Wang on 8/9/16.
//  Copyright © 2016 ocwang. All rights reserved.
//

import UIKit

class Chat: NSObject {
    var name: String
    var chatID: Int
    
    init(chatID: Int, name: String) {
        self.chatID = chatID
        self.name = name
        super.init()
    }
    
    init(dictionary: [String: AnyObject]) {
        self.chatID = dictionary["id"] as! Int
        self.name = dictionary["name"] as! String
        super.init()
    }
}
