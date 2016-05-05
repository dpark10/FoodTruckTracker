//
//  SignupViewController.swift
//  FoodTruckTracker
//
//  Created by dp on 4/21/16.
//  Copyright © 2016 Dan Park. All rights reserved.
//

import UIKit

protocol FoodTruckDelegate {
    func isUserFoodTruck(foodTruck:Bool)
}

class SignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var picker = UIImagePickerController()
    
    var delegate: FoodTruckDelegate? = nil
    
    
    @IBOutlet weak var checkBox: CheckBoxButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        categoryTextField.hidden = true
        phoneTextField.hidden = true

        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

    }
    
    //TO DO: set up image picker delegates; See InstaGram

    @IBAction func onCreateButtonTapped(sender: UIButton) {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        guard email?.characters.count > 0 else { return }
        guard password?.characters.count > 0 else { return }
        self.newUserCreation(email!, password: password!)
        if (delegate != nil){
            if checkBox.imageView?.image! == UIImage(named: "checked") {
                delegate!.isUserFoodTruck(true)
            }else if checkBox.imageView?.image! == UIImage(named: "unchecked") {
                delegate!.isUserFoodTruck(false)
            }
        }
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
                    let userDictionary : NSDictionary = ["name": self.nameTextField.text! as String, "email":  self.emailTextField.text! as String, "userID": uid!, "category": self.categoryTextField.text! as String, "lat": 0 as Double, "long": 0 as Double, "logo": "" as String, "rating": 0 as Double, "numberOfRatings": 0 as Int, "menu": "" as String, "phone": self.phoneTextField.text! as String, "userGenerated?": true, "foodTruck?": true, "couponDesc": "" as String, "couponCode": "" as String, "couponDiscount": "" as String, "couponExp": "" as String, "departureTime": "" as String]
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
    
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    
    
    
    
    
    func alertSignupError () {
        let alertController = UIAlertController(title: "Signup Error", message: "User email already exists. Please try again.", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    @IBAction func onBoxChecked(sender: UIButton) {
    
        if sender.imageView?.image == UIImage(named: "unchecked") {
        categoryTextField.hidden = false
        phoneTextField.hidden = false
        }
        else {
            categoryTextField.hidden = true
            phoneTextField.hidden = true
        }

        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func onBackButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
