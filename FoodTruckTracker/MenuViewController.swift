//
//  MenuViewController.swift
//  FoodTruckTracker
//
//  Created by Dylan Bruschi on 5/4/16.
//  Copyright © 2016 Dan Park. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var foodTruck = FoodTruck?()

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = conversion(foodTruck!.menu)
    }
    
    @IBAction func onBackButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    @IBAction func onFlagTapped(sender: AnyObject) {
        let alert = UIAlertController(title: "Flag this image as inappropriate?", message: "Flagging an image will hide it from all users", preferredStyle: .Alert)
        let yesAction = UIAlertAction(title: "Yes", style: .Default) { UIAlertAction in
            let ref = DataService.dataService.REF_BASE.childByAppendingPath("foodTrucks").childByAppendingPath(self.foodTruck!.uid)
            let truckDict = ["menu": ""]
            ref.updateChildValues(truckDict)
            self.imageView.image = UIImage(named: "question")!
        }
        let noAction = UIAlertAction(title: "No", style: .Default, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func conversion(post: String) -> UIImage {
        if post == "" {
            return UIImage(named: "question")!
        } else {
            let imageData = NSData(base64EncodedString: post, options: [] )
            let image = UIImage(data: imageData!)
            return image!
        }
    }
    
    
}
