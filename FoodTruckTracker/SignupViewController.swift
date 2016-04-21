//
//  SignupViewController.swift
//  FoodTruckTracker
//
//  Created by dp on 4/21/16.
//  Copyright © 2016 Dan Park. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func onCreateButtonTapped(sender: UIButton) {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        guard email?.characters.count > 0 else { return }
        guard password?.characters.count > 0 else { return }
        self.newUserCreation(email!, password: password!)
    }
    
    func newUserCreation (email: String, password: String) {
        let ref = DataService.dataService.REF_BASE
        ref.createUser(email, password: password) { (error, result) in
            if error != nil {
                print(error)
            } else {
                let uid = result["uid"] as? String
                print("Successfully created user account with uid: \(uid)")
            }
        }
    }

}
