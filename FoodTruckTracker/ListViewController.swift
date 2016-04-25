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
        let cell = foodTruckTableView.dequeueReusableCellWithIdentifier("FoodTruckCell", forIndexPath: indexPath)
        if(searchActive) {
            let foodTruck = filteredFoodTrucks[indexPath.row]
            cell.textLabel!.text = foodTruck.name
        }
        else{
            let foodTruck = foodTrucks[indexPath.row]
            cell.textLabel!.text = foodTruck.name
        }
        
        return cell
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
