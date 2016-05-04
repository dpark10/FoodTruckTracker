//
//  CouponViewController.swift
//  FoodTruckTracker
//
//  Created by dp on 5/2/16.
//  Copyright © 2016 Dan Park. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CouponViewController: UIViewController, UIScrollViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var twitterTextField: UITextField!
    @IBOutlet weak var yelpIDTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var couponDescTextField: UITextField!
    @IBOutlet weak var discountAmtTextField: UITextField!
    @IBOutlet weak var expDateTextField: UITextField!
    @IBOutlet weak var imageButton: UIButton!
//    var foodTruck = FoodTruck?()
    
    // MARK: Properties
    var locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    var activeField: UITextField?
    let imagePicker = UIImagePickerController()
    var foodTruckLogoImage = UIImage()
    
    
    // MARK: View Management
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(NSUserDefaults.standardUserDefaults().valueForKey("uid"))

        
        let ref = DataService.dataService.REF_BASE.childByAppendingPath("foodTrucks").childByAppendingPath(NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String)
        
        ref.observeEventType(.Value, withBlock: { snapshot in
            let foodTruck = FoodTruck.init(snapshot: snapshot)
            dispatch_async(dispatch_get_main_queue()) {
                self.nameTextField.text = foodTruck.name
                self.categoryTextField.text = foodTruck.category
                self.phoneTextField.text = foodTruck.phone
                self.websiteTextField.text = foodTruck.url
                self.yelpIDTextField.text = foodTruck.yelpID
                //see loader function
            }
            })
        
        scrollView.delegate = self
        scrollView.addSubview(contentView)
        scrollView.contentSize = CGSize(width:340, height:900)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        imagePicker.delegate = self
        
        self.registerForKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.deregisterFromKeyboardNotifications()
    }

    
    func registerForKeyboardNotifications()
    {
        //Adding notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CouponViewController.keyboardWasShown(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CouponViewController.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification)
    {
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.scrollEnabled = true
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeFieldPresent = activeField
        {
            if (!CGRectContainsPoint(aRect, activeField!.frame.origin))
            {
                self.scrollView.scrollRectToVisible(activeField!.frame, animated: true)
            }
        }
        
        
    }
    
    
    func keyboardWillBeHidden(notification: NSNotification)
    {
        //Once keyboard disappears, restore original positions
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.contentInset = UIEdgeInsetsZero
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField!)
    {
        activeField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField!)
    {
        activeField = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width:340, height:900)
    }
    
    
    // MARK: IBActions
    
    @IBAction func setFoodTruckLocation(sender: UIButton) {
        print("Button Tapped")
        //TO DO: Add food truck pin to mapView

    }
    
    @IBAction func addImageButtonTapped(sender: AnyObject) {
        print("Button Tapped")
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func hideKeyboard(sender: AnyObject) {
        nameTextField.endEditing(true)
        categoryTextField.endEditing(true)
        phoneTextField.endEditing(true)
        websiteTextField.endEditing(true)
        emailTextField.endEditing(true)
        twitterTextField.endEditing(true)
        yelpIDTextField.endEditing(true)
        couponDescTextField.endEditing(true)
        discountAmtTextField.endEditing(true)
        expDateTextField.endEditing(true)
    }
    
    // MARK: CLLocationManagerDelegate Methods
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        locationManager.stopUpdatingLocation()
        let userLocation = mapView.userLocation
        let region = MKCoordinateRegionMakeWithDistance(userLocation.location!.coordinate, 5000, 5000)
        mapView.setRegion(region, animated: true)
        self.userLocation = userLocation.location!.coordinate
        print(self.userLocation)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.foodTruckLogoImage = pickedImage
            imageButton.setImage(self.foodTruckLogoImage, forState: .Normal)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }


    @IBAction func onSaveButtonTapped(sender: AnyObject) {
        let foodTruckRef = DataService.dataService.REF_BASE.childByAppendingPath("foodTrucks").childByAppendingPath(NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String)
        let userDictionary : NSDictionary = ["name": self.nameTextField.text! as String, "email":  self.emailTextField.text!, "category": self.categoryTextField.text! as String, "lat": Double(self.userLocation.latitude), "long": Double(self.userLocation.longitude), "logo": conversion((imageButton.imageView?.image)!) as String, "url": self.websiteTextField.text! as String, "phone": self.phoneTextField.text! as String, "yelp": self.yelpIDTextField.text! as String]
        
        foodTruckRef.updateChildValues(userDictionary as [NSObject : AnyObject])
        let couponRef = DataService.dataService.REF_BASE.childByAppendingPath("coupons").childByAppendingPath(self.nameTextField.text! as String)
        let couponDictionary : NSDictionary = ["foodTruck": self.nameTextField.text!, "description": self.couponDescTextField.text! as String, "discount": (self.discountAmtTextField.text! as String), "expDate": (self.expDateTextField.text! as String), "active?": true]
        couponRef.setValue(couponDictionary)
        print("successfully saved info!")
    }
    
    func conversion(image: UIImage) -> String {
        let data = UIImageJPEGRepresentation(image, 0.5)
        let base64String = data!.base64EncodedStringWithOptions([])
        return base64String
    }
    
    
}
