//
//  LoginViewController.swift
//  MessengerClone
//
//  Created by Chase Wang on 7/29/16.
//  Copyright © 2016 ocwang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {

    // MARK: - Instance Vars
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        // TODO: - Add Form Validation
        guard let
            username = usernameTextField.text,
            password = passwordTextField.text
            else { return }
        
        let params = ["username" : username,
                      "password" : password]
        
        APIManager.POSTLoginUserWithParams(params) { (success, data) in
            guard let data = data
                where success
                else { return }
            
            let json = JSON(data: data)
            
            guard let userDict = json.dictionaryObject else { return }

            User.currentUser = User(dictionary: userDict)
            
            self.performSegueWithIdentifier("toHomeViewController", sender: self)
        }
    }
}
