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
    
    
    // MARK: - TableViewDelegate Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodTrucks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = foodTruckTableView.dequeueReusableCellWithIdentifier("FoodTruckCell", forIndexPath: indexPath)
        let foodTruck = foodTrucks[indexPath.row]
        cell.textLabel!.text = foodTruck.name
        return cell
    }

}
