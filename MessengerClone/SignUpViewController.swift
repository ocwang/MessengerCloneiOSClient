//
//  SignUpViewController.swift
//  MessengerClone
//
//  Created by Chase Wang on 7/29/16.
//  Copyright © 2016 ocwang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func signUpButtonTapped(sender: AnyObject) {
        // TODO: - Add Form Validation
        guard let username = usernameTextField.text,
            name = nameTextField.text,
            password = passwordTextField.text
            else { return }
        
        let params = ["username" : username,
                      "password" : password,
                      "name" : name]
        
        APIManager.POSTNewUserWithParams(params) { (success) in
            if success {
                self.navigationController!.popViewControllerAnimated(true)
            }
        }
    }
}
