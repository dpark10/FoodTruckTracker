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
    
    override func viewDidAppear(animated: Bool) {
        if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil {
            self.performSegueWithIdentifier("ToMapSegue", sender: nil)
        }
    }
    
    
    @IBAction func onLoginButtonTapped(sender: UIButton) {
        guard let email = self.emailAddressTextField!.text where !email.isEmpty else { return }
        guard let password = self.passwordTextField!.text where !password.isEmpty else { return }
        self.loginUser(email, password: password)
    }
    
    func loginUser(email: String, password: String) {
        let ref = DataService.dataService.REF_BASE
        ref.authUser(email, password: password) { (error, authData) in
            if error != nil {
                print(error)
                self.alertLoginError()
            } else {
                NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                print("Succesfully logged in")
                self.performSegueWithIdentifier("ToMapSegue", sender: nil)
            }
        }
    }
    
    func alertLoginError () {
        let alertController = UIAlertController(title: "Login Error", message: "Invalid Email Address or Password. Please retry", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }


}
