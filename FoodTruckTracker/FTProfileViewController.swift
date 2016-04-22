//
//  FTProfileViewController.swift
//  FoodTruckTracker
//
//  Created by dp on 4/21/16.
//  Copyright © 2016 Dan Park. All rights reserved.
//

import UIKit

class FTProfileViewController: UIViewController {

    @IBOutlet weak var foodTruckNameLabel: UILabel!
    @IBOutlet weak var yelpRatingImageView: UIImageView!
    @IBOutlet weak var numberOfReviewsLabel: UILabel!
    @IBOutlet weak var yelpCategoriesLabel: UILabel!
    @IBOutlet weak var foodTruckURLLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var foodTruck = FoodTruck()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodTruckNameLabel.text = foodTruck.name
        
        

    }

    @IBAction func onBackButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }


}
