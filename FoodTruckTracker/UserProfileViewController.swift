//
//  UserProfileViewController.swift
//  FoodTruckTracker
//
//  Created by dp on 5/4/16.
//  Copyright © 2016 Dan Park. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // MARK: Properties
    let visitedTrucks = ["Joni's", "Jeff's", "Joey's"]
    let couponTrucks = ["Joni's"]
    
    // MARK: View Management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self

    }
    
    // MARK: TableViewDelegate Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var returnValue = 0
        
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            returnValue = visitedTrucks.count
            break
        case 1:
            returnValue = couponTrucks.count
            break
        default:
            break
        }
        
        return returnValue
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserProfileCell")
        
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            cell?.textLabel!.text = visitedTrucks[indexPath.row]
            break
        case 1:
            cell?.textLabel!.text = couponTrucks[indexPath.row]
            break
        default:
            break
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (self.segmentedControl.selectedSegmentIndex == 1) {
            performSegueWithIdentifier("couponSegue", sender: indexPath.row)
        } else {
            return
        }
    }

    
    // MARK: IBActions
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        
        self.tableView.reloadData()
    }
    

}
