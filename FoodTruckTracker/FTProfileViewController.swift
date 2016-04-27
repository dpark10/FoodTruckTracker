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
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    
    var foodTruck = FoodTruck()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodTruckNameLabel.text = foodTruck.name
        numberOfReviewsLabel.text = "\(foodTruck.yelpReviewCount) Reviews"
        phoneNumberLabel.text = foodTruck.phone
        addressLabel.text = foodTruck.address
        load_image(foodTruck.logo, logo: true)
        load_image(foodTruck.ratingImage, logo: false)
        distanceLabel.text = String(format: "%0.2f mi." ,foodTruck.distance)
        yelpCategoriesLabel.text = foodTruck.category
        
        
    }
    

    func load_image(urlString: String, logo: Bool)
    {
        let imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            if (error == nil && data != nil)
            {
                func display_image()
                {
                    if logo == true {
                        self.logoImage.image = UIImage(data: data!)
                        self.logoImage.layer.cornerRadius = 5
                        self.logoImage.clipsToBounds = true

                    } else {
                        self.yelpRatingImageView.image = UIImage(data: data!)
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), display_image)
            }
            
        }
        
        task.resume()
    }
    

    @IBAction func onBackButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }


}
