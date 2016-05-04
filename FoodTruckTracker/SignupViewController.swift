//
//  SignupViewController.swift
//  FoodTruckTracker
//
//  Created by dp on 4/21/16.
//  Copyright © 2016 Dan Park. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var picker = UIImagePickerController()
    
    
    @IBOutlet weak var checkBox: CheckBoxButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        categoryTextField.hidden = true
        addressTextField.hidden = true
        urlTextField.hidden = true
        phoneTextField.hidden = true
        twitterTextField.hidden = true
        yelpTextField.hidden = true

    }
    
    //TO DO: set up image picker delegates; See InstaGram

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
                self.alertSignupError()
            } else {
                
                let uid = result["uid"] as? String
                if self.checkBox.imageView?.image == UIImage(named: "checked") {
                    let userDictionary : NSDictionary = ["name": self.nameTextField.text! as String, "email":  self.emailTextField.text! as String, "userID": uid!, "category": self.categoryTextField.text! as String, "lat": 0 as Double, "long": 0 as Double, "logo": "" as String, "rating": 0 as Double, "numberOfRatings": 0 as Int, "url": self.urlTextField.text! as String, "phone": self.phoneTextField.text! as String, "twitter": self.twitterTextField.text! as String, "yelp": self.yelpTextField.text! as String, "userGenerated?": true, "foodTruck?": true]
                    let userRef = DataService.dataService.REF_BASE.childByAppendingPath("foodTrucks").childByAppendingPath(uid)
                    userRef.setValue(userDictionary)
                    let oldTruckRef = DataService.dataService.REF_BASE.childByAppendingPath("foodTrucks").childByAppendingPath(self.nameTextField!.text)
                    oldTruckRef.removeValue()
                    print("Successfully created user account with uid: \(uid)")
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                else {
                    let userDictionary : NSDictionary = ["name": self.nameTextField.text! as String, "email": self.emailTextField.text! as String, "uid": uid!, "foodTruck?": false]
                    let userRef = DataService.dataService.REF_BASE.childByAppendingPath("users").childByAppendingPath(uid)
                    userRef.setValue(userDictionary)
                    print("Successfully created user account with uid: \(uid)")
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                }
            }
        }
    }
    @IBOutlet weak var categoryTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var urlTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var twitterTextField: UITextField!
    
    @IBOutlet weak var yelpTextField: UITextField!
    
    
    
    
    
    func alertSignupError () {
        let alertController = UIAlertController(title: "Signup Error", message: "User email already exists. Please try again.", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    @IBAction func onBoxChecked(sender: UIButton) {
    
        if sender.imageView?.image == UIImage(named: "unchecked") {
        categoryTextField.hidden = false
        addressTextField.hidden = false
        urlTextField.hidden = false
        phoneTextField.hidden = false
        twitterTextField.hidden = false
        yelpTextField.hidden = false
        }
        else {
            categoryTextField.hidden = true
            addressTextField.hidden = true
            urlTextField.hidden = true
            phoneTextField.hidden = true
            twitterTextField.hidden = true
            yelpTextField.hidden = true
        }

        
    }
}
