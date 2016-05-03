//
//  CommentTableViewCell.swift
//  FoodTruckTracker
//
//  Created by Dylan Bruschi on 5/1/16.
//  Copyright © 2016 Dan Park. All rights reserved.
//

import UIKit
import Cosmos

class CommentTableViewCell: UITableViewCell, UITextViewDelegate{
    
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var ratingView: CosmosView!
    
    var foodTruck: FoodTruck?
    
    
    override func awakeFromNib() {
        commentTextView.delegate = self
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.redColor().CGColor

    }
    
  
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            let ref = DataService.dataService.REF_BASE.childByAppendingPath("comments").childByAutoId()
            let comment: NSDictionary = ["rating": ratingView.rating as Double, "text": commentTextView.text as String, "foodTruck" : foodTruck!.name as String, "userID": NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String]
            ref.setValue(comment)
            print("comment saved!")
            textView.resignFirstResponder()
            //Use custom delegation to reload tableView
        }
        return true
    }
    

}
