//
//  HomeViewController.swift
//  MessengerClone
//
//  Created by Chase Wang on 7/30/16.
//  Copyright © 2016 ocwang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeViewController: UIViewController {

    var friends = [User]()
    
    @IBOutlet weak var tableView: UITableView!
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        Alamofire.request(.GET,
            "http://localhost:4000/api/v1/users",
            parameters: nil,
            encoding: .JSON,
            headers: nil)
            .responseData { response in
                guard let data = response.data
                    else { return }
                
                let json = JSON(data: data)
                
                guard let userArray = json.arrayObject as? [NSDictionary]
                    else { return }
                
                var friend: User
                for userDict in userArray {
                    friend = User(dictionary: userDict as! [String : AnyObject])
                    self.friends.append(friend)
                }
                self.tableView.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell")!
        
        let friend = friends[indexPath.row]
        cell.textLabel?.text = friend.username
        
        return cell
    }
}
