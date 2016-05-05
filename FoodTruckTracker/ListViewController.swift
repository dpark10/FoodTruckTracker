//
//  ListViewController.swift
//  FoodTruckTracker
//
//  Created by dp on 4/19/16.
//  Copyright © 2016 Dan Park. All rights reserved.
//

import UIKit
import CoreLocation

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, TableCellFlagDelegate {

    
    // MARK: - Properties
    var foodTrucks = [FoodTruck]()
    var filteredFoodTrucks = [FoodTruck]()
     var searchActive: Bool = false

    
    
    // MARK: - IBOutlets
    @IBOutlet weak var foodTruckTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // MARK: - View Management
    override func viewDidLoad() {
        super.viewDidLoad()
        foodTruckTableView.rowHeight = UITableViewAutomaticDimension
        foodTruckTableView.estimatedRowHeight = 120

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.foodTruckTableView.reloadData()
    }
    override func viewWillDisappear(animated: Bool) {
        filteredFoodTrucks.removeAll()
        searchBar.text = ""
        searchActive = false
        searchBar.resignFirstResponder()
        
    }
    
    func tableCellFlagTapped(cell: FoodTruckTableViewCell) {
        let indexPath = foodTruckTableView.indexPathForCell(cell)
        if (searchActive) {
            let foodTruck = filteredFoodTrucks[indexPath!.row]
            let alert = UIAlertController(title: "Flag this image as inappropriate?", message: "Flagging an image will hide it from all users", preferredStyle: .Alert)
            let yesAction = UIAlertAction(title: "Yes", style: .Default) { UIAlertAction in
                let ref = DataService.dataService.REF_BASE.childByAppendingPath("foodTrucks").childByAppendingPath(foodTruck.uid)
                let truckDict = ["menu": ""]
                ref.updateChildValues(truckDict)
                cell.logoImage.image = UIImage(named: "question")!
            }
            let noAction = UIAlertAction(title: "No", style: .Default, handler: nil)
            alert.addAction(yesAction)
            alert.addAction(noAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
         
        } else {
            let foodTruck = foodTrucks[indexPath!.row]
            let alert = UIAlertController(title: "Flag this image as inappropriate?", message: "Flagging an image will hide it from all users", preferredStyle: .Alert)
            let yesAction = UIAlertAction(title: "Yes", style: .Default) { UIAlertAction in
                let ref = DataService.dataService.REF_BASE.childByAppendingPath("foodTrucks").childByAppendingPath(foodTruck.uid)
                let truckDict = ["logo": ""]
                ref.updateChildValues(truckDict)
                cell.logoImage.image = UIImage(named: "question")!
            }
            let noAction = UIAlertAction(title: "No", style: .Default, handler: nil)
            alert.addAction(yesAction)
            alert.addAction(noAction)
            
            self.presentViewController(alert, animated: true, completion: nil)

           

    }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredFoodTrucks = foodTrucks.filter({ (foodTruck) -> Bool in
            let tmp: FoodTruck = foodTruck
            let range = (tmp.name as NSString).rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if filteredFoodTrucks.count == 0 && searchBar.text != "" {
            searchActive = true;
        } else if filteredFoodTrucks.count == 0 && searchBar.text == "" {
            searchActive = false;
        } else {
            searchActive = true;
        }
        foodTruckTableView.reloadData()
    }
    
    
    
    // MARK: - TableViewDelegate Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filteredFoodTrucks.count
        } else {
        return foodTrucks.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = foodTruckTableView.dequeueReusableCellWithIdentifier("FoodTruckCell", forIndexPath: indexPath) as! FoodTruckTableViewCell
        if searchActive && filteredFoodTrucks.count > 0 {
            let foodTruck = filteredFoodTrucks[indexPath.row]
            getAddressFromGeocodeCoordinate(CLLocation(latitude: foodTruck.lat, longitude: foodTruck.long), cell: cell)
            cell.delegate = self
            cell.titleLabel.text = foodTruck.name
            cell.logoImage.image = conversion(foodTruck.logo)
            cell.logoImage.layer.cornerRadius = 5
            cell.logoImage.clipsToBounds = true
            cell.ratingView.rating = foodTruck.rating
            cell.numberOfRatingsLabel.text = String(foodTruck.yelpReviewCount)
            cell.titleLabel.preferredMaxLayoutWidth = cell.titleLabel.frame.size.width
            cell.catagoryLabel.text = foodTruck.category
            cell.addressLabel.text = foodTruck.address
            cell.distanceLabel.text = String(format: "%0.2f mi.", foodTruck.distance)
        } else if searchActive && filteredFoodTrucks.count == 0{
            cell.titleLabel?.text = "Your search did not match any entries. Try again."
            
        }
        else{
            let foodTruck = foodTrucks[indexPath.row]
            getAddressFromGeocodeCoordinate(CLLocation(latitude: foodTruck.lat, longitude: foodTruck.long), cell: cell)
            cell.delegate = self
            cell.titleLabel.text = foodTruck.name
            cell.logoImage.image = conversion(foodTruck.logo)
            cell.logoImage.layer.cornerRadius = 5
            cell.logoImage.clipsToBounds = true
            cell.ratingView.rating = foodTruck.rating
            cell.numberOfRatingsLabel.text = String(foodTruck.yelpReviewCount)
            cell.titleLabel.preferredMaxLayoutWidth = cell.titleLabel.frame.size.width
            cell.catagoryLabel.text = foodTruck.category
            cell.addressLabel.text = foodTruck.address
            cell.distanceLabel.text = String(format: "%0.2f mi.", foodTruck.distance)


        }
        
        return cell
    }
    
    func getAddressFromGeocodeCoordinate(location: CLLocation, cell:FoodTruckTableViewCell) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks: [CLPlacemark]?, error: NSError?) in
            let placemark = placemarks?.first
            if let subT = placemark?.subThoroughfare {
                let address = "\(subT) \(placemark!.thoroughfare!), \(placemark!.locality!)"
                cell.addressLabel.text = address
            }
        }
    }
    
//    
//    func load_image(urlString:String, cell:FoodTruckTableViewCell, logo:Bool)
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
//                        cell.logoImage.image = UIImage(data: data!)
//                        cell.logoImage.layer.cornerRadius = 5
//                        cell.logoImage.clipsToBounds = true
//                    }
//                    else {
//                        cell.ratingImage.image = UIImage(data: data!)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let indexPath = foodTruckTableView.indexPathForCell(sender as! UITableViewCell)
        if (searchActive) {
            let foodTruck = filteredFoodTrucks[indexPath!.row]
            let destVC = segue.destinationViewController as! FTProfileViewController
            destVC.foodTruck = foodTruck
        } else {
        let foodTruck = foodTrucks[indexPath!.row]
            let destVC = segue.destinationViewController as! FTProfileViewController
            destVC.foodTruck = foodTruck
        }
        
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
