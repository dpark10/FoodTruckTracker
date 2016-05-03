//
//  FTProfileViewController.swift
//  FoodTruckTracker
//
//  Created by dp on 4/21/16.
//  Copyright © 2016 Dan Park. All rights reserved.
//

import UIKit
import Cosmos
import CoreLocation

class FTProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var foodTruckNameLabel: UILabel!
    @IBOutlet weak var numberOfReviewsLabel: UILabel!
    @IBOutlet weak var yelpCategoriesLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var ratingView: CosmosView!
    var foodTruck = FoodTruck?()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodTruckNameLabel.text = foodTruck!.name
        numberOfReviewsLabel.text = "\(foodTruck!.yelpReviewCount) Reviews"
        phoneNumberLabel.text = foodTruck!.phone
        getAddressFromGeocodeCoordinate(CLLocation(latitude: foodTruck!.lat, longitude: foodTruck!.long))
        logoImage.image = conversion(foodTruck!.logo)
        logoImage.layer.cornerRadius = 5
        logoImage.clipsToBounds = true
        ratingView.rating = foodTruck!.rating
        distanceLabel.text = String(format: "%0.2f mi." ,foodTruck!.distance)
        yelpCategoriesLabel.text = foodTruck!.category
        
        

    }
    

//    func load_image(urlString: String, logo: Bool)
//    {
//        let imgURL: NSURL = NSURL(string: urlString)!
//        let request: NSURLRequest = NSURLRequest(URL: imgURL)
//        
//        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithRequest(request){
//            (data, response, error) -> Void in
//            
//            if (error == nil && data != nil)
//            {
//                func display_image()
//                {
//                    if logo == true {
//                        self.logoImage.image = UIImage(data: data!)
//                        self.logoImage.layer.cornerRadius = 5
//                        self.logoImage.clipsToBounds = true
//
//                    } else {
//                        self.yelpRatingImageView.image = UIImage(data: data!)
//                    }
//                }
//                
//                dispatch_async(dispatch_get_main_queue(), display_image)
//            }
//            
//        }
//        
//        task.resume()
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        //return foodTruck.comments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! CommentTableViewCell
        cell.foodTruck = foodTruck
//        let comment = foodTruck.comments[indexPath.row]
        //cell.ratingView.rating = comment
        //cell.commentTextView.text =
        return cell
    }
    

    @IBAction func onBackButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func conversion(post: String) -> UIImage {
        let imageData = NSData(base64EncodedString: post, options: [] )
        let image = UIImage(data: imageData!)
        return image!
    }
    
    func getAddressFromGeocodeCoordinate(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks: [CLPlacemark]?, error: NSError?) in
            let placemark = placemarks?.first
            if let subT = placemark?.subThoroughfare {
                let address = "\(subT) \(placemark!.thoroughfare!), \(placemark!.locality!)"
                self.addressLabel.text = address
            }
        }
    }
    
    


}
