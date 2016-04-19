//
//  ListViewController.swift
//  FoodTruckTracker
//
//  Created by dp on 4/19/16.
//  Copyright © 2016 Dan Park. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    var foodTrucks = []
    
    @IBOutlet weak var foodTruckTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    // MARK: - TableViewDelegate Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodTrucks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = foodTruckTableView.dequeueReusableCellWithIdentifier("FoodTruckCell", forIndexPath: indexPath)
        return cell
    }

}
