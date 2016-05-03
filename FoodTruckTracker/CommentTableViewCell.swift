//
//  CommentTableViewCell.swift
//  FoodTruckTracker
//
//  Created by Dylan Bruschi on 5/1/16.
//  Copyright © 2016 Dan Park. All rights reserved.
//

import UIKit
import Cosmos

class CommentTableViewCell: UITableViewCell{
    
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var ratingView: CosmosView!
    
    var foodTruck: FoodTruck?
    
    
    override func awakeFromNib() {
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.redColor().CGColor

    }
    


}
