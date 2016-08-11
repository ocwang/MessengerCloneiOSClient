//
//  APIManager.swift
//  MessengerClone
//
//  Created by Chase Wang on 7/31/16.
//  Copyright © 2016 ocwang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIManager {
    static let baseURL = "https://\(Constant.HerokuDomain)/api/v1"
//    static let baseURL = "http://localhost:4000/api/v1/"
    
    static func POSTLoginUserWithParams(params: [String : String], withCallback callback: (Bool, NSData?) -> Void) {
        Alamofire.request(.POST,
            "\(baseURL)/sessions",
            parameters: params,
            encoding: .JSON,
            headers: nil)
            .responseData { response in
                if let
                    httpResponse = response.response,
                    data = response.data
                    where httpResponse.statusCode == 200 {
                    callback(true, data)
                } else {
                    callback(false, nil)
                }
        }
    }
    
    static func GETChatsForUser(userID: Int, withCallback callback: [Chat] -> Void) {
        Alamofire.request(.GET,
            "\(baseURL)/users/\(userID)/chats",
            parameters: nil,
            encoding: .JSON,
            headers: nil)
            .responseData { response in
                guard let data = response.data
                    else { return }
                
                let json = JSON(data: data)
                guard let chatArray = json["chats"].arrayObject as? [[String : AnyObject]] else {
                    return
                }
                
     
                var chats = [Chat]()
                var temp: Chat
                for chatDict in chatArray {
                    temp = Chat(dictionary: chatDict)
                    chats.append(temp)
                }
                
                callback(chats)
        }
    }
    
    static func GETFriendsForCurrentUser(userID: Int, withCallback callback: [User] -> Void) {
        Alamofire.request(.GET,
            "\(baseURL)/users/\(userID)/friends",
            parameters: nil,
            encoding: .JSON,
            headers: nil)
            .responseData { response in
                guard let data = response.data
                    else { return }
                
                let json = JSON(data: data)
                
                guard let userArray = json.arrayObject as? [NSDictionary]
                    else { return }
                
                var friends = [User]()
                var tempFriend: User
                for userDict in userArray {
                    tempFriend = User(dictionary: userDict as! [String : AnyObject])
                    friends.append(tempFriend)
                }
                
                callback(friends)
        }
    }
    
    static func GETAllUsersWithCompletionHandler(completionHandler: [User] -> Void) {
        Alamofire.request(.GET,
            "\(baseURL)/users",
            parameters: nil,
            encoding: .JSON,
            headers: nil)
            .responseData { response in
                guard let data = response.data
                    else { return }
                
                let json = JSON(data: data)
                
                guard let userArray = json.arrayObject as? [NSDictionary]
                    else { return }
                
                var users = [User]()
                var tempUser: User
                for userDict in userArray {
                    tempUser = User(dictionary: userDict as! [String : AnyObject])
                    users.append(tempUser)
                }
                
                completionHandler(users)
        }
    }
    
    static func POSTNewUserWithParams(params: [String : AnyObject], success: (Bool) -> Void) {
        Alamofire.request(.POST,
            "\(baseURL)/users",
            parameters: params,
            encoding: .JSON,
            headers: nil)
            .responseData { response in
//                guard let data = response.data
//                    else { return }
//                
//                let json = JSON(data: data)
//                
//                guard let userDict = json.dictionaryObject
//                    else { return }
//                
//                let currentUser = User(dictionary: userDict)
                
                guard let httpResponse = response.response
                    where httpResponse.statusCode == 201
                    else {
                        success(false)
                        return
                    }
                
                success(true)
        }
    }
}