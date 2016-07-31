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
        
        Alamofire.request(.POST, "http://localhost:4000/api/v1/sessions", parameters: params, encoding: .JSON, headers: nil).responseData { response in
            guard let httpResponse = response.response
                where httpResponse.statusCode == 200
                else { return }
            
            self.performSegueWithIdentifier("toHomeViewController", sender: self)
        }
    }
}
