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
import Firebase

class FTProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    @IBOutlet weak var foodTruckNameLabel: UILabel!
    @IBOutlet weak var numberOfReviewsLabel: UILabel!
    @IBOutlet weak var yelpCategoriesLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var newRatingView: CosmosView!
    
    @IBOutlet weak var commentTextView: UITextView!
    
    
    @IBOutlet weak var ratingView: CosmosView!
    var foodTruck = FoodTruck?()
    var comments = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextView.delegate = self
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.redColor().CGColor
        foodTruckNameLabel.text = foodTruck!.name
        phoneNumberLabel.text = foodTruck!.phone
        getAddressFromGeocodeCoordinate(CLLocation(latitude: foodTruck!.lat, longitude: foodTruck!.long))
        logoImage.image = conversion(foodTruck!.logo)
        logoImage.layer.cornerRadius = 5
        logoImage.clipsToBounds = true
        ratingView.rating = foodTruck!.rating
        distanceLabel.text = String(format: "%0.2f mi." ,foodTruck!.distance)
        yelpCategoriesLabel.text = foodTruck!.category
        
        let ref = DataService.dataService.REF_BASE.childByAppendingPath("comments")
        
        ref.queryOrderedByChild("foodTruck").queryEqualToValue(foodTruck!.name).observeEventType(.ChildAdded, withBlock: { snapshot in
//            let enumerator = snapshot.children
//            while let rest = enumerator.nextObject() as? FDataSnapshot {
                let comment = Comment.init(snapshot: snapshot)
                self.comments.append(comment)
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                    let numberOfReviews = (self.foodTruck?.yelpReviewCount)! + self.comments.count
                    self.numberOfReviewsLabel.text = "\(numberOfReviews) Reviews"
                }
            })
        
        
        

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
        return self.comments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! CommentTableViewCell
        cell.foodTruck = foodTruck
        let comment = comments[indexPath.row]
        cell.ratingView.rating = comment.rating
        cell.commentTextView.text = comment.text
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
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            let ref = DataService.dataService.REF_BASE.childByAppendingPath("comments").childByAutoId()
            let comment: NSDictionary = ["rating": newRatingView.rating as Double, "text": commentTextView.text as String, "foodTruck" : foodTruck!.name as String, "userID": NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String]
            ref.setValue(comment)
            print("comment saved!")
            let foodTruckRef = DataService.dataService.REF_BASE.childByAppendingPath("foodTrucks").childByAppendingPath(self.foodTruck!.uid)
            let newRatingNumerator = Double((foodTruck!.rating * Double(foodTruck!.yelpReviewCount)) + newRatingView.rating)
            let newRatingDenominator = Double((foodTruck!.rating * Double(foodTruck!.yelpReviewCount)) + 5)
            let newRating = newRatingNumerator/newRatingDenominator
            let newNumberOfRatings = (foodTruck?.yelpReviewCount)! + comments.count + 1
            foodTruckRef.updateChildValues(["rating": newRating as Double, "numberOfRatings": newNumberOfRatings as Int])
            commentTextView.text = ""
            newRatingView.rating = 0
            textView.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func onGetCouponButtonTapped(sender: AnyObject) {
        print("coupon button tapped")
        let couponRef = DataService.dataService.REF_BASE.childByAppendingPath("coupons").childByAutoId()
        let couponDict = ["couponCode": "\(foodTruck!.couponCode).\(NSUserDefaults.standardUserDefaults().valueForKey("uid")).\(couponRef.key)", "couponDesc": (foodTruck?.couponDesc)! as String, "couponDiscount": (foodTruck?.couponDiscount)! as String, "active?": true, "couponExp": (foodTruck?.couponExp)! as String, "foodTruck": (foodTruck?.name)! as String, "userID": NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String]
        couponRef.setValue(couponDict)
    }
    


}
