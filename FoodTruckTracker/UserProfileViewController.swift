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
    let otherTrucks = ["Joni's", "Jeff's", "Joey's"]
    let couponTrucks = ["Joni's"]
    var visitedTrucks = [VisitedTruck]()
    var coupons = [Coupon]()
    
    // MARK: View Management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let truckRef = DataService.dataService.REF_BASE.childByAppendingPath("visitedTrucks")
        truckRef.queryOrderedByChild("userID").queryEqualToValue(NSUserDefaults.standardUserDefaults().valueForKey("uid")).observeEventType(.ChildAdded, withBlock: { snapshot in
            let visitedTruck = VisitedTruck.init(snapshot: snapshot)
            self.visitedTrucks.append(visitedTruck)
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        })
        
        let couponRef = DataService.dataService.REF_BASE.childByAppendingPath("coupons")
        couponRef.queryOrderedByChild("userID").queryEqualToValue(NSUserDefaults.standardUserDefaults().valueForKey("uid")).observeEventType(.ChildAdded, withBlock: { snapshot in
            let coupon = Coupon.init(snapshot: snapshot)
            self.coupons.append(coupon)
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        })
        

    }
    
    // MARK: TableViewDelegate Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var returnValue = 0
        
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            returnValue = visitedTrucks.count
            break
        case 1:
            returnValue = coupons.count
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
            let visitedTruck = visitedTrucks[indexPath.row] as VisitedTruck
            cell?.textLabel!.text = visitedTruck.name
            break
        case 1:
            let coupon = coupons[indexPath.row]
            cell?.textLabel!.text = coupon.foodTruck
            cell?.detailTextLabel!.text = coupon.couponDiscount
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//         let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        let indexPath = tableView.indexPathForSelectedRow
        let coupon = coupons[indexPath!.row]
        let destVC = segue.destinationViewController as! QRCodeViewController
        destVC.coupon = coupon
    }

    
    // MARK: IBActions
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        
        self.tableView.reloadData()
    }
    

}
