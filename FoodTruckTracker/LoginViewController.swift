//
//  LoginViewController.swift
//  FoodTruckTracker
//
//  Created by dp on 4/20/16.
//  Copyright © 2016 Dan Park. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func onLoginButtonTapped(sender: UIButton) {
        let email = emailAddressTextField.text
        let password = passwordTextField.text
        
        guard email?.characters.count != 0 else { return }
        guard password?.characters.count != 0 else { return }
        self.loginUser(email!, password: password!)
    }
    
    func loginUser(email: String, password: String) {
        let ref = DataService.dataService.REF_BASE
        ref.authUser(email, password: password) { (error, authData) in
            if error != nil {
                print(error)
            } else {
                self.performSegueWithIdentifier("ToMainScreen", sender: nil)
            }
        }
        
        
    }


}
