//
//  LoginViewController.swift
//  FoodTruckTracker
//
//  Created by dp on 4/20/16.
//  Copyright © 2016 Dan Park. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FoodTruckDelegate {
    @IBOutlet weak var foodTruckLoginButton: UIButton!

    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.passwordTextField.secureTextEntry = true
        foodTruckLoginButton.hidden = false
        
    }
    
//    override func viewDidAppear(animated: Bool) {
//        if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil {
//            self.performSegueWithIdentifier("ToMapSegue", sender: nil)
//        }
//    }
    
    func isUserFoodTruck(foodTruck: Bool) {
        if foodTruck{
            print("User is a foodTruck")
        } else {
            foodTruckLoginButton.hidden = true
        }
    }
    
    
    @IBAction func onLoginButtonTapped(sender: UIButton) {
        guard let email = self.emailAddressTextField!.text where !email.isEmpty else { return }
        guard let password = self.passwordTextField!.text where !password.isEmpty else { return }
        loginUser(email, password: password, foodTruck: false)
    }
    
    func loginUser(email: String, password: String, foodTruck: Bool) {
        let ref = DataService.dataService.REF_BASE
        ref.authUser(email, password: password) { (error, authData) in
            if error != nil {
                print(error)
                self.alertLoginError()
            } else {
                NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                print("Succesfully logged in")
                if foodTruck {
                   self.performSegueWithIdentifier("foodTruckSegue", sender: nil)
                }
                else {
                    self.performSegueWithIdentifier("ToMapSegue", sender: nil)
                }
                
            }
        }
    }
    
    func alertLoginError () {
        let alertController = UIAlertController(title: "Login Error", message: "Invalid Email Address or Password. Please retry", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    @IBAction func onFoodTruckLoginTapped(sender: AnyObject) {
        guard let email = self.emailAddressTextField!.text where !email.isEmpty else { return }
        guard let password = self.passwordTextField!.text where !password.isEmpty else { return }
        loginUser(email, password: password, foodTruck: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SignupSegue" {
            let destVC = segue.destinationViewController as! SignupViewController
            destVC.delegate = self
        }
    }

}
