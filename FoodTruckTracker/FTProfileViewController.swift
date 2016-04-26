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
        numberOfReviewsLabel.text = "\(foodTruck.yelpReviewCount) Reviews"
        phoneNumberLabel.text = foodTruck.phone
        
        load_image(foodTruck.ratingImage)
        
    }
    

    func load_image(urlString:String)
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
                    self.yelpRatingImageView.image = UIImage(data: data!)
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
