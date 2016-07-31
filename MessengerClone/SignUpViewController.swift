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
        
        Alamofire.request(.POST, "http://localhost:4000/api/v1/users", parameters: params, encoding: .JSON, headers: nil).responseData() { response in
            guard let data = response.data
                else { return }
            
            let json = JSON(data: data)
            let responseUserID = json["id"]
            let responseUsername = json["username"]
            let responseName = json["name"]
            
            print("(\(responseUserID)) \(responseUsername) - \(responseName)")
            
            guard let httpResponse = response.response
                where httpResponse.statusCode == 201
                else { return }
            
            self.navigationController!.popViewControllerAnimated(true)
        }
    }
}
