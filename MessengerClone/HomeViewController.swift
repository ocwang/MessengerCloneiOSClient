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
    
    var chats = [Chat]()
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        APIManager.GETChatsForUser(19) {
            self.chats = $0
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell")!
        
        let chat = chats[indexPath.row]
        cell.textLabel?.text = chat.name
        
        return cell
    }
}

// MARK: - Navigation

extension HomeViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier
            where identifier == "toChat"
            else { return }
        
        guard let indexPath = tableView.indexPathForSelectedRow
            else { return }
        
        let vc = segue.destinationViewController as! ViewController
        vc.chat = chats[indexPath.row]
    }
}