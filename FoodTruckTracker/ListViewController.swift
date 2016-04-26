//
//  ListViewController.swift
//  FoodTruckTracker
//
//  Created by dp on 4/19/16.
//  Copyright © 2016 Dan Park. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    
    // MARK: - Properties
    var foodTrucks = [FoodTruck]()
    var filteredFoodTrucks = [FoodTruck]()
     var searchActive: Bool = false

    
    
    // MARK: - IBOutlets
    @IBOutlet weak var foodTruckTableView: UITableView!
    
    
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
        if filteredFoodTrucks.count == 0 {
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
        if(searchActive) {
            let foodTruck = filteredFoodTrucks[indexPath.row]
            cell.titleLabel.text = foodTruck.name
            load_image(foodTruck.logo, cell: cell, logo: true)
            load_image(foodTruck.ratingImage, cell: cell, logo: false)
            cell.numberOfRatingsLabel.text = String(foodTruck.yelpReviewCount)
            cell.titleLabel.preferredMaxLayoutWidth = cell.titleLabel.frame.size.width
        }
        else{
            let foodTruck = foodTrucks[indexPath.row]
            cell.titleLabel.text = foodTruck.name
            load_image(foodTruck.logo, cell: cell, logo: true)
            load_image(foodTruck.ratingImage, cell: cell, logo: false)
            cell.numberOfRatingsLabel.text = String(foodTruck.yelpReviewCount)
            cell.titleLabel.preferredMaxLayoutWidth = cell.titleLabel.frame.size.width

        }
        
        return cell
    }
    
    
    func load_image(urlString:String, cell:FoodTruckTableViewCell, logo:Bool)
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
                        cell.logoImage.image = UIImage(data: data!)
                        cell.logoImage.layer.cornerRadius = 5
                        cell.logoImage.clipsToBounds = true
                    }
                    else {
                        cell.ratingImage.image = UIImage(data: data!)
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), display_image)
            }
            
        }
        
        task.resume()
    }
    
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

}
