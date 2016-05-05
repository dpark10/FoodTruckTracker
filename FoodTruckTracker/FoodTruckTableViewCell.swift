//
//  FoodTruckTableViewCell.swift
//  FoodTruckTracker
//
//  Created by Dylan Bruschi on 4/26/16.
//  Copyright © 2016 Dan Park. All rights reserved.
//

import UIKit
import Cosmos

protocol TableCellFlagDelegate {
    func tableCellFlagTapped(sender:UITableViewCell)
}

class FoodTruckTableViewCell: UITableViewCell {
    
    var userID: String = ""
    var delegate: TableCellFlagDelegate? = nil
    
    @IBOutlet weak var logoImage: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberOfRatingsLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    @IBOutlet weak var catagoryLabel: UILabel!
    
    @IBOutlet weak var ratingView: CosmosView!
    

    @IBAction func onFlagTapped(sender: AnyObject) {
        if (delegate != nil){
            let cell = self
                delegate!.tableCellFlagTapped(cell)
            
            }
    }

    
}
